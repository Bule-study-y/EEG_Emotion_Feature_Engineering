%%�������룺�ó�����A����������󣨵������ݣ���FsΪ����Ĳ����ʣ�window_tΪ�������㴰�ڣ�overlapΪ�ص�����0.5��
%%���������lamda_1����������õ������Lyapunov����ֵ��ÿwindow_t s����õ�һ��ֵ������ʱÿ���ص�window_t/2 s��M_lyaΪ��������Lyapunov��ƽ��ֵ
function [lambda_1,M_lya]=lyapunov_Rosentein(A,Fs,window_t,overlap,p)
%window_t=6;
N=Fs*window_t;
m=15;           %Ƕ��ά��
delt_t=1/Fs;    %�������
G=length(A);
g=Fs*(window_t*(1-overlap));%ÿ�λ����ĵ���
t=((G-N)/g);
h=floor(t);
for ii=0:h%�����Ĵ���
    data=A(1+ii*g:N+ii*g);
    tau=tau_def(data);%ʱ���ӳ�
    P=period(data); %���е�ƽ������
    Y=reconstitution(data,N,m,tau);%��ռ��ع�
    M=N-(m-1)*tau;       %�ع���ռ������ĸ���
     for j=1:M           %Ѱ����ռ���ÿ�������������
         d_min=1.0e+15;
          for jj=1:M
              if abs(j-jj)>P %���ƶ��ݷ���
               d_s(j,jj)=norm((Y(:,j)-Y(:,jj)),2);
               if d_s(j,jj)<d_min
                            d_min=d_s(j,jj);
                            idx_j=jj;     %������ռ���ÿ���������������±�
                end
              end
          end
        index(j)=idx_j;
        imax=min((M-j),(M-idx_j));%�����j������ݻ�ʱ�䲽��i
        for i=1:imax             
            d_j_i=0;
            d_j_i=norm((Y(:,j+i)-Y(:,idx_j+i)),2);   %�����j��������ڵ���i����ɢ����ľ���
            d(i,j)=d_j_i;     %����i*j�о���
        end
    end
    %��ÿ���ݻ�ʱ�䲽��i�������е�j��lnd(i,j)ƽ��
    [l_i,l_j]=size(d);
    for i=1:l_i
        q=0;
        y_s=0;
        for j=1:l_j
            if d(i,j)~=0
                q=q+1; %��������d(i,j)����Ŀ
                y_s=y_s+log(d(i,j));
            end
        end
        y(i)=y_s/(q*delt_t);%��ÿ��i������е�j��lnd(i,j)ƽ��
    end
    x=1:length(y);
    linearzone=[20:80];
    Lya=polyfit(x(linearzone),y(linearzone),1);
    lambda_1(ii+1)=Lya(1);
end
M_lya=mean(lambda_1);
if p==1
    plot(lambda_1);
end



         
              
              
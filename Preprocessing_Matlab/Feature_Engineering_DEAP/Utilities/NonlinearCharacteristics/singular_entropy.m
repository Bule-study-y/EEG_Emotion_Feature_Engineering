%%%%%%%%%%%%%%%%%%%   singular_entropy.m    %%%%%%%%%%%%%%%%%
%% ���ܣ����ڼ�����������
%% ���ߣ�������
%% ʱ�䣺2010.07.10
%%%window_tΪÿ�μ���Ĵ���ʱ�䳤�ȣ�overlapΪ�ص�������0.5

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [H_singu, M_H]=singular_entropy(A,Fs,window_t,overlap)
N=Fs*window_t;%ÿ�μ�������г���
G=length(A);
g=Fs*(window_t*(1-overlap));%ÿ�λ����ĵ���
t=((G-N)/g);
h=floor(t);
for ii=0:h
    data = A(1+ii*g:N+ii*g);
    % �ع���ռ�
    % mΪǶ��ռ�ά��
    % tauΪʱ���ӳ�
    % dataΪ����ʱ������
    % NΪʱ�����г���
    % XΪ���,��m*Mά����
    tau=tau_def(data);
    m = 15;
    M = N-(m-1)*tau;%��ռ��е�ĸ���
    for  j=1:M       %��ռ��ع�
        for i=1:m
            X(i,j) = data((i-1)*tau+j);
        end
    end
    
    C = (X*X')./m;  % ��Э�������
    [V,S] = eig(C); % ������ֵ����������
    for i=1:m
        a(i) = S(i,i);
    end
    amax = max(a);
    singu = log(a./amax);
    
    for i=1:m       % singu����
        for j=(i+1):m
            if singu(j)>singu(i)
                temp = singu(j);
                singu(j) = singu(i);
                singu(i) = temp;
            end
        end
        p(i)=singu(i)./sum(singu);
        if p(i)~=0
            lp(i)=log(p(i));
        else
            lp(i)=0;
        end
    end
    H_singu(ii+1)=-sum(p*lp');
end
M_H=mean(H_singu);


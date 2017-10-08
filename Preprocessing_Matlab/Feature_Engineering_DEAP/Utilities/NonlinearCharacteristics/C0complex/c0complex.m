%function c0complex(input,output) 
%�������룺�ó�����A����������󣨵������ݣ���FsΪ����Ĳ����ʣ�window_tΪ�������㴰�ڣ�overlapΪ�ص�����0.5��p�������1�򻭳�C0������ͼ
%���������C0����������õ���C0����ֵ��ÿwindow_t s����õ�һ��C0ֵ������ʱÿ���ص�window_t/2 s��C0_averageΪ���C0��ƽ��ֵ
function  [C0,C0_average]=c0complex(A,Fs,window_t,overlap,p) 
M=length(A);
N=Fs*window_t;%ÿ�μ�������г���
m=Fs*(window_t*(1-overlap));%ÿ�λ����ĵ���
r=5;
t=((M-N)/m);
h=floor(t);
for i=0:h %�����Ĵ���
    data=A(1+i*m:N+i*m);%���ݻ�����ȡ
    Fn=fft(data,N);      %��������FFT
    Fn_1=zeros(size(Fn));
    Gsum=0;
    for j=1:N
        Gsum=Gsum+abs(Fn(j))*abs(Fn(j));
    end
        Gave=(1/N)*Gsum; %�����еľ���ֵ
    for j=1:N
        if abs(Fn(j))*abs(Fn(j))>(r*Gave) %��ȡ���еĹ��򲿷ֵ�Ƶ��
           Fn_1(j)=Fn(j);
        end
    end
    data1=ifft(Fn_1,N);%��ȡ���еĹ��򲿷�
    D=(abs(data(1:N)-data1)).^2;%��ȡ���е��������
    Cu=sum(D);%����������ֵ����
    E=(abs(data(1:N))).^2;
    Cx=sum(E);%���е����
    C0(i+1)=Cu/Cx; %C0���Ӷ�
end  
if p==1
   plot(C0);
end

%%ȡC0��ƽ��ֵ
C0_average=mean(C0);




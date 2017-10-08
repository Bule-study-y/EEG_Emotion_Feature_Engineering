 
function [PSen,Average_PSen]=spectral_entropy(A,Fs,window_t,overlap,p)
M=length(A);
N=Fs*window_t;%ÿ�μ�������г���
m=Fs*(window_t*(1-overlap));%ÿ�λ����ĵ���
t=((M-N)/m);
h=floor(t);
for j=0:h %�����Ĵ���
    Xt=A(1+j*m:N+j*m);
    Pxx = abs(fft(Xt,N)).^2/N;                 %��ȡ�������ܶ�
    Spxx=sum(Pxx(2:1+N/2));                    %��ȡʱ�����е��ܹ���
    Pf=(Pxx(2:1+N/2))./Spxx;                            %��ȡ����
    for i=1:N/2
        if Pf(i)~=0
           LPf(i)=log(Pf(i));                %��ȡ��������
        else
           LPf(i)=0;
        end
    end
 Hf=Pf'.*LPf;
 PSen(j+1)=-(sum(Hf));
end
if p==1
plot(PSen);
end
Average_PSen=mean(PSen);


        
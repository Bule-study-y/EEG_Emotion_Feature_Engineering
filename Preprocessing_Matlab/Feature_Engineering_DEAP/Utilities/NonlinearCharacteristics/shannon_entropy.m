%%%%%%%%%%%%%%%%%%%%%%shannon_entropy%%%%%%%%%%%%%%%%%%%%%
%%���ߣ�������
%%���ڣ�2010.07.02
%%%%%window_tΪÿ�μ���Ĵ���ʱ�䳤�ȣ�overlapΪ�ص�������0.5

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [H,Average_SHen]=shannon_entropy(A,Fs,window_t,overlap)
N=Fs*window_t;%ÿ�μ�������г���
G=length(A);
g=Fs*(window_t*(1-overlap));%ÿ�λ����ĵ���
t=((G-N)/g);
h=floor(t);

for j=0:h
    Xt=A(1+j*g:N+j*g);
    Sam=sum(abs(Xt));  %������ȵľ���ֵ
    P=abs(Xt)./Sam;   %�������
    for i=1:N
        if P(i)~=0
           LP(i)=log(P(i));                
        else
           LP(i)=0;
        end
    end
  Hi=P'.*LP;   %������ũ��
 H(j+1)=-(sum(Hi));
end
Average_SHen=mean(H);

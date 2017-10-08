function [Em,Amean]=ApEn(A,Fs,window_t,overlap)
m=2;
r=0.2;
G=length(A);
%window_t=6;
N=Fs*window_t;%ÿ�μ�������г���
g=Fs*(window_t*(1-overlap));%ÿ�λ����ĵ���
t=((G-N)/g);
h=floor(t);
Em=zeros(h,1);
for i=0:h %�����Ĵ���
    data=A(1+i*g:N+i*g);%���ݻ�����ȡ
    R=r*std(data,1);  %����R
   Em(i+1)=Bm(data,R,m,N)-Bm(data,R,m+1,N);%���������
end
Amean=mean(Em);



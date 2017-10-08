function  [Km,Kmean]=kolmgolov_entropy(A,Fs,window_t,overlap,p)
N=Fs*window_t;%ÿ�μ�������г���
m=15;
G=length(A);
g=Fs*(window_t*(1-overlap));%ÿ�λ����ĵ���
t=((G-N)/g);
h=floor(t);
LKm=zeros(h,1);
for i=0:h %�����Ĵ���
    data=A(1+i*g:N+i*g);
    tau=tau_def(data);
    LKm(i+1)=log((CK(data,m,N,tau))./(CK(data,m+13,N,tau)));
    Km=(1/(tau*13))*LKm;
end
if p==1
    plot(Km);
end
Kmean=mean(Km);


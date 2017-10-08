%%%%%%%%%%%%%%%%Permutation entropy%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%window_tΪÿ�μ���Ĵ���ʱ�䳤�ȣ�overlapΪ�ص�������0.5

%%%%%%%author:lanlanli
%%%%%%%date:2010.09
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [P_E,M_P]=permuatation_entropy(A,Fs,window_t,overlap)
N=Fs*window_t;%ÿ�μ�������г���
g=Fs*(window_t*(1-overlap));%ÿ�λ����ĵ���

G=length(A);
t=((G-N)/g);
h=floor(t);
m=15;

for ii=0:h %�����Ĵ���
     data=A(1+ii*g:N+ii*g);
     tau=tau_def(data);
     M=N-(m-1)*tau;%��ռ�ÿһά���еĳ���
     Y=reconstitution(data,N,m,tau)';%�ع���ռ�
     [X,I]=sort(Y,2);
     B=unique(I,'rows');
     [Point,K]=size(B);
     C=zeros(Point,1);
     for i=1:Point
         for j=1:M
             if B(i,:)==I(j,:)
                 C(i)=C(i)+1;
             end
         end
     end
     P_pi=C./M;
     Log_pi=log(P_pi);
     H_m=-sum(P_pi.*Log_pi);
     P_E(ii+1)=H_m/(m-1);
    end
M_P=mean(P_E);
             
                 
                    
                         
             
    
   
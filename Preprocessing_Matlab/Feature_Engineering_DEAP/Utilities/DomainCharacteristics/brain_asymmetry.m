%%%%%%%%%%%%%%%%%%%%  alpha_asymmetry.m  %%%%%%%%%%%%%%%%%%%%
%  Defination:  alpha 8~13Hz
%  �ó��������alpha_asymmetry����Ϊ�����ź�Ƶ�γɷ���ȷ�����Բ���Ҫ����󵥶�ָ�������ĸ�Ƶ�εĲ�ͬ��
%  Result:      ln(Power_right/Power_left)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  asymmetry = brain_asymmetry(Fs,step_second,s_right,s_left)

N = round(Fs*step_second);

Len = min( length(s_right),length(s_left) );        % ѡȡ��̵�����
s_right = s_right(1:Len);
s_left = s_left(1:Len);      % ��ȡ��ʹ���ҵ缫�ɼ������źų�����ͬ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii=1:(Len/N)
    s_right_ii = s_right( (ii-1)*N+1:ii*N );
    Pxx_right(ii,:) = abs(fft(s_right_ii)).^2/N;      % ��FFT������
end
if Len/N>=2
    Pxx_right_average = mean(Pxx_right);
else
     Pxx_right_average = Pxx_right;
end

for ii=1:(Len/N)
    s_left_ii = s_left( (ii-1)*N+1:ii*N );
    Pxx_left(ii,:) = abs(fft(s_left_ii)).^2/N;      % ��FFT������
end
if Len/N>=2
    Pxx_left_average = mean(Pxx_left);
else
     Pxx_left_average = Pxx_left;
end


Power_right = sum(Pxx_right_average); % ��xx���ε��ܹ���
Power_left = sum(Pxx_left_average);

asymmetry = log(Power_left)-log(Power_right);
    
    
    
    
    

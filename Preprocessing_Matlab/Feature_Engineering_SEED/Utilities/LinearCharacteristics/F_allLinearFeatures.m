function features = F_allLinearFeatures(fs,input,onetime,overlap)
    N = fs*onetime;   %��ȡ��һ�μ���ĵ���
    Xt = input;
    Len = length(Xt);
    ii = 0;
    flag=0;
    while flag+N <= Len
        Xt_ii = Xt( (flag+1):(flag+N) );
        PPmean(ii+1) = mean(abs(Xt_ii));        %% PPmean�����ֵ��ƽ��ֵ
        meanSquare(ii+1) = (Xt_ii)'*(Xt_ii)/N; %% meanSquare: ����ֵ
        variance(ii+1) = var(Xt_ii);            %% variance: ����
        [activity(ii+1), mobility(ii+1), complexity(ii+1)] = F_hjorth(Xt_ii,0);
%%%%%%%%%%%%%%%%%%%%%%%%%   AR model   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%% ����Ӧ����� %%%%%%%%%%
        temp = 0;
        for p = [1:sqrt(N)]
            [a,E] = aryule(Xt_ii,p);
            AIC(p) = log(E)+2*p/N;
        end
        [minA bestp] = min(AIC);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [a,E] = aryule(Xt_ii,bestp);
        f = 0:1/(2*N):0.5;
        b = 0;
        for k = [1:bestp]
            b = b+a(k+1)*exp(-j*2*pi*f*k);
        end;
        s = E./( ( abs(1+b) ).^2 );     
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        maxs_temp = s(1);
        kk = 0;
        for k = [1:length(s)]
            if s(k)>maxs_temp
                maxs_temp = s(k);
                kk = k;
            end
        end
        if kk==0
            kk=1;
        end
        maxs(ii+1) = maxs_temp;         %% maxs����������ܶ�
        f0(ii+1) = fs*(kk-1)/(2*N);        %% f0: ȡ��������ܶ�ʱ��Ƶ��
        sumPower(ii+1) = sum(s)*fs/(2*N);        %% sumPower���ܹ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ii = ii+1;
        flag = flag+(onetime*(1-overlap))*fs;
        Num_feature = ii;
    end
    
    features(:,1) = mean(PPmean);
    features(:,2) = mean(meanSquare);
    features(:,3) = mean(variance);
    features(:,4) = mean(activity);
    features(:,5) = mean(mobility);
    features(:,6) = mean(complexity);
    features(:,7) = mean(f0);
    features(:,8) = mean(maxs);
    features(:,9) = mean(sumPower);
   
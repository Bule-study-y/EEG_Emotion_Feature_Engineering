%rhythm extraction params theta alpha beta gamma
lowf = [4,8,13,30];
highf = [8,13,30,50];
bandNum = size(lowf,2);
rhythms = {'GammaRhythm','BetaRhythm','AlphaRhythm','ThetaRhythm'};%��������дΪ�������Ƶ����

%% hyper params
subNum = 15;
channelNum = 62;%EEGͨ����32��
expNum = 3;
fs = 200;
trialTime = 20;
trialL = fs*trialTime;
trialNum = 15;
linear_feature_num = 9;
nonlinear_feature_num = 9;
brainAsync_feature_num = 27;%�����԰���ԳƵ缫����
nondomain_feature_num = linear_feature_num+nonlinear_feature_num;
total_feature_num = nondomain_feature_num*channelNum+brainAsync_feature_num;%һ���������ܳ�ȡ����������

%% ��Բ�ͬ�Ļ������㴰�ڳ�����ȡ��Ӧ����
windowTime = 4;%�������㴰�ڳ�����1s,2s,3s,4s,5s,6s,10s�ȵ�
rhythmNo = 1;
overlap = 0.5;%���������»����Ĳ�����Ҳ���Ǵ��ڼ�ĸ��Ǳ�����

for subNo=1:subNum
    for expNo=1:expNum
        %% allocate memory
        EEG_Features = zeros(trialNum,total_feature_num);
        %% load data
        filePath = strcat('D:\LX\Processed SEED DATA\NoScaleForEachChannel_RhythmExtraction\',rhythms{rhythmNo},'\sub',num2str(subNo),'_',num2str(expNo),'.mat');
        datFile = load(filePath);
        subData = datFile.data;
        tic;
        %% extraction features
        for trialNo=1:trialNum
            %% extraction linear+nonlinear for each channel in current sample
            for channelNo = 1:channelNum %ÿ��sample����32���缫��Ӧ���ݹ��ɵģ���������Ҫ�ֱ��32���缫��ȥȡ��Ӧ��ǰsample�����ݡ�
                disp(strcat('Feature Extracting: Sub-',num2str(subNo),' experiment- ',num2str(expNo),' trialNo-',num2str(trialNo),' channelNo-',num2str(channelNo)));
                chsig_start = (channelNo-1)*trialL+1;%��ֵ�����Ӧchannel���ݳ�ȡ����ʼλ��,ע����3���baseline
                chsig_end = channelNo*trialL;%��ֵ�����Ӧchannel���ݳ�ȡ�Ľ���λ��,ע����3���baseline
                channelSignal = subData(trialNo,chsig_start:chsig_end);%��ȡtrial��Ӧ��channel�����ź�,������3��baseline
                channelTrialSignal = channelSignal;%��ȥbaseline����
                %% linear feature extraction:linearF totalnum=9*channelNum
                %     (:,1) = PPmean;
                %     (:,2) = meanSquare;
                %     (:,3) = variance;
                %     (:,4) = activity;
                %     (:,5) = mobility;
                %     (:,6) = complexity;
                %     (:,7) = f0;
                %     (:,8) = maxs;
                %     (:,9) = sumPower;
                %plot(signal_sample);
                linearF = F_allLinearFeatures(fs,channelTrialSignal',windowTime,overlap);
                %% non-linear feature extraction:nonlinearF totalnum=9*channelNum
                %     (:,1) = ApEn;
                %     (:,2) = C0 Complexity;
                %     (:,3) = correlation dimension;
                %     (:,4) = kolmogorov entropy ������bug��ȡ����
                %     ���ʺ����ݳ���С��1000,2000������
                %     (:,5) = lyapunov exponent;
                %     (:,6) = permutation entropy;
                %     (:,7) = singular entropy;
                %     (:,8) = shannon entropy;
                %     (:,9) = spectral_entropy;
                nonlinearF = F_allNonlinearFeatures(fs,channelTrialSignal',windowTime,overlap);
                %ƴ�����������������
                nonDomainF = [linearF,nonlinearF];
                startIndex = nondomain_feature_num*(channelNo-1)+1;
                endIndex = nondomain_feature_num*channelNo;
                EEG_Features(trialNo,startIndex:endIndex)=nonDomainF;%���õ��ķ������������浽��Ӧλ��
            end
            %% brain_asymmetry extraction:asymmetryF totalNum=1*channelpairNum
            % 27�ԶԳƵ缫
            left_ch=[1,4,6,7,8,9,15,16,17,18,24,25,26,27,33,34,35,36,42,43,44,45,51,52,53,58,59];
            right_ch=[3,5,14,13,12,11,23,22,21,20,32,31,30,29,41,40,39,38,50,49,48,47,57,56,55,62,61];
            asyNum = brainAsync_feature_num;
            asymmetryF = zeros(1,asyNum);
            for j=1:asyNum
                l_chsig_start = (left_ch(j)-1)*(trialTime)*fs+1;
                l_chsig_end = left_ch(j)*(trialTime)*fs;
                r_chsig_start = (right_ch(j)-1)*(trialTime)*fs+1;
                r_chsig_end = right_ch(j)*(trialTime)*fs;
                l_channelSignal = subData(trialNo,l_chsig_start:l_chsig_end);%��ȡtrial��Ӧ����channel�����ź�,������3��baseline
                r_channelSignal = subData(trialNo,r_chsig_start:r_chsig_end);%��ȡtrial��Ӧ����channel�����ź�,������3��baseline
                asymmetry = brain_asymmetry(fs,windowTime,r_channelSignal',l_channelSignal');
                asymmetryF(j)=asymmetry;
            end
            startIndex = nondomain_feature_num*channelNum+1;
            endIndex = nondomain_feature_num*channelNum+brainAsync_feature_num;
            EEG_Features(trialNo,startIndex:endIndex)=asymmetryF;%���õ��ķ������������浽��Ӧλ��
        end
        toc;
        %���ñ��Ե�EEG_Features��������
        fileName = strcat('D:\LX\Processed SEED DATA\FeatureEngineering\EEG\Frontiers\NoScaleRawData_RhythmExtraction\',rhythms{rhythmNo},'\WindowTime',num2str(windowTime),'_sub',num2str(subNo),'_',num2str(expNo),'.mat');
        save(fileName,'EEG_Features','-v7.3');
        disp(strcat('end!subject ',num2str(subNo)));
    end
end

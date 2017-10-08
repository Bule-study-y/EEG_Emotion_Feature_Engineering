%rhythm extraction params theta alpha beta gamma
lowf = [4,8,13,30];
highf = [8,13,30,50];
bandNum = size(lowf,2);
rhythms = {'GammaRhythm','BetaRhythm','AlphaRhythm','ThetaRhythm'};%��������дΪ�������Ƶ����

%% hyper params
subNum = 32;
channelNum = 32;%EEGͨ����32��
fs = 128;
trialTime = 60;
trialNum = 40;
linear_feature_num = 9;
nonlinear_feature_num = 9;
brainAsync_feature_num = 14;%�����԰���ԳƵ缫����
nondomain_feature_num = linear_feature_num+nonlinear_feature_num;
total_feature_num = nondomain_feature_num*channelNum+brainAsync_feature_num;%һ���������ܳ�ȡ����������

%% ��Բ�ͬ�Ļ������㴰�ڳ�����ȡ��Ӧ����
windowTime = 4;%�������㴰�ڳ�����1s,2s,3s,4s,5s,6s,10s�ȵ�
rhythmNo = 1;
overlap = 0.5;%���������»����Ĳ�����Ҳ���Ǵ��ڼ�ĸ��Ǳ�����

for subNo=25:32
    %% allocate memory
    EEG_Features = zeros(trialNum,total_feature_num);
    %% load data
    filePath = strcat('D:\LX\Processed DEAP DATA\ScaleForEachChannel_RhythmExtraction\',rhythms{rhythmNo},'\sub',num2str(subNo),'.mat');
    datFile = load(filePath);
    subData = datFile.scale_data;
    tic;
    %% extraction features
    for trialNo=1:trialNum
        %% extraction linear+nonlinear for each channel in current sample
        for channelNo = 1:channelNum %ÿ��sample����32���缫��Ӧ���ݹ��ɵģ���������Ҫ�ֱ��32���缫��ȥȡ��Ӧ��ǰsample�����ݡ�
            disp(strcat('Feature Extracting: Sub-',num2str(subNo),' trialNo-',num2str(trialNo),' channelNo-',num2str(channelNo)));
            chsig_start = (channelNo-1)*(trialTime+3)*fs+1;%��ֵ�����Ӧchannel���ݳ�ȡ����ʼλ��,ע����3���baseline
            chsig_end = channelNo*(trialTime+3)*fs;%��ֵ�����Ӧchannel���ݳ�ȡ�Ľ���λ��,ע����3���baseline
            channelSignal = subData(trialNo,chsig_start:chsig_end);%��ȡtrial��Ӧ��channel�����ź�,������3��baseline
            channelTrialSignal = channelSignal(fs*3+1:end);%��ȥbaseline����
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
        % �ԳƵ缫�԰�����ǰ����FP1-FP2(1-17)��AF3-AF4(2-18)��F3-F4(3-20),F7-F8(4-21)��FC5-FC6(5-22)��FC1-FC2(6-23)���в���C3-C4(7-25), T7-T8(8-26)
        % �󲿣�CP5-CP6(9-27),CP1-CP2(10-28),P3-P4(11-29),P7-P8(12-30),PO3-PO4(13-31),O1-O2(14-32)
        % �����������Ķ����
        left_ch=[1,2,3,4,5,6,7,8,9,10,11,12,13,14];
        right_ch=[17,18,20,21,22,23,25,26,27,28,29,30,31,32];
        asyNum = length(left_ch);
        asymmetryF = zeros(1,asyNum);
        for j=1:asyNum
            l_chsig_start = (left_ch(j)-1)*(trialTime+3)*fs+1;
            l_chsig_end = left_ch(j)*(trialTime+3)*fs;
            r_chsig_start = (right_ch(j)-1)*(trialTime+3)*fs+1;
            r_chsig_end = right_ch(j)*(trialTime+3)*fs;
            l_channelSignal = subData(trialNo,l_chsig_start:l_chsig_end);%��ȡtrial��Ӧ����channel�����ź�,������3��baseline
            r_channelSignal = subData(trialNo,r_chsig_start:r_chsig_end);%��ȡtrial��Ӧ����channel�����ź�,������3��baseline
            asymmetry = brain_asymmetry(fs,windowTime,r_channelSignal(fs*3+1:end)',l_channelSignal(fs*3+1:end)');
            asymmetryF(j)=asymmetry;
        end
        startIndex = nondomain_feature_num*channelNum+1;
        endIndex = nondomain_feature_num*channelNum+brainAsync_feature_num;
        EEG_Features(trialNo,startIndex:endIndex)=asymmetryF;%���õ��ķ������������浽��Ӧλ��
    end
    toc;
    %���ñ��Ե�EEG_Features��������
    fileName = strcat('D:\LX\Processed DEAP DATA\FeatureEngineering\EEG\Frontiers\ScaleRawData_RhythmExtraction\',rhythms{rhythmNo},'\WindowTime',num2str(windowTime),'_sub',num2str(subNo));
    save(fileName,'EEG_Features','-v7.3');
    disp(strcat('end!subject ',num2str(subNo)));
end

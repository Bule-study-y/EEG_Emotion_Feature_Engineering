%% ��ÿ�����Ե����ݽ���normalize�����ع���װ��ʽ
% �ֱ��ÿ��channel��40����Ƶ������ݽ���normalization��scale��0~1
% ����normalize�ķ�ʽ�ܱ�������channel�ڲ�ͬ�̼��µķ�ֵ���죬ͬʱ������������ͬchannel�ķ�ֵ���죬ͬʱ���ܽ��ͱ����뱻�Լ�Ĳ���
subNum = 32;
trialNum = 40;
channelNum = 40;
fs = 128;
trialTime = 63; 
trialL = fs*trialTime;
signalL = trialL*channelNum;

%rhythm extraction params theta alpha beta gamma
lowf = [4,8,13,30];
highf = [8,13,30,64];
bandNum = size(lowf,2);
rhythms = {'ThetaRhythm','AlphaRhythm','BetaRhythm','GammaRhythm'};%cell�ַ���

%��Ƶ�ν��н��ɳ�ȡ ����װ����ͬ�ļ��ﱣ��
for i=1:bandNum
    for subNo=1:subNum
        data = zeros(trialNum,signalL);
        if subNo<10
            filePath = strcat('D:\DEAP DATA\s0',num2str(subNo),'.mat');
        else
            filePath = strcat('D:\DEAP DATA\s',num2str(subNo),'.mat');
        end
        datFile = load(filePath);
        subData = datFile.data;
        for channelNo=1:channelNum
            %ƴ�Ӹ���channel��40��ʵ���е����ݳ�һ��
            channel_data = zeros(trialNum,trialL);
            for trialNo=1:trialNum
                disp(strcat('start processing rhythm ',rhythms{i},'sub ',num2str(subNo),' channel ',num2str(channelNo),' trial ',num2str(trialNo)));
                channelSignal = subData(trialNo,channelNo,:);
                channelSignal = squeeze(channelSignal);%squeezeѹ����Щ���õ�ֻ��һ��һ�е�ά��
                %��Ƶ�ν��н��ɳ�ȡ ����װ����ͬ�ļ��ﱣ��
                rhythmSignal=BandPassFilter(channelSignal,fs,lowf(i),highf(i));
                channel_data(trialNo,:) = rhythmSignal;%squeezeѹ����Щ���õ�ֻ��һ��һ�е�ά��
            end
            %����ǰchannel����д��data��Ӧ��λ��
            startIndex = (channelNo-1)*trialL+1;
            endIndex = channelNo*trialL;
            data(:,startIndex:endIndex) = channel_data;
        end
        %���ñ��Ե�data��������
        fileName = strcat('D:\LX\Processed DEAP DATA\NoScaleForEachChannel_RhythmExtraction\',rhythms{i},'\sub',num2str(subNo));
        save(fileName,'data','-v7.3');
        disp(strcat('end!subject ',num2str(subNo)));
    end
end
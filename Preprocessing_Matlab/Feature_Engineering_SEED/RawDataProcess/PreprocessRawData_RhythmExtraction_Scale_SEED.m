%% ��ÿ�����Ե����ݽ���normalize�����ع���װ��ʽ
% �ֱ��ÿ��channel��40����Ƶ������ݽ���normalization��scale��0~1
% ����normalize�ķ�ʽ�ܱ�������channel�ڲ�ͬ�̼��µķ�ֵ���죬ͬʱ������������ͬchannel�ķ�ֵ���죬ͬʱ���ܽ��ͱ����뱻�Լ�Ĳ���
subNum = 15;
expNum = 3;%ÿ������ʵ��3��
trialNum = 15;
channelNum = 62;
fs = 200;
trialTime = 60; 
trialL = fs*trialTime;
signalL = trialL*channelNum;

%rhythm extraction params theta alpha beta gamma
lowf = [4,8,13,30];
highf = [8,13,30,100];
bandNum = size(lowf,2);
rhythms = {'ThetaRhythm','AlphaRhythm','BetaRhythm','GammaRhythm'};

%��Ƶ�ν��н��ɳ�ȡ ����װ����ͬ�ļ��ﱣ��
for i=1:bandNum
    for subNo=1:subNum
        for expNo=1:expNum
            scale_data = zeros(trialNum,signalL);
            if subNo<10
                filePath = strcat('D:\LX\SEED DATA\sub0',num2str(subNo),'_',num2str(expNo),'.mat');
            else
                filePath = strcat('D:\LX\SEED DATA\sub',num2str(subNo),'_',num2str(expNo),'.mat');
            end
            datFile = load(filePath);
            trialNames = fieldnames(datFile);%ȡ���ṹ���������ֶ�
            for channelNo=1:channelNum
                %ƴ�Ӹ���channel�ڲ�ͬtrial�е����ݳ�һ��
                channel_data = zeros(trialNum,trialL);
                for trialNo=1:trialNum
                    disp(strcat('start processing rhythm ',rhythms{i},' sub ',num2str(subNo),' experiment ',num2str(expNo),' channel ',num2str(channelNo),' trial ',num2str(trialNo)));
                    trialName=trialNames{trialNo};
                    trialData = getfield(datFile,trialName);
                    channelSignal = trialData(channelNo,:);
                    %ȡ���м��1���Ӳ�����ΪĿ���ź�
                    length = size(channelSignal,2);
                    l_center = round(length/2);
                    centerSignal = channelSignal(l_center-fs*30+1:l_center+fs*30);
                    %��Ƶ�ν��н��ɳ�ȡ ����װ����ͬ�ļ��ﱣ��
                    rhythmSignal=BandPassFilter(centerSignal,fs,lowf(i),highf(i));
                    channel_data(trialNo,:) = rhythmSignal;
                end
                %�Ը�channel�ڸ���trial�µ����ݽ���scale��scale_channel_data
                maxVal= max(max(channel_data));
                minVal = min(min(channel_data));
                scope = maxVal-minVal;
                scale_channel_data = 2*(channel_data-minVal)/scope-1;%��һ����-1��1
                %��scale���channel����д��scale_data��Ӧ��λ��
                startIndex = (channelNo-1)*trialL+1;
                endIndex = channelNo*trialL;
                scale_data(:,startIndex:endIndex) = scale_channel_data;
            end
            %���ñ��Ե�data��������
            fileName = strcat('D:\LX\Processed SEED DATA\ScaleForEachChannel_RhythmExtraction\',rhythms{i},'\sub',num2str(subNo),'_',num2str(expNo));
            save(fileName,'scale_data','-v7.3');
            disp(strcat('end!subject ',num2str(subNo)));
        end
    end
end
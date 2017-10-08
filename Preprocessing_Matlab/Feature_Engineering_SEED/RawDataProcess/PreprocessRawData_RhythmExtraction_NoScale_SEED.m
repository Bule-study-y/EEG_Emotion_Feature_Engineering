%% ��ÿ�����Ե����ݽ���normalize�����ع���װ��ʽ
% �ֱ��ÿ��channel��40����Ƶ������ݽ���normalization��scale��0~1
% ����normalize�ķ�ʽ�ܱ�������channel�ڲ�ͬ�̼��µķ�ֵ���죬ͬʱ������������ͬchannel�ķ�ֵ���죬ͬʱ���ܽ��ͱ����뱻�Լ�Ĳ���
subNum = 15;
expNum = 3;%ÿ������ʵ��3��
trialNum = 15;
channelNum = 62;
fs = 200;
trialTime = 20; 
trialL = fs*trialTime;
signalL = trialL*channelNum;

%rhythm extraction params theta alpha beta gamma
lowf = [4,8,13,30];
highf = [8,13,30,50];
bandNum = size(lowf,2);
rhythms = {'ThetaRhythm','AlphaRhythm','BetaRhythm','GammaRhythm'};

%��Ƶ�ν��н��ɳ�ȡ ����װ����ͬ�ļ��ﱣ��
for i=1:bandNum %�ǵ��޸���ʼλ��
    for subNo=1:subNum
        for expNo=1:expNum
            data = zeros(trialNum,signalL);
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
                    %ȡ���м��20s������ΪĿ���źţ���Ϊ���ǵ�������200����Ҫ���ͳ�ȡ����������ۣ��������źų���
                    length = size(channelSignal,2);
                    l_center = round(length/2);
                    centerSignal = channelSignal(l_center-fs*10+1:l_center+fs*10);
                    %��Ƶ�ν��н��ɳ�ȡ ����װ����ͬ�ļ��ﱣ��
                    rhythmSignal=BandPassFilter(centerSignal,fs,lowf(i),highf(i));
                    channel_data(trialNo,:) = rhythmSignal;
                end
                %����ǰchannel����д��data��Ӧ��λ��
                startIndex = (channelNo-1)*trialL+1;
                endIndex = channelNo*trialL;
                data(:,startIndex:endIndex) = channel_data;
            end
            %���ñ��Ե�data��������
            fileName = strcat('D:\LX\Processed SEED DATA\NoScaleForEachChannel_RhythmExtraction\',rhythms{i},'\sub',num2str(subNo),'_',num2str(expNo));
            save(fileName,'data','-v7.3');
            disp(strcat('end!subject ',num2str(subNo)));
        end
    end
end
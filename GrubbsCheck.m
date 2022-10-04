function [outData,outlierIdx] = GrubbsCheck(inData,GrubbsTest,alphaIdx)
% --- ����˵�� ---
% ������˹���鷨�޳��쳣ֵ
%
% --- ���� ---
% inData : ԭʼ��������
% GrubbsTest : �ٽ�ֵ��
% alphaIdx : ������ˮƽ
%
% --- ��� ---
% outData : �޳��쳣ֵ�������
% outlierIdx : �쳣ֵ����
%
% Programmer: Robin An, 2021-09-28
% last modified by Robin An on 2021-10-19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

abnormalIdx = [];
subinData = inData;
subinData(subinData == 10000) = []; % 10000��ʾ�쳣ֵ

% 2.������ֵ�ͱ�׼��
meanData = mean(subinData);
stdData = std(subinData);

dataLen = length(subinData); % ��������

% 3.���²�ͳ����
[ninData, dataIdx]= sort(subinData,'ascend');
GUpside = (ninData(dataLen) - meanData) / stdData;  % �ϲ�ͳ����
GDownside = (meanData - ninData(1)) / stdData;% �²�ͳ����

GRefer = GrubbsTest(dataLen-2,alphaIdx); % �ٽ�ֵ

% 4.�ж��쳣ֵ
if GUpside > GDownside && GUpside > GRefer
    tmpMax = subinData(dataIdx(dataLen)); % ���ڶ���쳣ֵ
    iidx0 = find(inData == tmpMax);  % ������ԭ�����е�����
    abnormalIdx = [abnormalIdx,iidx0];
elseif GDownside > GUpside && GDownside > GRefer
    tmpMin = subinData(dataIdx(1));
    iidx1 = find(inData == tmpMin);
    abnormalIdx = [abnormalIdx,iidx1];
elseif GDownside == GUpside
    disp('No abnomal value, since all values are equal...');
end

outlierIdx = abnormalIdx;

% �����쳣ֵ
if ~isempty(outlierIdx)
    inData(outlierIdx) = 10000;
end

outData = inData;
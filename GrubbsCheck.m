function [outData,outlierIdx] = GrubbsCheck(inData,GrubbsTest,alphaIdx)
% --- 函数说明 ---
% 格拉布斯检验法剔除异常值
%
% --- 输入 ---
% inData : 原始数据数组
% GrubbsTest : 临界值表
% alphaIdx : 显著性水平
%
% --- 输出 ---
% outData : 剔除异常值后的数据
% outlierIdx : 异常值索引
%
% Programmer: Robin An, 2021-09-28
% last modified by Robin An on 2021-10-19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

abnormalIdx = [];
subinData = inData;
subinData(subinData == 10000) = []; % 10000表示异常值

% 2.样本均值和标准差
meanData = mean(subinData);
stdData = std(subinData);

dataLen = length(subinData); % 样本数量

% 3.上下侧统计量
[ninData, dataIdx]= sort(subinData,'ascend');
GUpside = (ninData(dataLen) - meanData) / stdData;  % 上侧统计量
GDownside = (meanData - ninData(1)) / stdData;% 下侧统计量

GRefer = GrubbsTest(dataLen-2,alphaIdx); % 临界值

% 4.判定异常值
if GUpside > GDownside && GUpside > GRefer
    tmpMax = subinData(dataIdx(dataLen)); % 存在多个异常值
    iidx0 = find(inData == tmpMax);  % 查找在原数组中的索引
    abnormalIdx = [abnormalIdx,iidx0];
elseif GDownside > GUpside && GDownside > GRefer
    tmpMin = subinData(dataIdx(1));
    iidx1 = find(inData == tmpMin);
    abnormalIdx = [abnormalIdx,iidx1];
elseif GDownside == GUpside
    disp('No abnomal value, since all values are equal...');
end

outlierIdx = abnormalIdx;

% 存在异常值
if ~isempty(outlierIdx)
    inData(outlierIdx) = 10000;
end

outData = inData;
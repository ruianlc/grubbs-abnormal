clc;clear;close all
dpath = 'G:\workspace\科技项目\江苏中烟\数据分析\数据异常值剔除1009 - 再次整理.xlsx';
savepath = 'G:\workspace\科技项目\江苏中烟\数据分析\数据异常值剔除1009 - 再次整理 - 副本.xlsx';

% dpath = 'G:\workspace\科技项目\江苏中烟\数据分析\第二批1011New.xlsx';
% savepath = 'G:\workspace\科技项目\江苏中烟\数据分析\第二批1011New - 副本.xlsx';

[~,Sheets,~] = xlsfinfo(dpath);

% 参考临界值表
% referpath = 'G:\workspace\科技项目\江苏中烟\数据分析\格拉布斯临界值表.xlsx';
% Iopts = detectImportOptions(referpath);
% Iopts.Sheet = 1;
% Iopts.VariableNamingRule = 'preserve';
% referTData = readtable(referpath,Iopts,'ReadRowNames',false,'ReadVariableNames',false);
% referTTData = table2array(referTData);
% GrubbsTest = referTTData(2:end,2:6);
% save('GrubbsTest.mat','GrubbsTest')
load('GrubbsTest.mat')

%% 定义常量
AlphaScale = [0.90,0.95,0.975,0.99,0.995]; % 置信度
testAlpha = 0.1;  % 检出水平 & 剔除水平
elimAlpha = 0.01; % 一般剔除水平
alphaIdx = find(AlphaScale == (1-testAlpha/2));
AbnormalMark = 10000;

%subinData =[4.7,5.4,6.0,6.5,7.3,7.7,8.2,9.0,10.1,14.0];
%subinData = [2.93314,2.65678,0.29498,0.15386,0.26852,0.21266,1.58172,1.40532,0.58212,1.27204];
%subinData = [1.26616,2.91746,5.22438,2.54212,1.4406,0.40082,1.43962,2.47254,6.9188,3.49468];
%subinData = [4.49526,5.14206,2.4451,4.28162,4.16794,4.49134,4.31984,4.12972,3.15658,4.29338];
%subinData = [4.49526000000000,5.14206000000000,4.28162000000000,4.16794000000000,4.49134000000000,4.31984000000000,4.12972000000000,3.15658000000000,4.29338000000000];
%subinData = [4.49526000000000,5.14206000000000,4.28162000000000,4.16794000000000,4.49134000000000,4.31984000000000,4.12972000000000,4.29338000000000];
subinData = [4.49526000000000,4.28162000000000,4.16794000000000,4.49134000000000,4.31984000000000,4.12972000000000,4.29338000000000];
[outData,oIdx] = GrubbsCheck(subinData,GrubbsTest,alphaIdx);
outData

meanData = mean(subinData);
stdData = std(subinData);

dataLen = length(subinData); % 样本数量

% 3.上下侧统计量
[ninData, dataIdx]= sort(subinData,'ascend');
GUpside = (ninData(dataLen) - meanData) / stdData;  % 上侧统计量
GDownside = (meanData - ninData(1)) / stdData;% 下侧统计量

GRefer = GrubbsTest(dataLen-2,alphaIdx); % 临界值

% 4.判定异常值
abnormalIdx = [];
if GUpside > GDownside && GUpside > GRefer
    tmpMax = subinData(dataIdx(dataLen)); % 存在多个异常值
    iidx0 = find(subinData == tmpMax);  % 查找在原数组中的索引
    abnormalIdx = [abnormalIdx,iidx0];
elseif GDownside > GUpside && GDownside > GRefer
    tmpMin = subinData(dataIdx(1));
    iidx1 = find(subinData == tmpMin);
    abnormalIdx = [abnormalIdx,iidx1];
elseif GDownside == GUpside
    disp('No abnomal value, since all values are equal...');
end

outlierIdx = abnormalIdx;
subinData(outlierIdx) = AbnormalMark;
subinData
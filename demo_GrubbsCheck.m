clc;clear;close all
% dpath = 'G:\workspace\科技项目\江苏中烟\数据分析\数据异常值剔除1009 - 再次整理.xlsx';
% savepath = 'G:\workspace\科技项目\江苏中烟\数据分析\数据异常值剔除1009 - 再次整理 - 副本.xlsx';
% 
% dpath = 'G:\workspace\科技项目\江苏中烟\数据分析\第二批1011New.xlsx';
% savepath = 'G:\workspace\科技项目\江苏中烟\数据分析\第二批1011New - 副本.xlsx';

dpath = 'D:\workspace\科技项目\江苏中烟\数据分析\格拉布斯异常值剔除\数据异常值剔除0728.xlsx';
savepath = 'D:\workspace\科技项目\江苏中烟\数据分析\格拉布斯异常值剔除\数据异常值剔除0728 - 副本.xlsx';

[~,Sheets,~] = xlsfinfo(dpath);

% 参考临界值表
% referpath = 'G:\workspace\科技项目\江苏中烟\数据分析\格拉布斯临界值表.xlsx';
% Iopts = detectImportOptions(referpath);
% Iopts.Sheet = 1;
% Iopts.VariableNamingRule = 'preserve';
% referTData = readtable(referpath,Iopts,'ReadRowNames',false,'ReadVariableNames',false);
% referTTData = table2array(referTData);
% REFERData = referTTData(2:end,2:6);
load('GrubbsTest.mat')

%% 定义常量
AlphaScale = [0.90,0.95,0.975,0.99,0.995]; % 置信度
testAlpha = 0.1;  % 检出水平 & 剔除水平
elimAlpha = 0.01; % 一般剔除水平
alphaIdx = find(AlphaScale == (1-testAlpha/2));
AbnormalMark = 10000;

% 原始数据
for ss = 2:length(Sheets)
    sourceData = readmatrix(dpath,'Sheet',ss,'Range','B3');
    
    %% 格拉布斯（Grubbs）检验法
    if ismember(ss,2:6)
        NUMBER = 10;
    else
        NUMBER = 12;
    end
    
    %NUMBER = size(sourceData,2);
    sampleLen = size(sourceData,1);
    totalData = cell(sampleLen,1);
    
    for i = 1:sampleLen
        % 1.获取单个样本
        tData = sourceData(i,:);
        tData = tData(~isnan(tData));
        
        if length(tData) < 3 % 数量小于3，无需剔除
            totalData{i} = tData;
            continue;
        end
        
%         % 1次格拉布斯检验
%         outData0 = tData;
%         [outData1,oIdx1] = GrubbsCheck(outData0,REFERData,alphaIdx);
%         [outData2,oIdx2] = GrubbsCheck(outData1,REFERData,alphaIdx);
%         [outData3,oIdx3] = GrubbsCheck(outData2,REFERData,alphaIdx);
%         [outData4,oIdx4] = GrubbsCheck(outData3,REFERData,alphaIdx);
%         [outData5,oIdx5] = GrubbsCheck(outData4,REFERData,alphaIdx);
%         outlierIdx = [oIdx1,oIdx2,oIdx3,oIdx4,oIdx5];
%         outlierIdx = oIdx1;
        
        outlierIdx = [];
        outData0 = tData;
        for j = 1:NUMBER
            [outData1,oIdx] = GrubbsCheck(outData0,GrubbsTest,alphaIdx);
            outData0 = outData1; % 前一次检验的输出作为下一次检验的输入
            outlierIdx = [outlierIdx,oIdx];
        end
        
        tData(outlierIdx) = AbnormalMark;
        
        totalData{i} = tData;
    end
    
    writecell(totalData,savepath,'Sheet',ss,'Range',strcat(num2letter(NUMBER+2),'3'));
end
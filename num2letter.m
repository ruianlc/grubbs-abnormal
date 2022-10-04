function letter = num2letter(num)
% --- 函数说明 ---
% 将数字转换为字母表顺序的对应字母
% 列项最大为27*26 = 702列
%
% --- 输入 ---
% num : 数字
% 
% example 1:
% num = 3;
% letter = num2letter(num);
% letter = 'C'
%
% example 2:
% num = 80;
% letter = num2letter(num)
% letter = 'CB'
%
% --- 输出 ---
% letter : 相应字母
%
% Programmer: Robin An, 2021-08-21
% last modified by Robin An on 2021-08-22
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alphabet = cell(1,26*27);
initial = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
for i = 1:length(initial)
    alphabet{i} = initial{i};
end

for i = 1:length(initial)
    for j =1:length(initial)
        s = strcat(initial{i},initial{j});
        alphabet{i*26+j} = s;
    end
end

if num <= length(alphabet)
    character = alphabet(num);
else
    disp('the maximal input num is 27*26 currently.')
    return;
end
letter = char(character);
clear; 
clc;
close all;
SamNum = 1128;                     % 输入样本数量
TestSamNum = 1128;              % 测试样本数量
ForcastSamNum = 141;           % 预测样本数量
HiddenUnitNum=8;             % 隐含层
InDim = 3;                            % 输入层
OutDim = 2;                         % 输出层
% 原始数据 
data = xlsread('C:\Users\admin\Desktop\grey.xlsx','Sheet2');
% 人数(单位：万人)
temp = data(:,1)';
% 机动车数(单位：万辆)
hantan = data(:,2)';
% 公路面积(单位：万平方公里)
hanmeng = data(:,3)';
% 公路客运量(单位：万人)
shoutan = data(:,7)';
% 公路货运量(单位：万吨)
shoumeng = data(:,8)';
p = [temp; hantan; hanmeng];  % 输入数据矩阵
t = [shoutan; shoumeng];                % 目标数据矩阵
[SamIn, minp, maxp, tn, mint, maxt] = premnmx(p, t);   % 原始样本对（输入和输出）初始化
SamOut = tn;                       % 输出样本
MaxEpochs = 500000;         % 最大训练次数
lr = 0.0005;                                % 学习率
E0 = 1e-7;                              % 目标误差
rng('default');
W1 = rand(HiddenUnitNum, InDim);      % 初始化输入层与隐含层之间的权值
B1 = rand(HiddenUnitNum, 1);                % 初始化输入层与隐含层之间的阈值
W2 = rand(OutDim, HiddenUnitNum);   % 初始化输出层与隐含层之间的权值              
B2 = rand(OutDim, 1);                              % 初始化输出层与隐含层之间的阈值
ErrHistory = zeros(MaxEpochs, 1);     
for i = 1 : MaxEpochs   
    HiddenOut = logsig(W1*SamIn + repmat(B1, 1, 1128));   % 隐含层网络输出
    NetworkOut = W2*HiddenOut + repmat(B2, 1, 1128);       % 输出层网络输出
    Error = SamOut - NetworkOut;       % 实际输出与网络输出之差
    SSE = sumsqr(Error);                       % 能量函数（误差平方和）
    ErrHistory(i) = SSE;
    if SSE < E0
        break;
    end
    % 以下六行是BP网络最核心的程序
    % 权值（阈值）依据能量函数负梯度下降原理所作的每一步动态调整量
    Delta2 = Error;
    Delta1 = W2' * Delta2 .* HiddenOut .* (1 - HiddenOut);    
    dW2 = Delta2 * HiddenOut';
    dB2 = Delta2 * ones(1128, 1); 
    dW1 = Delta1 * SamIn';
    dB1 = Delta1 * ones(1128, 1);
    % 对输出层与隐含层之间的权值和阈值进行修正
    W2 = W2 + lr*dW2;
    B2 = B2 + lr*dB2;
    % 对输入层与隐含层之间的权值和阈值进行修正
    W1 = W1 + lr*dW1;
    B1 = B1 + lr*dB1;
end
HiddenOut = logsig(W1*SamIn + repmat(B1, 1, 1128));   % 隐含层输出最终结果
NetworkOut = W2*HiddenOut + repmat(B2, 1, 1128);      % 输出层输出最终结果
a = postmnmx(NetworkOut, mint, maxt);    % 还原网络输出层的结果
x = 1 :1: 141;      % 时间轴刻度
newk = a(1, :);       % 网络输出客运量
newh = a(2, :);          % 网络输出货运量

% 利用训练好的网络进行预测
% 测试数据 
data1 = xlsread('C:\Users\admin\Desktop\grey.xlsx','Sheet3');
data2 = xlsread('C:\Users\admin\Desktop\grey.xlsx','Sheet4');
pnew=data1';
pnewn = tramnmx(pnew, minp, maxp); 
HiddenOut = logsig(W1*pnewn + repmat(B1, 1, ForcastSamNum));  % 隐含层输出预测结果
anewn = W2*HiddenOut + repmat(B2, 1, ForcastSamNum);           % 输出层输出预测结果
anew = postmnmx(anewn, mint, maxt);

%去掉波动过大值
pt0 = 1:1:141;
pt = [];
for i=1:1:141
    for j = 1:1:7
        if anew(i,j)-anew(i,j+1) > 0  && (abs(anew(i,j)-anew(i,j+1)) > 0.1e5)
            w;
            pt = [pt i];
            %break;
        end
    end
end
[ic, ia, ib] = intersect(pt0,pt); % 求 nn 与 S 的交集元素与索引值
pt0(ia) = [];
anew2 = anew(pt0,:);
%disp(anew);
ceshiC = anew2(1,:);
ceshiM = anew2(2,:);
subplot(2, 1, 1);
plot(x, ceshiC, 'r-o', x, shoutan, 'b--+');
legend('预测碳收得率', '实际收得率');
xlabel('年份');
ylabel('碳收得率');
subplot(2, 1, 2);
plot(x, ceshiM, 'r-o',x, shoumeng, 'b--+');
legend('预测锰收得率', '实际收得率');
xlabel('年份');
ylabel('锰收得率');


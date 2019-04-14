%% 该代码为基于双隐含层BP神经网络的预测



%% 清空环境变量

clc

clear


%% 训练数据预测数据提取及归一化

%下载输入输出数据

% %data=xlsread('C:\Users\admin\Desktop\matht\guanlian.xlsx')
% load data input output
% 
% 
% %从1到2000间随机排序
% 
% k=rand(1,2000);
% 
% [m,n]=sort(k);
% 
% %找出训练数据和预测数据
% 
% input_train=input(n(1:1900),:)';
% 
% output_train=output(n(1:1900));
% 
% input_test=input(n(1901:2000),:)';
% 
% output_test=output(n(1901:2000));

wjlj='C:\Users\admin\Desktop\matht\grey(2).xlsx';
sheet='Total';
%目标因素（收得率）
range0C='N2:N204';%C的收得率
centerC=xlsread(wjlj,sheet,range0C)';
range0MN='M2:M204';%Mn的收得率
centerMN=xlsread(wjlj,sheet,range0MN)';

%影响因子
range1='O2:O204';
temperature=xlsread(wjlj,sheet,range1)';
range2='G2:G204';
netC=xlsread(wjlj,sheet,range2)';
range3='H2:H204';
netMn=xlsread(wjlj,sheet,range3)';
range4='I2:I204';
netS=xlsread(wjlj,sheet,range4)';
range5='J2:J204';
netSi=xlsread(wjlj,sheet,range5)';
range6='K2:K204';
netP=xlsread(wjlj,sheet,range6)';

% temperature=normalize(temperature);
% netC=normalize(netC);
% netMn=normalize(netMn);
% netS=normalize(netS);
% netSi=normalize(netSi);
% netP=normalize(netP);

input=[temperature;netC;netMn;netS;netSi;netP];
output=centerC;

input_train=input(1:168);
output_train=output(1:168);
input_test=input(1:168);
output_test=output(1:168);

%选连样本输入输出数据归一化

[inputn,inputps]=mapminmax(input_train);

[outputn,outputps]=mapminmax(output_train);


%% BP网络训练

% %初始化网络结构

net=newff(inputn,outputn,[7 4]);

net.trainParam.epochs=1000000;

net.trainParam.lr=1e-7;

net.trainParam.goal=1e-11;


%网络训练

net=train(net,inputn,outputn);

%% BP网络预测

%预测数据归一化

inputn_test=mapminmax('apply',input_test,inputps);

%网络预测输出

an=sim(net,inputn_test);

%网络输出反归一化

BPoutput=mapminmax('reverse',an,outputps);


%% 结果分析



figure(1)

plot(BPoutput,':og')

hold on

plot(output_test,'-*');

legend('预测输出','期望输出')

title('BP网络预测输出','fontsize',12)

ylabel('函数输出','fontsize',12)

xlabel('样本','fontsize',12)

%预测误差

error=BPoutput-output_test;





figure(2)

plot(error,'-*')

title('BP网络预测误差','fontsize',12)

ylabel('误差','fontsize',12)

xlabel('样本','fontsize',12)



figure(3)

plot((output_test-BPoutput)./BPoutput,'-*');

title('神经网络预测误差百分比')

errorsum=sum(abs(error));

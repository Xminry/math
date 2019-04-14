
% Grey relation analysis

clear all
close all
clc

%文件路径
wjlj='C:\Users\admin\Desktop\matht\grey(2).xlsx';

%第几个表格sheet1
sheet='HRB500D';

%目标因素（收得率）
range0C='N2:N19';%C的收得率
centerC=xlsread(wjlj,sheet,range0C);
range0MN='M2:M19';%Mn的收得率
centerMN=xlsread(wjlj,sheet,range0MN);

%影响因子
range1='O2:O19';
temperature=xlsread(wjlj,sheet,range1);
range2='G2:G19';
netC=xlsread(wjlj,sheet,range2);
range3='H2:H19';
netMn=xlsread(wjlj,sheet,range3);
range4='I2:I19';
netS=xlsread(wjlj,sheet,range4);
range5='J2:J19';
netSi=xlsread(wjlj,sheet,range5);
range6='K2:K19';
netP=xlsread(wjlj,sheet,range6);


% define comparative and reference
%x0 = zongshouru;
%x1 = daxuesheng;
%x2 = congyerenyuan;
%x3 = xingjifandian;
x0=centerC;
x1=temperature;
x2=netC;
x3=netMn;
x4=netS;
x5=netSi;
x6=netP;


% normalization
x0 = x0 ./ mean(x0);
x1 = x1 ./ mean(x1);
x2 = x2 ./ mean(x2);
x3 = x3 ./ mean(x3);
x4=x4./mean(x4);
x5=x5./mean(x5);
x6=x6./mean(x6);

% global min and max
global_min = min(min(abs([x1; x2; x3;x4;x5;x6] - repmat(x0, [6, 1]))));
global_max = max(max(abs([x1; x2; x3;x4;x5;x6] - repmat(x0, [6, 1]))));

% set rho
rho = 0.8;

% calculate zeta relation coefficients
zeta_1 = (global_min + rho * global_max) ./ (abs(x0 - x1) + rho * global_max);
zeta_2 = (global_min + rho * global_max) ./ (abs(x0 - x2) + rho * global_max);
zeta_3 = (global_min + rho * global_max) ./ (abs(x0 - x3) + rho * global_max);
zeta_4 = (global_min + rho * global_max) ./ (abs(x0 - x4) + rho * global_max);
zeta_5 = (global_min + rho * global_max) ./ (abs(x0 - x5) + rho * global_max);
zeta_6 = (global_min + rho * global_max) ./ (abs(x0 - x6) + rho * global_max);


% show
figure;
plot(x0, 'ko-' )
hold on
plot(x1, 'b*-')
hold on
plot(x2, 'g*-')
hold on
plot(x3, 'r*-')
hold on
plot(x4, 'y*-')
hold on
plot(x5, 'c*-')
hold on
plot(x6, 'm*-')
%legend('zongshouru', 'daxuesheng', 'congyerenyuan', 'xingjifandian')
legend('C收得率', '温度', 'C', 'Mn','S','Si','P');

r1=num2str(mean(zeta_1),4);
r2=num2str(mean(zeta_2),4);
r3=num2str(mean(zeta_3),4);
r4=num2str(mean(zeta_4),4);
r5=num2str(mean(zeta_5),4);
r6=num2str(mean(zeta_6),4);



figure;
plot(zeta_1, 'b*-')
hold on
plot(zeta_2, 'g*-')
hold on
plot(zeta_3, 'r*-')
hold on
plot(zeta_4, 'y*-')
hold on
plot(zeta_5, 'c*-')
hold on
plot(zeta_6, 'm*-')
title('HRB500D Relation zeta')
%legend('daxuesheng', 'congyerenyuan', 'xingjifandian')
legend(strcat('温度:',r1), strcat('C:',r2),strcat( 'Mn:',r3),strcat('S:',r4),strcat('Si:',r5),strcat('P:',r6))

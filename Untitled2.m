
% Grey relation analysis

clear all
close all
clc

sheet='Sheet5';
range1='AT2:AT800';
center=xlsread('C:\Users\admin\Desktop\matht\aa1.xlsx',sheet,range1);
range2='D2:D800';
temperature=xlsread('C:\Users\admin\Desktop\matht\aa1.xlsx',sheet,range2);
range3='E2:E800';
zlzdc=xlsread('C:\Users\admin\Desktop\matht\aa1.xlsx',sheet,range3);%ת¯�յ�C
range4='J2:J800';
gsjz=xlsread('C:\Users\admin\Desktop\matht\aa1.xlsx',sheet,range4);%��ˮ����
%zongshouru = [3439, 4002, 4519, 4995, 5566];
%daxuesheng = [341, 409, 556, 719, 903];
%congyerenyuan = [183, 196, 564, 598, 613];
%xingjifandian = [3248, 3856, 6029, 7358, 8880];

% define comparative and reference
%x0 = zongshouru;
%x1 = daxuesheng;
%x2 = congyerenyuan;
%x3 = xingjifandian;
x0=center;
x1=temperature;
x2=zlzdc;
x3=gsjz;


% normalization
x0 = x0 ./ mean(x0);
x1 = x1 ./ mean(x1);
x2 = x2 ./ mean(x2);
x3 = x3 ./ mean(x3);

% global min and max
global_min = min(min(abs([x1; x2; x3] - repmat(x0, [3, 1]))));
global_max = max(max(abs([x1; x2; x3] - repmat(x0, [3, 1]))));

% set rho
rho = 0.5;

% calculate zeta relation coefficients
zeta_1 = (global_min + rho * global_max) ./ (abs(x0 - x1) + rho * global_max);
zeta_2 = (global_min + rho * global_max) ./ (abs(x0 - x2) + rho * global_max);
zeta_3 = (global_min + rho * global_max) ./ (abs(x0 - x3) + rho * global_max);

% show
figure;
plot(x0, 'ko-' )
hold on
plot(x1, 'b*-')
hold on
plot(x2, 'g*-')
hold on
plot(x3, 'r*-')
%legend('zongshouru', 'daxuesheng', 'congyerenyuan', 'xingjifandian')
legend('ccc', 'wendu', 'chushitan', 'gszl')

figure;
plot(zeta_1, 'b*-')
hold on
plot(zeta_2, 'g*-')
hold on
plot(zeta_3, 'r*-')
title('Relation zeta')
%legend('daxuesheng', 'congyerenyuan', 'xingjifandian')
legend('wendu', 'chushitan', 'gszl')

%% �ô���Ϊ����˫������BP�������Ԥ��



%% ��ջ�������

clc

clear


%% ѵ������Ԥ��������ȡ����һ��

%���������������

% %data=xlsread('C:\Users\admin\Desktop\matht\guanlian.xlsx')
% load data input output
% 
% 
% %��1��2000���������
% 
% k=rand(1,2000);
% 
% [m,n]=sort(k);
% 
% %�ҳ�ѵ�����ݺ�Ԥ������
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
%Ŀ�����أ��յ��ʣ�
range0C='N2:N204';%C���յ���
centerC=xlsread(wjlj,sheet,range0C)';
range0MN='M2:M204';%Mn���յ���
centerMN=xlsread(wjlj,sheet,range0MN)';

%Ӱ������
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

%ѡ����������������ݹ�һ��

[inputn,inputps]=mapminmax(input_train);

[outputn,outputps]=mapminmax(output_train);


%% BP����ѵ��

% %��ʼ������ṹ

net=newff(inputn,outputn,[7 4]);

net.trainParam.epochs=1000000;

net.trainParam.lr=1e-7;

net.trainParam.goal=1e-11;


%����ѵ��

net=train(net,inputn,outputn);

%% BP����Ԥ��

%Ԥ�����ݹ�һ��

inputn_test=mapminmax('apply',input_test,inputps);

%����Ԥ�����

an=sim(net,inputn_test);

%�����������һ��

BPoutput=mapminmax('reverse',an,outputps);


%% �������



figure(1)

plot(BPoutput,':og')

hold on

plot(output_test,'-*');

legend('Ԥ�����','�������')

title('BP����Ԥ�����','fontsize',12)

ylabel('�������','fontsize',12)

xlabel('����','fontsize',12)

%Ԥ�����

error=BPoutput-output_test;





figure(2)

plot(error,'-*')

title('BP����Ԥ�����','fontsize',12)

ylabel('���','fontsize',12)

xlabel('����','fontsize',12)



figure(3)

plot((output_test-BPoutput)./BPoutput,'-*');

title('������Ԥ�����ٷֱ�')

errorsum=sum(abs(error));

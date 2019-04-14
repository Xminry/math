clear; 
clc;
close all;
SamNum = 1128;                     % ������������
TestSamNum = 1128;              % ������������
ForcastSamNum = 141;           % Ԥ����������
HiddenUnitNum=8;             % ������
InDim = 3;                            % �����
OutDim = 2;                         % �����
% ԭʼ���� 
data = xlsread('C:\Users\admin\Desktop\grey.xlsx','Sheet2');
% ����(��λ������)
temp = data(:,1)';
% ��������(��λ������)
hantan = data(:,2)';
% ��·���(��λ����ƽ������)
hanmeng = data(:,3)';
% ��·������(��λ������)
shoutan = data(:,7)';
% ��·������(��λ�����)
shoumeng = data(:,8)';
p = [temp; hantan; hanmeng];  % �������ݾ���
t = [shoutan; shoumeng];                % Ŀ�����ݾ���
[SamIn, minp, maxp, tn, mint, maxt] = premnmx(p, t);   % ԭʼ�����ԣ�������������ʼ��
SamOut = tn;                       % �������
MaxEpochs = 500000;         % ���ѵ������
lr = 0.0005;                                % ѧϰ��
E0 = 1e-7;                              % Ŀ�����
rng('default');
W1 = rand(HiddenUnitNum, InDim);      % ��ʼ���������������֮���Ȩֵ
B1 = rand(HiddenUnitNum, 1);                % ��ʼ���������������֮�����ֵ
W2 = rand(OutDim, HiddenUnitNum);   % ��ʼ���������������֮���Ȩֵ              
B2 = rand(OutDim, 1);                              % ��ʼ���������������֮�����ֵ
ErrHistory = zeros(MaxEpochs, 1);     
for i = 1 : MaxEpochs   
    HiddenOut = logsig(W1*SamIn + repmat(B1, 1, 1128));   % �������������
    NetworkOut = W2*HiddenOut + repmat(B2, 1, 1128);       % ������������
    Error = SamOut - NetworkOut;       % ʵ��������������֮��
    SSE = sumsqr(Error);                       % �������������ƽ���ͣ�
    ErrHistory(i) = SSE;
    if SSE < E0
        break;
    end
    % ����������BP��������ĵĳ���
    % Ȩֵ����ֵ�����������������ݶ��½�ԭ��������ÿһ����̬������
    Delta2 = Error;
    Delta1 = W2' * Delta2 .* HiddenOut .* (1 - HiddenOut);    
    dW2 = Delta2 * HiddenOut';
    dB2 = Delta2 * ones(1128, 1); 
    dW1 = Delta1 * SamIn';
    dB1 = Delta1 * ones(1128, 1);
    % ���������������֮���Ȩֵ����ֵ��������
    W2 = W2 + lr*dW2;
    B2 = B2 + lr*dB2;
    % ���������������֮���Ȩֵ����ֵ��������
    W1 = W1 + lr*dW1;
    B1 = B1 + lr*dB1;
end
HiddenOut = logsig(W1*SamIn + repmat(B1, 1, 1128));   % ������������ս��
NetworkOut = W2*HiddenOut + repmat(B2, 1, 1128);      % �����������ս��
a = postmnmx(NetworkOut, mint, maxt);    % ��ԭ���������Ľ��
x = 1 :1: 141;      % ʱ����̶�
newk = a(1, :);       % �������������
newh = a(2, :);          % �������������

% ����ѵ���õ��������Ԥ��
% �������� 
data1 = xlsread('C:\Users\admin\Desktop\grey.xlsx','Sheet3');
data2 = xlsread('C:\Users\admin\Desktop\grey.xlsx','Sheet4');
pnew=data1';
pnewn = tramnmx(pnew, minp, maxp); 
HiddenOut = logsig(W1*pnewn + repmat(B1, 1, ForcastSamNum));  % ���������Ԥ����
anewn = W2*HiddenOut + repmat(B2, 1, ForcastSamNum);           % ��������Ԥ����
anew = postmnmx(anewn, mint, maxt);

%ȥ����������ֵ
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
[ic, ia, ib] = intersect(pt0,pt); % �� nn �� S �Ľ���Ԫ��������ֵ
pt0(ia) = [];
anew2 = anew(pt0,:);
%disp(anew);
ceshiC = anew2(1,:);
ceshiM = anew2(2,:);
subplot(2, 1, 1);
plot(x, ceshiC, 'r-o', x, shoutan, 'b--+');
legend('Ԥ��̼�յ���', 'ʵ���յ���');
xlabel('���');
ylabel('̼�յ���');
subplot(2, 1, 2);
plot(x, ceshiM, 'r-o',x, shoumeng, 'b--+');
legend('Ԥ�����յ���', 'ʵ���յ���');
xlabel('���');
ylabel('���յ���');


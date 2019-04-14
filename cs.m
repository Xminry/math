data = xlsread('C:\Users\admin\Desktop\matht\a0414.xlsx','Sheet1');
x1 =  data(:,1);
x2 = data(:,2);
x3 =  data(:,3);
x4 = data(:,4);
x5 = data(:,5);
x6 = data(:,6);
x7 = data(:,7);
x8 = data(:,8);
x9 = data(:,9);
x10 = data(:,10);
x11=data(:,11);
y1 = data(:,12);
y2 = data(:,13);
%y3 = data(:,3);
%y4 = data(:,4);

p = 0.5;
X1 = [normalize(x1');normalize(x2');normalize(x3');normalize(x4');normalize(x5');normalize(x6');normalize(x7');normalize(x8');normalize(x9');normalize(x10');normalize(x11')];
Y1 = [normalize(y1');normalize(y2')];
[hx,zx] = size(X1);  %X1的行列数
[hy,zy] = size(Y1);  %X2的行列数
result = zeros(hx,hy); %储存结果
MAX1 = zeros(1,2*hx);
result1 = zeros(1,zy);
for i = 1:1:hx
    change = zeros(hy,zy);
    for j = 1:1:hy
        change(j,:) = abs(X1(i,:)-Y1(j,:));
        MAX1(2*j-1) = max(change(j,:));
        MAX1(2*j) = min(change(j,:));
    end
    MAX = max(MAX1); MIN = min(MAX1);
    for j = 1:1:hy
        q = change(j,:);
        for k = 1:1:zy
            result1(k) = (MIN + p*MAX)/(q(k) + p*MAX);
        end
        result(i,j) = sum(result1)/length(result1);
    end
end
result    
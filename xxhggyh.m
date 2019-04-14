%X=[ones(length(y),1),x1',x2',x3',x4',x5',x6'];
wjlj='C:\Users\admin\Desktop\matht\moxing.xlsx';
sheet='s400D';
A=1:1:35;
x1=xlsread(wjlj,sheet,'A1:A35')';
x2=xlsread(wjlj,sheet,'B1:B35')';
x3=xlsread(wjlj,sheet,'C1:C35')';
x4=xlsread(wjlj,sheet,'D1:D35')';
x5=xlsread(wjlj,sheet,'E1:E35')';
x6=xlsread(wjlj,sheet,'F1:F35')';
x7=xlsread(wjlj,sheet,'G1:G35')';
y1=xlsread(wjlj,sheet,'H1:H35')';
y2=xlsread(wjlj,sheet,'I1:I35')';
x1=normalize(x1);
x2=normalize(x2);
x3=normalize(x3);
x4=normalize(x4);
x5=normalize(x5);
x6=normalize(x6);
x7=normalize(x7);
%y1=normalize(y1);
%y2=normalize(y2);

X=[ones(length(y1),1),x1',x2',x3',x4',x5',x6',x7'];
Y=y2';
[b,bint,r,rint,stats]=regress(Y,X);
b,bint,stats
z=b(1)+b(2)*x1+b(3)*x2+b(4)*x3+b(5)*x4+b(6)*x5+b(7)*x6+b(8)*x7;
figure(1)

plot(X,Y,'k+',X,z,'r*');
ylim([0.5 1.3]);
figure(2)
plot(A,Y,'k+-',A,z,'r*-');
ylim([0.5 1.3]);
t=(z-Y')./Y'
%rcoplot(r,rint);
figure(3)
plot(A,t);
ylim([-0.3 0.3]);
txt=mean(abs(t));

title(strcat(('Æ½¾ùÎó²îÂÊ'),num2str(txt)),'fontsize',12);
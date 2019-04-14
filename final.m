%X=[ones(length(y),1),x1',x2',x3',x4',x5',x6'];
wjlj='C:\Users\admin\Desktop\matht\final.xlsx';
sheet='Q345';
A=1:1:8;
x1=xlsread(wjlj,sheet,'A1:A8')';
x2=xlsread(wjlj,sheet,'B1:B8')';
x3=xlsread(wjlj,sheet,'C1:C8')';
x4=xlsread(wjlj,sheet,'D1:D8')';
x5=xlsread(wjlj,sheet,'E1:E8')';
x6=xlsread(wjlj,sheet,'F1:F8')';
x7=xlsread(wjlj,sheet,'G1:G8')';
y1=xlsread(wjlj,sheet,'H1:H8')';
y2=xlsread(wjlj,sheet,'I1:I8')';
y3=xlsread(wjlj,sheet,'J1:J8')';
y4=xlsread(wjlj,sheet,'K1:K8')';
y5=xlsread(wjlj,sheet,'L1:L8')';



X=[ones(length(y1),1),x1',x2',x3',x4',x5',x6',x7'];
Y=y5';
[b,bint,r,rint,stats]=regress(Y,X);
b,bint,stats
z=b(1)+b(2)*x1+b(3)*x2+b(4)*x3+b(5)*x4+b(6)*x5+b(7)*x6+b(8)*x7;
%figure(1)
%plot(X,Y,'k+',X,z,'r*');
%figure(2)
%plot(A,Y,'k+',A,z,'r*');
t=(z-Y')./Y'
%rcoplot(r,rint);
%figure(3)
%plot(A,t);
mean(abs(t))

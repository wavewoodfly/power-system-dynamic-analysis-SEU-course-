function [gen] = two_order(mpc,gen,Y,PV,Y1)

%Y1为原导纳矩阵，Y为修改后的导纳矩阵
global dt;  %外部声明语句，考C语言也得记得
GenD=mpc.GenD;
Xd1=GenD(:,4); %d暂态电抗
Pe=gen.P; %电磁功率时刻发生改变
fB=50;   %频率基值
omegaB=2*pi*fB; %电角速度基准值
tB=1/omegaB;
gen.omega=gen.omega+dt./(gen.Tj).*(gen.Pm-Pe);
gen.delta=gen.delta+dt.*(gen.omega-1-(dt./(gen.Tj).*(gen.Pm-Pe))/2)*omegaB;

[nbus_2,~]=size(Y); %两倍的可用节点数
nbus=nbus_2/2;
I=zeros(nbus,1);
I(PV,1)=abs(gen.E1).*exp(i*gen.delta)./(i*Xd1); %虚拟注入电流
I1=zeros(2*nbus,1);
for cnt=PV
    I1(2*cnt-1)=real(I(cnt));
    I1(2*cnt)=imag(I(cnt));   
end
U1=inv(Y)*I1; %I1为虚拟注入电流，U1为电压
I2=Y1*U1; %实际电流
for cnt=PV
    U(cnt)=U1(2*cnt-1)+i*U1(2*cnt);  
end 
gen.U(PV)=U(PV);  %更新的发电机机端电压
IG=(abs(gen.E1).*exp(i*gen.delta)-gen.U)./(i*Xd1);

for cnt=1:nbus
    I(cnt)=I2(2*cnt-1)+i*I2(2*cnt);  
end 
IG=I(PV);
gen.P=real(abs(gen.E1).*exp(i*gen.delta).*conj(IG));
gen.P=real(gen.U.*conj(IG));
end
function [gen] = third_order2(mpc,gen,Y1,Y2,PV)

%Y1为原导纳矩阵，Y2为修改后的导纳矩阵
global dt;  %外部声明语句，考C语言也得记得
GenD=mpc.GenD;
GenQ=mpc.GenQ;
Xd=GenD(:,3);%d轴电抗
Xd1=GenD(:,4); %d暂态电抗
Xd2=GenD(:,5); %d次暂态电抗
Xq=GenQ(:,2);%q轴电抗
Xq1=GenQ(:,3); %Q暂态电抗
Xq2=GenQ(:,4); %Q次暂态电抗
Td=GenD(:,6); %d轴开环时间常数 %应该是有名值
Tq=GenQ(:,5);%q轴开环时间常数
ra=[0;0];

i_d=gen.i_d;
i_q=gen.i_q;
u_d=gen.u_d;
u_q=gen.u_q;
Gx=gen.Gx;
Gy=gen.Gy;
Bx=gen.Bx;
By=gen.By;

fB=50;   %频率基值
omegaB=2*pi*fB; %电角速度基准值
tB=1/omegaB;
%% 采用改进欧拉法
gen.omega=gen.omega1+0.5*dt./(gen.Tj).*(gen.Tm-(abs(gen.Eq1).*abs(i_q)-(Xd1-Xq).*abs(i_d).*abs(i_q)))+0.5*(gen.omega-gen.omega1);
gen.delta=gen.delta1+0.5*dt.*(gen.omega-1)*omegaB+0.5*(gen.delta-gen.delta1);
gen.Eq1=gen.Eq11+0.5*dt./(Td).*(gen.Ef-(gen.Eq1+(Xd-Xd1).*abs(i_d)))+0.5*(gen.Eq1-gen.Eq11);

 Ex=real(i*gen.Eq1.*exp(i*(gen.delta-pi/2)));
 Ey=imag(i*gen.Eq1.*exp(i*(gen.delta-pi/2)));
Ex=gen.Eq1.*cos(gen.delta);
Ey=gen.Eq1.*sin(gen.delta);

[nbus_2,~]=size(Y2); %两倍的可用节点数
nbus=nbus_2/2;
I1=zeros(nbus_2,1);%虚拟注入电流

for cnt=1:2 %思考怎么通用化
    I1(2*cnt-1:2*cnt,1)=[Gx(cnt),Bx(cnt);By(cnt),Gy(cnt)]*[Ex(cnt);Ey(cnt)];  
end

U1=inv(Y2)*I1; %I1为虚拟注入电流，U1为电压
I2=Y1*U1; %实际电流
for cnt=PV
    U(cnt,1)=U1(2*cnt-1)+i*U1(2*cnt);  
end 
gen.U(PV)=U(PV);  %更新的发电机机端电压

for cnt=1:nbus
    I(cnt,1)=I2(2*cnt-1)+i*I2(2*cnt);  
end 
IG=I(PV);%更新机端电流
UG=gen.U;
gen.i_d=real(IG.*exp(i*(pi/2-gen.delta))).*exp(i*(gen.delta-pi/2));
gen.i_q=imag(IG.*exp(i*(pi/2-gen.delta))).*exp(i*(gen.delta-pi/2+pi/2));
gen.u_d=real(UG.*exp(i*(pi/2-gen.delta))).*exp(i*(gen.delta-pi/2));
gen.u_q=imag(UG.*exp(i*(pi/2-gen.delta))).*exp(i*(gen.delta-pi/2+pi/2));


end
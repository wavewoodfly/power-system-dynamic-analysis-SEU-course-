function [gen] = third_order_init(mpc,gen)
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


%定子励磁电动势
%% 建立Xad基值系统
%% step1 确立公共基值
fB=50;   %频率基值
omegaB=2*pi*fB; %电角速度基准值
tB=1/omegaB;

%% step2:书45页，通过手册得到参数
X1=[0;0];%发电机漏抗,短路瞬间电枢反应未表现，暂态电抗

Xad=Xd-X1; % 稳态直轴电枢反应电抗，反应电枢反应磁通的强弱
Xaq=Xq-X1; % 稳态交轴轴电枢反应电抗
Xf=(Xad.^2)./Xd-Xd1; %励磁电抗
XD=(Xd1-X1).^2./(Xd1-Xd2)-(Xd1-X1)+Xad; %转子阻尼绕组直轴电抗，封闭
XD1=XD-Xad;
XQ=(Xad.^2)./Xd-Xq2;
rf=Xf./(omegaB*Td);
rD=(XD1+Xd1-X1)./(omegaB*Td);
rQ=XQ./(omegaB*Tq); %三阶模型忽略了阻尼绕组，转化成阻尼项

%假设ra=0
ra=[0;0];

%% step3 书47-48,但初始值得写出了
%初始值,Ed,Eq全程不变，omega=1
% 稳态过程
i_init=conj((gen.P+1i*gen.Q)./(gen.U.*exp(1i*gen.theta)));
phi=angle(i_init);  % 电流x,y角

UG=gen.U.*exp(1i*gen.theta); %发电机机端电压
EQ=UG+1i*Xq.*i_init;

gen.delta=angle(EQ); %功角初始值，见老师材料第50页
gen.i_d=real(i_init.*exp(i*(pi/2-gen.delta))).*exp(i*(gen.delta-pi/2));
gen.i_q=imag(i_init.*exp(i*(pi/2-gen.delta))).*exp(i*(gen.delta-pi/2+pi/2));
gen.u_d=real(UG.*exp(i*(pi/2-gen.delta))).*exp(i*(gen.delta-pi/2));
gen.u_q=imag(UG.*exp(i*(pi/2-gen.delta))).*exp(i*(gen.delta-pi/2+pi/2));
i_d=gen.i_d;
i_q=gen.i_q;
u_d=gen.u_d;
u_q=gen.u_q;

% 发电机初始值
gen.Eq1=abs(u_q+i*i_d.*Xd1);
gen.Eq=abs(UG+i*Xd.*i_d+i*Xq.*i_q);   %明确代数和相量
gen.Pm=real(UG.*conj(i_init)); %同样全程保持恒定，等于P
gen.omega=1; %初始状态
gen.Tj=mpc.GenQ(:,6);
%励磁电动势,先转化dq再转化xy

gen.Ef=gen.Eq1+(Xd-Xd1).*abs(i_d);   %明确代数和相量

gen.Tm=gen.Eq1.*abs(i_q)-(Xd1-Xq).*abs(i_d).*abs(i_q);
end
clc;
clear all;

global dt;
global step;
global time;
tic
mpc=SEU2G5N; %节点


%% 仿真参数
dt=10.0e-4;	%步长,s
endt=2.0;	%仿真时长,s
step1=ceil(endt/dt);
endt2=2.1;	%仿真总时长,s
step2=ceil(endt2/dt);
endt3=5.0;	%仿真总时长,s
step3=ceil(endt3/dt);


%% 系统参数初始化
time=0.0;
step=1;

%% 元件初始化，修正导纳矩阵

[U,theta,Pi,Qi]=ACpf(mpc);
gen.U=U([1 2]);
gen.theta=theta([1 2]);
gen.P=Pi([1 2]).';
gen.Q=Qi([1 2]).';
gen.omega=1; %状态量故障瞬间不突变
[i_init,gen.E1] = two_order_init(mpc,gen);%仿真过程中，E1保持不变
gen.delta=angle(gen.E1); %功角初始值，书138页和57页
gen.Pm=real(gen.E1.*conj(i_init)); %同样全程保持恒定，等于P
gen.Tj=mpc.GenQ(:,6);
PQ=[3 4 5]; %负荷节点
PV=[1 2];
YL = load_Y(Pi,Qi,U,theta);
[Y1 Y2] = amendY(mpc,PQ,YL);%Y1为原导纳矩阵，Y2为修改过的导纳矩阵
[gen] = two_order(mpc,gen,Y2,PV,Y1);
%% 开始仿真
% 在不发生故障时，Y2不变
for step=1:step1
    [gen] = two_order(mpc,gen,Y2,PV,Y1);
    powerangle(step)=wrapToPi(gen.delta(1)-gen.delta(2));
    vol(step)=gen.U(1);
    omega(step)=gen.omega(1);
end
%plot(omega);
plot(powerangle);
figure

%% 发生故障,发生三相短路故障
%% 修改导纳矩阵,从而电压突变
fault=[5];
Y3=Y2;
Y4=Y1;
Y2([2*fault-1,2*fault],[2*fault-1,2*fault])=9000000;
Y1([2*fault-1,2*fault],[2*fault-1,2*fault])=9000000; %前后矩阵都要修改
% Y2([2*fault-1,2*fault],:)=[];
% Y2(:,[2*fault-1,2*fault])=[];
for step=step1+1:step2
    [gen] = two_order(mpc,gen,Y2,PV,Y1);
    powerangle(step)=wrapToPi(gen.delta(1)-gen.delta(2));
    vol(step)=gen.U(1);
    omega(step)=gen.omega(1);
end
plot (powerangle);
Y2=Y3;
Y1=Y4;
for step=step2+1:step3
    [gen] = two_order(mpc,gen,Y2,PV,Y1);
    powerangle(step)=wrapToPi(gen.delta(1)-gen.delta(2));
    vol(step)=gen.U(1);
    omega(step)=gen.omega(1);
end
plot (powerangle);
figure
plot(omega)

toc


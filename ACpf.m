function [U theta Pi Qi]=ACpf(mpc)
% 本函数专用于计算东南大学动态分析潮流文件
%   此处提供详细说明
%首先，进行初始量计算
clear
clc
mpc=SEU2G5N;
%生成雅可比矩阵
Y=makeY(mpc);
G=real(Y);
B=imag(Y);
%生成初始值，设节点1为平衡节点，节点2为PV节点，节点3，4，5为PQ节点
PVQ=[2 3 4 5];% PV节点+PQ个数
n=length(PVQ);
PQ=[3 4 5];% PQ节点个数
m=length(PQ);
theta=mpc.bus(:,3);%初始相角
U=mpc.bus(:,2);%初始电压
[dP,dQ,Pi,Qi] = unbalanced(PVQ,PQ,mpc,theta,U,G,B);
[J] = Jacobi( PVQ,PQ,U,theta,B,G,Pi,Qi);%此处输入都是包含平衡节点的全局解
left=[dP dQ].';
right=-J^-1*left;
theta(PVQ)=theta(PVQ)+right(1:n);
U(PQ)=U(PQ)+U(PQ).*right(n+1:n+m);
%开始迭代
Tmax=10;
% for cnt=1:Tmax
%     [dP,dQ,Pi,Qi] = unbalanced(PVQ,PQ,mpc,theta,U,G,B);
%     [J] = Jacobi( PVQ,PQ,U,theta,B,G,Pi,Qi);%此处输入都是包含平衡节点的全局解
%     left=[dP dQ].';
%     right=-J^-1*left;
%     theta(PVQ)=theta(PVQ)+right(1:n);
%     U(PQ)=U(PQ)+U(PQ).*right(n+1:n+m);
% 
% end
flag=0;
while norm([dP,dQ])>0.00001
    [dP,dQ,Pi,Qi] = unbalanced(PVQ,PQ,mpc,theta,U,G,B);
    [J] = Jacobi( PVQ,PQ,U,theta,B,G,Pi,Qi);%此处输入都是包含平衡节点的全局解
    left=[dP dQ].';
    right=-J^-1*left;
    theta(PVQ)=theta(PVQ)+right(1:n);
    U(PQ)=U(PQ)+U(PQ).*right(n+1:n+m); 
    flag=flag+1;
    if flag>Tmax
        break
    end
end


end
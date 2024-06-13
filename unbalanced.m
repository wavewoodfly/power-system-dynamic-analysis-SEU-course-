function [dP,dQ,Pi,Qi] = unbalanced(PVQ,PQ,mpc,theta,U,G,B)
% 用于计算功率不平衡量
%   此处提供详细说明
%计算ΔPi有功的不平衡量
Ps=mpc.bus(:,4)';
Qs=mpc.bus(:,5)';
[nbus,np1]=size(mpc.bus);
for i=1:nbus
	for j=1:nbus
		Pn(j)=U(i)*U(j)*(G(i,j)*cos(theta(i)-theta(j))+B(i,j)*sin(theta(i)-theta(j)));%输出
	end
	Pi(i)=sum(Pn);
end
dP=Ps-Pi; %dP有n-1个
dP=dP(PVQ);
%计算ΔQi无功的不平衡量
for i=1:nbus
	for j=1:nbus
		Qn(j)=U(i)*U(j)*(G(i,j)*sin(theta(i)-theta(j))-B(i,j)*cos(theta(i)-theta(j)));%输出
	end
	Qi(i)=sum(Qn);
end
dQ=Qs-Qi; %dQ有m个  
dQ=dQ(PQ);

end
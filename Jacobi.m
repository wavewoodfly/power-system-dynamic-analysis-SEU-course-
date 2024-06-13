function [J] = Jacobi( PVQ,PQ,U,theta,B,G,Pi,Qi)
%UNTITLED5 此处提供此函数的摘要
%   此处提供详细说明
%雅可比矩阵的计算
%分块 H N K L
%i!=j时
for i=PVQ
    for j=PVQ
        H(i,j)=-U(i)*U(j)*(G(i,j)*sin(theta(i)-theta(j))-B(i,j)*cos(theta(i)-theta(j)));
    end
end

for i=PVQ
    for j=PVQ
        N(i,j)=-U(i)*U(j)*(G(i,j)*cos(theta(i)-theta(j))+B(i,j)*sin(theta(i)-theta(j)));
    end
end
for i=PQ
    for j=PQ
        K(i,j)=U(i)*U(j)*(G(i,j)*cos(theta(i)-theta(j))+B(i,j)*sin(theta(i)-theta(j)));
    end
end
for i=PQ
    for j=PQ
        L(i,j)=-U(i)*U(j)*(G(i,j)*sin(theta(i)-theta(j))-B(i,j)*cos(theta(i)-theta(j)));
    end
end
%i==j时
for i=PVQ
    H(i,i)=U(i).^2*B(i,i)+Qi(i);
end
for i=PVQ
    N(i,i)=-U(i).^2*G(i,i)-Pi(i);
end
for i=PQ
    K(i,i)=U(i).^2*G(i,i)-Pi(i);
end
for i=PQ
    L(i,i)=U(i).^2*B(i,i)-Qi(i);
end

H=H(PVQ,PVQ);
N=N(PVQ,PQ);

K=K(PQ,PVQ);
L=L(PQ,PQ);
%合成雅可比矩阵
J=[H N;K L];


end

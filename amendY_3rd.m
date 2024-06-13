function [Y1,Y2,gen] = amendY_3rd(Y,mpc,gen,PV,PQ,YL)
% 修正导纳矩阵
%   此处显示详细说明

[m,n]=size(Y); %修正导纳矩阵
for cnt1=1:m
    for cnt2=1:n
        G1=real(Y(cnt1,cnt2));
        B1=imag(Y(cnt1,cnt2));
        Y2(cnt1*2-1,cnt2*2-1)=G1;
        Y2(cnt1*2,cnt2*2)=G1; 
        Y2(cnt1*2-1,cnt2*2)=-B1;        
        Y2(cnt1*2,cnt2*2-1)=B1;   
    end
end
Y1=Y2;  %原始导纳矩阵
% Y2求得新的，加入负荷的矩阵
    G1=real(YL);
    B1=imag(YL);
for cnt=PQ
    Y2(cnt*2-1,cnt*2-1)=Y2(cnt*2-1,cnt*2-1)+G1(cnt);
    Y2(cnt*2,cnt*2)=Y2(cnt*2,cnt*2)+G1(cnt); 
    Y2(cnt*2-1,cnt*2)=Y2(cnt*2-1,cnt*2)-B1(cnt);        
    Y2(cnt*2,cnt*2-1)=Y2(cnt*2,cnt*2-1)+B1(cnt);       
end
%% 修正发电机节点
GenD=mpc.GenD;
GenQ=mpc.GenQ;
Xd1=GenD(:,4); %d暂态电抗
Xq1=GenQ(:,3); %Q暂态电抗
ra=[0;0];
gen.Gx=1./(ra.^2+Xd1.*Xq1).*(ra-(Xd1-Xq1).*sin(2*gen.delta)/2);
gen.Bx=1./(ra.^2+Xd1.*Xq1).*(1/2*(Xd1+Xq1)+(Xd1-Xq1).*cos(2*gen.delta)/2);
gen.Gy=1./(ra.^2+Xd1.*Xq1).*(ra+(Xd1-Xq1).*sin(2*gen.delta)/2);
gen.By=1./(ra.^2+Xd1.*Xq1).*(-1/2*(Xd1+Xq1)+(Xd1-Xq1).*cos(2*gen.delta)/2);
Gx=gen.Gx;
Gy=gen.Gy;
Bx=gen.Bx;
By=gen.By;

for cnt=PV
    Y2(cnt*2-1,cnt*2-1)=Y2(cnt*2-1,cnt*2-1)+Gx(cnt);
    Y2(cnt*2,cnt*2)=Y2(cnt*2,cnt*2)+Gy(cnt); 
    Y2(cnt*2-1,cnt*2)=Y2(cnt*2-1,cnt*2)+Bx(cnt);        
    Y2(cnt*2,cnt*2-1)=Y2(cnt*2,cnt*2-1)+By(cnt);       
end


end


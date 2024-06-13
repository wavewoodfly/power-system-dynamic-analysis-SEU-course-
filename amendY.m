function [Y1,Y2] = amendY(mpc,PQ,YL)
% 修正导纳矩阵
%   此处显示详细说明
Y=makeY(mpc);
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
Xd1=GenD(:,4); %d暂态电抗
BG=-1./Xd1;
GG=[0;0];
PV=[1 2];
for cnt=PV
    Y2(cnt*2-1,cnt*2-1)=Y2(cnt*2-1,cnt*2-1)+GG(cnt);
    Y2(cnt*2,cnt*2)=Y2(cnt*2,cnt*2)+GG(cnt); 
    Y2(cnt*2-1,cnt*2)=Y2(cnt*2-1,cnt*2)-BG(cnt);        
    Y2(cnt*2,cnt*2-1)=Y2(cnt*2,cnt*2-1)+BG(cnt);       
end


end


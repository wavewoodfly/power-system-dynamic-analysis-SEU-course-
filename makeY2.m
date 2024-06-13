function Y = makeY(mpc)
% 本函数用于生成节点导纳矩阵
%  算例数据为SEU2G5N
% 生成对角矩阵（参考高等电力网络27页）
% XYX在此修改于2022.8.13
[nbr,np2]=size(mpc.branch);%number of branch,number of property
[nbus,np1]=size(mpc.bus);
A=zeros(nbus,nbr);%生成支路关联矩阵
for cnt=1:nbr
    x=mpc.branch(cnt,1);
    y=mpc.branch(cnt,2);
    A(x,cnt)=1;
    A(y,cnt)=-1;
end
Y=zeros(nbus,nbus);
for cnt=1:nbr  %开始叠加
    M1=A(:,cnt);
    M2=M1;
    if (mpc.branch(cnt,9)~=0)
        t=mpc.branch(cnt,9);
        M2(mpc.branch(cnt,1))=1/t;
        M2(mpc.branch(cnt,2))=-1;
    end
    yl=1/(mpc.branch(cnt,3)+1i*mpc.branch(cnt,4));
    Y=Y+M2*yl*M2';

end
for cnt=1:nbr %加上对地支路
    M=zeros(nbus,1);
    M(mpc.branch(cnt,1))=1;
    Y=Y+M*1i*mpc.branch(cnt,5)/2*M';

end
for cnt=1:nbr %加上对地支路
    M=zeros(nbus,1);
    M(mpc.branch(cnt,2))=1;
    Y=Y+M*1i*mpc.branch(cnt,5)/2*M';
end
for cnt=1:nbus
    if mpc.bus(cnt,6)~=0
        Y(cnt,cnt)=Y(cnt,cnt)+1i*mpc.bus(cnt,6)/mpc.baseMVA
    end
end
B=imag(Y);
G=real(Y);
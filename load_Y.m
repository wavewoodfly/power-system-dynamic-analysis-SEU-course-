function YL = load_Y(P,Q,U,theta)
% 输出负荷导纳
%   此处显示详细说明
P=P.';
Q=Q.';
% P=P([PQ]).';
% Q=Q([PQ]).';
% U=U([PQ]);
% theta=theta([PQ]);
IL=-(P-i*Q)./(U.*exp(-i*theta));
YL=IL./(U.*exp(i*theta));
end


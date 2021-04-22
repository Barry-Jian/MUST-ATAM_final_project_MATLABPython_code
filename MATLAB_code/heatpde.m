function [c,f,s] = heatpde(r,t,T,Tr)

% 从外向内各层厚度 d（米），密度 rho，比热 cp，热传导率 k，假人的半径 r0（米）
global d rho cp k r0;

% 计算对时间导数前面的系数 c = rho*cp
c = (r>=r0 && r<=r0+d(4))*rho(4)*cp(4) + ...
    (r>r0+d(4) && r<=r0+d(4)+d(3))*rho(3)*cp(3) + ...
    (r>r0+d(4)+d(3) && r<=r0+d(4)+d(3)+d(2))*rho(2)*cp(2) + ...
    (r>r0+d(4)+d(3)+d(2) && r<=r0+sum(d))*rho(1)*cp(1);

% 计算 f = k*Tr (Tr 是 T 对 r 的导数)
kf = (r>=r0 && r<=r0+d(4))*k(4) + ...
    (r>r0+d(4) && r<=r0+d(4)+d(3))*k(3) + ...
    (r>r0+d(4)+d(3) && r<=r0+d(4)+d(3)+d(2))*k(2) + ...
    (r>r0+d(4)+d(3)+d(2) && r<=r0+sum(d))*k(1);
f = kf*Tr;

% 无源项 s = 0
s = 0;
% s = (r>=r0+d(4)+d(3)+d(2) && r<=r0+sum(d))*(-mu*(T-T1));


end
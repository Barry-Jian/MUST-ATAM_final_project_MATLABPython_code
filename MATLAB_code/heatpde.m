function [c,f,s] = heatpde(r,t,T,Tr)

% �������ڸ����� d���ף����ܶ� rho������ cp���ȴ����� k�����˵İ뾶 r0���ף�
global d rho cp k r0;

% �����ʱ�䵼��ǰ���ϵ�� c = rho*cp
c = (r>=r0 && r<=r0+d(4))*rho(4)*cp(4) + ...
    (r>r0+d(4) && r<=r0+d(4)+d(3))*rho(3)*cp(3) + ...
    (r>r0+d(4)+d(3) && r<=r0+d(4)+d(3)+d(2))*rho(2)*cp(2) + ...
    (r>r0+d(4)+d(3)+d(2) && r<=r0+sum(d))*rho(1)*cp(1);

% ���� f = k*Tr (Tr �� T �� r �ĵ���)
kf = (r>=r0 && r<=r0+d(4))*k(4) + ...
    (r>r0+d(4) && r<=r0+d(4)+d(3))*k(3) + ...
    (r>r0+d(4)+d(3) && r<=r0+d(4)+d(3)+d(2))*k(2) + ...
    (r>r0+d(4)+d(3)+d(2) && r<=r0+sum(d))*k(1);
f = kf*Tr;

% ��Դ�� s = 0
s = 0;
% s = (r>=r0+d(4)+d(3)+d(2) && r<=r0+sum(d))*(-mu*(T-T1));


end
function [pa,qa,pb,qb] = heatpdebc(a,Ta,b,Tb,t)

% Ga 是皮肤的热阻抗倒数，Gb 是最外边界的热阻抗倒数，T1 是环境温度，T0 是体内温度
global Ga Gb T1 T0;

% r=a 处的边界条件
qa = -1;
pa = Ga*(Ta-T0);

% r=b 处的边界条件，等于环境温度 T1
qb = 1;
pb = Gb*(Tb-T1);
end
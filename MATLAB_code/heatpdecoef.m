function Ta = heatpdecoef(G0,G1,r,t)

global Ga Gb;
Ga = G0; Gb = G1;

% 求解热传导方程
sol = pdepe(1,@heatpde,@heatpdeic,@heatpdebc,r,t);

% 提取出皮肤外侧即 r=a 处的温度
Ta = sol(:,1,1);
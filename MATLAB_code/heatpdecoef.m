function Ta = heatpdecoef(G0,G1,r,t)

global Ga Gb;
Ga = G0; Gb = G1;

% ����ȴ�������
sol = pdepe(1,@heatpde,@heatpdeic,@heatpdebc,r,t);

% ��ȡ��Ƥ����༴ r=a �����¶�
Ta = sol(:,1,1);
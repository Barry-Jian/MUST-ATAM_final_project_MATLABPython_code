function [pa,qa,pb,qb] = heatpdebc(a,Ta,b,Tb,t)

% Ga ��Ƥ�������迹������Gb ������߽�����迹������T1 �ǻ����¶ȣ�T0 �������¶�
global Ga Gb T1 T0;

% r=a ���ı߽�����
qa = -1;
pa = Ga*(Ta-T0);

% r=b ���ı߽����������ڻ����¶� T1
qb = 1;
pb = Gb*(Tb-T1);
end
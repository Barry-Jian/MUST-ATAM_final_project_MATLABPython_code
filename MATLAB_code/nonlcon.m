function [cineq,ceq] = nonlcon(d2,r0,t)

global d;

Ta = heatpded(d2,d(4),r0,t);
cineq(1) = max(Ta)-47;
cineq(2) = nnz(Ta>44)*(t(2)-t(1))-300;
ceq = [];


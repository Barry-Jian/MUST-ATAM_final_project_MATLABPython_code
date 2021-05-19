function [cineq,ceq] = nonlcon2(d2,d4,r0,t)

Ta = heatpded(d2,d4,r0,t);
cineq(1) = max(Ta)-47;
cineq(2) = nnz(Ta>44)*(t(2)-t(1))-300;
ceq = [];

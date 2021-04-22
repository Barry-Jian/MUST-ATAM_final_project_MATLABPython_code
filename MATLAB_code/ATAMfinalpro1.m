clear all;
clc;
LW = 'LineWidth'; FS = 'FontSize';
set(0,'DefaultAxesFontSize',14);
%% Question（1）

% 从外向内各层厚度 d（米），密度 rho，比热 cp，热传导率 k
global d rho cp k;
d = 0.001*[0.6; 6; 3.6; 5];
rho = [300; 862; 74.2; 1.18];
cp = [1377; 2100; 1726; 1005];
k = [0.082; 0.37; 0.045; 0.028];

% The outermost ambient temperature is T1, and the normal temperature inside the dummy is T0
global T1 T0;
T1 = 75; T0 = 37;

% The radius of the dummy is r0 (m), which has little effect on the subsequent fitting of Ga and Gb
global r0; 
r0 = 0.2;

% Read the temperature distribution outside the skin
tgiven = xlsread('C:\Users\sunjin\Desktop\Advanced Topics in Applied Mathematics\CUMCM-2018-Problem-A-Chinese-Appendix.xlsx',2,'A3:A5403');
Tgiven = xlsread('C:\Users\sunjin\Desktop\Advanced Topics in Applied Mathematics\CUMCM-2018-Problem-A-Chinese-Appendix.xlsx',2,'B3:B5403');

% Discrete points in space and time, h is the space step
r1 = r0 + sum(d); h = 0.0001; nr = round((r1-r0)/h)+1;
r = linspace(r0,r0+sum(d),nr);
t = tgiven;

% The thermal impedance coefficient(热阻抗系数) of the skin is Ga,
% The thermal impedance coefficient(热阻抗系数) between the outermost layer and the air is Gb
global Ga Gb;

% Fit Ga and Gb, find the parameters Ga = 8.5548, Gb = 115.6913
TaErr = @(G) norm(Tgiven-heatpdecoef(G(1),G(2),r,t))^2;
[G,Err] = fminsearch(TaErr,[8.5; 85]);

% Use the fitted Ga(8.5548) and Gb(115.6913) to solve the heat conduction equation
Ga = G(1); Gb = G(2);
sol = pdepe(1,@heatpde,@heatpdeic,@heatpdebc,r,t);
T = sol(:,:,1);

% Surface of solution
figure; surf(r,t,T,'EdgeColor','none');
xlabel('Radial r'); ylabel('Time t'); zlabel('Temperature T');

% Solve the relationship between r=a (outside the skin) and time, compare with Appendix 2
figure; plot(t,T(:,1),':','LineWidth',2);
xlabel('Time t（s）'); ylabel('Outer skin temperature T'); grid on;
hold on; plot(tgiven,Tgiven,'--',LW,2);
hl = legend('Model prediction','Appendix 2'); set(hl,'FontSize',9);
%figure; plot(tgiven,interp1(t,T(:,1),tgiven)-Tgiven);
%xlabel('时间 t（秒）'); ylabel('模型与附件2误差'); grid on;
plot(tgiven,T(:,1)-Tgiven);
xlabel('Time t（s）'); ylabel('Error between model prediction and Annex 2'); grid on;


% Animation of temperature distribution in space over time
% figure; 
% for n = 1:1001
%     plot(r,T(n,:),LW,2); grid on; 
%     xlabel('径向 r'); ylabel('温度 T');
%     ylim([30,75]); pause(0.001);  
% end

% 保存温度的时空分布矩阵 T 到 csv 表，再手工另存为 .xlsx
%csvwrite('problem1.csv',T);
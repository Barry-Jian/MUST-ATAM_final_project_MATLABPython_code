clear all;
clc;
LW = 'LineWidth'; FS = 'FontSize';
set(0,'DefaultAxesFontSize',14);
%% 问题（1）

% 从外向内各层厚度 d（米），密度 rho，比热 cp，热传导率 k
global d rho cp k;
d = 0.001*[0.6; 6; 3.6; 5];
rho = [300; 862; 74.2; 1.18];
cp = [1377; 2100; 1726; 1005];
k = [0.082; 0.37; 0.045; 0.028];

% 最外层的环境温度 T1，假人体内的常温是 T0
global T1 T0;
T1 = 75; T0 = 37;

% 假人的半径 r0（米）：对后面拟合 Ga, Gb 影响较小
global r0; 
r0 = 0.2;

% 已知数据：皮肤外侧温度分布
tgiven = xlsread('C:\Users\sunjin\Desktop\Advanced Topics in Applied Mathematics\CUMCM-2018-Problem-A-Chinese-Appendix.xlsx',2,'A3:A5403');
Tgiven = xlsread('C:\Users\sunjin\Desktop\Advanced Topics in Applied Mathematics\CUMCM-2018-Problem-A-Chinese-Appendix.xlsx',2,'B3:B5403');

% 空间和时间离散点， h 是空间步长
r1 = r0 + sum(d); h = 0.0001; nr = round((r1-r0)/h)+1;
r = linspace(r0,r0+sum(d),nr);
t = tgiven;

% 皮肤的热阻抗倒数 Ga，最外层与空气间的热阻抗倒数 Gb
global Ga Gb;

% 拟合 Ga 和 Gb，找到的参数 Ga = 8.5548, Gb = 115.6913
TaErr = @(G) norm(Tgiven-heatpdecoef(G(1),G(2),r,t))^2;
[G,Err] = fminsearch(TaErr,[8.5; 85]);

% 使用拟合好的 Ga 和 Gb 求解热传导方程
% Ga = 8.5548; Gb = 115.6913;
Ga = G(1); Gb = G(2);
sol = pdepe(1,@heatpde,@heatpdeic,@heatpdebc,r,t);
T = sol(:,:,1);

% 解的曲面
figure; surf(r,t,T,'EdgeColor','none');
xlabel('径向 r'); ylabel('时间 t'); zlabel('温度 T');

% 解在 r=a 处（皮肤外侧）与时间的关系，与附件2比较
figure; plot(t,T(:,1),':','LineWidth',2);
xlabel('时间 t（秒）'); ylabel('皮肤外侧温度 T'); grid on;
hold on; plot(tgiven,Tgiven,'--',LW,2);
hl = legend('模型预测','附件2'); set(hl,'FontSize',18);
%figure; plot(tgiven,interp1(t,T(:,1),tgiven)-Tgiven);
%xlabel('时间 t（秒）'); ylabel('模型与附件2误差'); grid on;
plot(tgiven,T(:,1)-Tgiven);
xlabel('时间 t（秒）'); ylabel('模型与附件2误差'); grid on;



% 温度在空间分布随时间变化的动画
% figure; 
% for n = 1:1001
%     plot(r,T(n,:),LW,2); grid on; 
%     xlabel('径向 r'); ylabel('温度 T');
%     ylim([30,75]); pause(0.001);  
% end

% 保存温度的时空分布矩阵 T 到 csv 表，再手工另存为 .xlsx
%csvwrite('problem1.csv',T);
%% 问题（2）

% 已知参数设定
T1 = 65; d(4) = 0.001*5.5;
t = linspace(0,3600,3601);

% 从小到大直接搜索
for d2 = 0.0171:0.0001:0.0191
    Ta = heatpded(d2,d(4),r0,t); hold off;
    plot(t,Ta); ylim([T0;T1]); grid on;  hold on;
    plot([t(1);t(end)],[44;44]);
    tc = t(find(Ta>44,1));
    if ~isempty(tc)
        plot([tc;tc],[T0;T1]);
        if (t(end)-tc)<=300 && max(Ta)<=47
            break;
        end
    elseif max(Ta)<=47
        break;
    end
    pause(0.0001);
end

% 从大到小直接搜索
% for d2 = 0.025:-0.0001:0.0006
%     Ta = heatpded(d2,d(4),r0,t); hold off;
%     plot(t,Ta); ylim([T0;T1]); grid on;  hold on;
%     plot([t(1);t(end)],[44;44]);
%     tc = t(find(Ta>44,1));
%     if ~isempty(tc)
%         plot([tc;tc],[T0;T1]);
%         if (t(end)-tc)>300 || max(Ta)>47
%             break;
%         end
%     elseif max(Ta)>47
%         break;
%     end
%     pause(0.0001);
% end



% nonlinearly constrained minimization
%fun = @(d2) d2;
% d2 = fmincon(fun,0.025,[],[],[],[],0.0006,0.025,@(d2)nonlcon(d2,r0,t))
%d2 = patternsearch(fun,0.0341,[],[],[],[],0.0097,0.0341,@(d2)nonlcon(d2,r0,t))
%d2 = ga(fun,1,[],[],[],[],0.0171,0.0191, @(d2)nonlcon(d2,r0,t))

%% 问题（3）

% 已知参数设定
% T1 = 80;
% t = linspace(0,1800,1801);

% 先以 II 层厚度最小为目标进行优化
% fun2 = @(d24) d24(1);
% d24 = patternsearch(fun2,[0.025;0.0064],[],[],[],[],[0.0006;0.0006],[0.025;0.0064],@(d24)nonlcon2(d24(1),d24(2),r0,t))

% 取最小 II 层厚度，再以 IV 层厚度最小为目标优化
% fun3 = @(d4) d4;
% d4 = patternsearch(fun3,0.0064,[],[],[],[],0.0006,0.0064,@(d4)nonlcon2(d24(1),d4,r0,t))
plot(t,T)
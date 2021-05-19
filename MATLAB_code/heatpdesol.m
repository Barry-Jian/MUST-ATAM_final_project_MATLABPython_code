clear all;
clc;
LW = 'LineWidth'; FS = 'FontSize';
set(0,'DefaultAxesFontSize',14);
%% ���⣨1��

% �������ڸ����� d���ף����ܶ� rho������ cp���ȴ����� k
global d rho cp k;
d = 0.001*[0.6; 6; 3.6; 5];
rho = [300; 862; 74.2; 1.18];
cp = [1377; 2100; 1726; 1005];
k = [0.082; 0.37; 0.045; 0.028];

% �����Ļ����¶� T1���������ڵĳ����� T0
global T1 T0;
T1 = 75; T0 = 37;

% ���˵İ뾶 r0���ף����Ժ������ Ga, Gb Ӱ���С
global r0; 
r0 = 0.2;

% ��֪���ݣ�Ƥ������¶ȷֲ�
tgiven = xlsread('C:\Users\sunjin\Desktop\Advanced Topics in Applied Mathematics\CUMCM-2018-Problem-A-Chinese-Appendix.xlsx',2,'A3:A5403');
Tgiven = xlsread('C:\Users\sunjin\Desktop\Advanced Topics in Applied Mathematics\CUMCM-2018-Problem-A-Chinese-Appendix.xlsx',2,'B3:B5403');

% �ռ��ʱ����ɢ�㣬 h �ǿռ䲽��
r1 = r0 + sum(d); h = 0.0001; nr = round((r1-r0)/h)+1;
r = linspace(r0,r0+sum(d),nr);
t = tgiven;

% Ƥ�������迹���� Ga������������������迹���� Gb
global Ga Gb;

% ��� Ga �� Gb���ҵ��Ĳ��� Ga = 8.5548, Gb = 115.6913
TaErr = @(G) norm(Tgiven-heatpdecoef(G(1),G(2),r,t))^2;
[G,Err] = fminsearch(TaErr,[8.5; 85]);

% ʹ����Ϻõ� Ga �� Gb ����ȴ�������
% Ga = 8.5548; Gb = 115.6913;
Ga = G(1); Gb = G(2);
sol = pdepe(1,@heatpde,@heatpdeic,@heatpdebc,r,t);
T = sol(:,:,1);

% �������
figure; surf(r,t,T,'EdgeColor','none');
xlabel('���� r'); ylabel('ʱ�� t'); zlabel('�¶� T');

% ���� r=a ����Ƥ����ࣩ��ʱ��Ĺ�ϵ���븽��2�Ƚ�
figure; plot(t,T(:,1),':','LineWidth',2);
xlabel('ʱ�� t���룩'); ylabel('Ƥ������¶� T'); grid on;
hold on; plot(tgiven,Tgiven,'--',LW,2);
hl = legend('ģ��Ԥ��','����2'); set(hl,'FontSize',18);
%figure; plot(tgiven,interp1(t,T(:,1),tgiven)-Tgiven);
%xlabel('ʱ�� t���룩'); ylabel('ģ���븽��2���'); grid on;
plot(tgiven,T(:,1)-Tgiven);
xlabel('ʱ�� t���룩'); ylabel('ģ���븽��2���'); grid on;



% �¶��ڿռ�ֲ���ʱ��仯�Ķ���
% figure; 
% for n = 1:1001
%     plot(r,T(n,:),LW,2); grid on; 
%     xlabel('���� r'); ylabel('�¶� T');
%     ylim([30,75]); pause(0.001);  
% end

% �����¶ȵ�ʱ�շֲ����� T �� csv �����ֹ����Ϊ .xlsx
%csvwrite('problem1.csv',T);
%% ���⣨2��

% ��֪�����趨
T1 = 65; d(4) = 0.001*5.5;
t = linspace(0,3600,3601);

% ��С����ֱ������
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

% �Ӵ�Сֱ������
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

%% ���⣨3��

% ��֪�����趨
% T1 = 80;
% t = linspace(0,1800,1801);

% ���� II ������СΪĿ������Ż�
% fun2 = @(d24) d24(1);
% d24 = patternsearch(fun2,[0.025;0.0064],[],[],[],[],[0.0006;0.0006],[0.025;0.0064],@(d24)nonlcon2(d24(1),d24(2),r0,t))

% ȡ��С II ���ȣ����� IV ������СΪĿ���Ż�
% fun3 = @(d4) d4;
% d4 = patternsearch(fun3,0.0064,[],[],[],[],0.0006,0.0064,@(d4)nonlcon2(d24(1),d4,r0,t))
plot(t,T)
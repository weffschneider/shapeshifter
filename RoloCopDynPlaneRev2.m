clc, close all
format long
beep off

P.r = 1;
P.m = 1;
P.sg = 9.81;

save('P', 'P');
clearvars

syms y ydot yddot z zdot zddot T Tdot Tddot sFn sFf real
load('P')
%% Constants

r = P.r;
m = P.m;
sg = P.sg;
f = y;
matlabFunction(f, 'Vars', y, 'File', 'Func');
fdot = diff(f, y)*ydot;
fddot = diff(fdot, ydot)*yddot + diff(fdot, y)*ydot;
N_Icm = eye(3,3);



%% Cordinates

N_n = [0, -diff(f, y), 1].'./sqrt(diff(f,y)^2 + 1); % normal

N_ndot = [0 0 0].'; % derivs
N_nddot = N_ndot;

N_lam = [0, 1, diff(f, y)].'./sqrt(diff(f,y)^2 + 1); % tangent
N_lamdot = [ 0 0 0].';

%% Vectors

N_rcm_o = [0 y z].'; % moving in y-z plane
N_vcm_o = [0 ydot zdot].';
N_acm_o = [0 yddot zddot].';

N_rc_cm = -r*N_n; % contact point to center
N_vc_cm = -r*N_ndot;
N_ac_cm = -r*N_nddot;

N_rc_o = N_rcm_o + N_rc_cm; % velocity of contact
N_vc_o = N_vcm_o + N_vc_cm;
N_ac_o = N_acm_o + N_ac_cm;

N_wB_N = [Tdot 0 0].'; % omega
N_aB_N = [Tddot 0 0].';


%% Forces

N_Fn = sFn*N_n; % normal force
N_Ff = sFf*N_lam; % tangent force

N_g = [0 0 -sg].'; % gravitational force

%% Angular Momentum Ballance

N_Ho = N_Icm*N_aB_N + cross(N_rcm_o, N_acm_o);
N_Tto = cross(N_rcm_o, m*N_g) + cross(N_rc_o, N_Fn) + cross(N_rc_o, N_Ff)-7; % array of torque about origin (not center of mass)

Eq1 = N_Ho(1) == N_Tto(1);

%% Linear Momentum Balance

N_Ft = m*N_g + N_Fn + N_Ff; % array of force
N_Lm = m*N_acm_o;

Eq2 = N_Ft(2) == N_Lm(2);
Eq3 = N_Ft(3) == N_Lm(3);

%% Constraints
% 


C1 = [0, yddot, fddot]*N_n - N_ac_o.'*N_n;

C2 =  -Tddot*r -  N_ac_o.'*N_lam + N_vc_o.'*N_lamdot;

Eq4 = C1 == 0;
Eq5 = C2 == 0;

%% Solve
Eq = [Eq1; Eq2; Eq3; Eq4; Eq5];
Sol = solve(Eq, [yddot zddot Tddot sFn sFf]);

%%
Sddot = [Sol.yddot; Sol.zddot; Sol.Tddot; Sol.sFn; Sol.sFf];
S = [y ydot z zdot T Tdot].';
matlabFunction(Sddot, 'Vars', {S}, 'File', 'SddotFunc');
matlabFunction(N_n, 'Vars', y, 'File', 'N_nFunc');
matlabFunction(N_lam, 'Vars', y, 'File', 'N_lamFunc');
Sfull = [S.', [yddot zddot Tddot]];
matlabFunction(C1, 'Vars', {Sfull}, 'File', 'C1Func');
matlabFunction(C2, 'Vars', {Sfull}, 'File', 'C2Func');


clear all, clc

%% Sim Check
close all
load('P')
r = P.r;
yco = 4;
N_no = N_nFunc(yco);
Po = [0, yco, Func(yco)].' + N_no*r;
yo = Po(2);
zo = Po(3);

To = 0;

ydoto = 0;
zdoto = 0;
Tdoto = 0;

So = [yo ydoto zo zdoto To Tdoto].';
t = [0:.01:10];
opt = odeset('RelTol', 10^-9, 'AbsTol', 10^-9, 'MaxStep', .0001);
[t, S] = ode45(@RoloCop2DDynFunc, t, So, opt);
sFn = zeros(length(t), 1);
sFf = zeros(length(t), 1);
C1 = sFf;
C2 = sFf;
N_n = zeros(3, length(t));
N_lam = N_n;

for i = 1:length(t)
   [Sdot_out, sFn(i), sFf(i), C1(i), C2(i)] = RoloCop2DDynFunc(t(i), S(i,:).');
   N_n(:,i) = N_nFunc(S(i,1));
   N_lam(:,i) =  N_lamFunc(S(i,1));
   Sdot_out_all(:,i) = Sdot_out;
   linear_acc(:,i) = sqrt(Sdot_out(2)^2+Sdot_out(4)^2);
   omega(:,i) = Sdot_out(5);
   alpha(:,i) = Sdot_out(end);
    
end

figure()
plot(S(:,1), S(:,3))
hold on
plot(linspace(-1.5*max(abs(S(:,1))), 1.5*max(abs(S(:,1))), 100), Func(linspace(-1.5*max(abs(S(:,1))), 1.5*max(abs(S(:,1))), 100)));
plot(S(1,1), S(1,3), 'o')
plot(S(end,1), S(end,3), '*')


for i = 1:10:length(N_n(1,:))
    plot([S(i,1), S(i,1)+N_n(2, i)],[S(i,3), S(i,3)+N_n(3, i)], 'Color', 'red')
    plot([S(i,1), S(i,1)+N_lam(2, i)],[S(i,3), S(i,3)+N_lam(3, i)], 'Color', 'blue')
end

axis([-20 20 -20 20])

% hold off

% figure()
% plot(t, sFn)
% title('normal force')
% 
% figure()
% plot(t, sFf)
% title('friction force')
% figure()
% plot(t, C1)
% title('First constraint violation')
% 
% 
% figure()
% plot(t, C2)
% title('Second constraint violation')
% 
figure()
plot(t, linear_acc)
title('Linear Acceleration')


figure()
plot(t, omega)
title('Angular Velocity')



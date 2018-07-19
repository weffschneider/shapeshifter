clc, clear all, close all
format long
beep off

P.r = .1;
P.m = 1;
P.sg = 9.81;
P.N_Icm = eye(3,3);

save('P', 'P')

clearvars
syms x xdot xddot y ydot yddot z zdot zddot w1 w2 w3 w1dot w2dot w3dot sFn sFf1 sFf2 m sg real

%% Constants
load('P')
m = P.m;
r = P.r;
sg = P.sg;
N_Icm = P.N_Icm;

f = sin(.5*x^2 + .5*y^2);
matlabFunction(f, 'Vars', {x, y}, 'File', 'Func');
fdot = diff(f, y)*ydot + diff(f, x)*xdot;
fddot = diff(fdot, ydot)*yddot + diff(fdot, y)*ydot...
        + diff(fdot, xdot)*xddot + diff(fdot, x)*xdot;

%% Cordinates

N_n = [-diff(f, x), -diff(f, y), 1].'./sqrt(diff(f,x)^2 + diff(f,y)^2 + 1);

N_lam = null(N_n.');
N_lam1 = N_lam(:,1)/norm(N_lam(:,1));
N_lam2 = N_lam(:,2)/norm(N_lam(:,2));

% N_lam1 = [diff(f, x), diff(f, y), 1].'./sqrt(diff(f,x)^2 + diff(f,y)^2 + 1);
% N_lam2 = simplify(cross(N_lam1, N_n));

%% Vectors

N_rcm_o = [x y z].';
N_vcm_o = [xdot ydot zdot].';
N_acm_o = [xddot yddot zddot].';

N_rc_cm = -r*N_n;

N_rc_o = N_rcm_o + N_rc_cm;
N_vc_o = N_vcm_o;
N_ac_o = N_acm_o;

N_wB_N = [w1 w2 w3].';
N_aB_N = [w3dot w2dot w1dot].';


%% Forces

N_Fn = sFn*N_n;
N_Ff1 = sFf1*N_lam1;
N_Ff2 = sFf2*N_lam2;

N_g = [0 0 -sg].';

%% Angular Momentum Ballance

N_Ho = N_Icm*N_aB_N + cross(N_rcm_o, N_acm_o);
N_Tto = cross(N_rcm_o, m*N_g) + cross(N_rc_o, N_Fn) + cross(N_rc_o, N_Ff1) + cross(N_rc_o, N_Ff2);

Eq1 = N_Ho(1) == N_Tto(1);
Eq2 = N_Ho(2) == N_Tto(2);
Eq3 = N_Ho(3) == N_Tto(3);

%% Linear Momentum Balance

N_Ft = m*N_g + N_Fn + N_Ff1 + N_Ff2;
N_Lm = m*N_acm_o;

Eq4 = N_Ft(1) == N_Lm(1);
Eq5 = N_Ft(2) == N_Lm(2);
Eq6 = N_Ft(3) == N_Lm(3);

%% Constraints

C1 = [xddot, yddot, fddot]*N_n - N_ac_o.'*N_n;
C2 =  -cross(N_aB_N, N_rc_cm).'*N_lam1 -  N_ac_o.'*N_lam1;
C3 =  -cross(N_aB_N, N_rc_cm).'*N_lam2 -  N_ac_o.'*N_lam2;

Eq7 = C1 == 0;
Eq8 = C2 == 0;
Eq9 = C3 == 0;

%% Solve
Eq = [Eq1; Eq2; Eq3; Eq4; Eq5; Eq6; Eq7; Eq8; Eq9];
Sol = solve(Eq, [xddot yddot zddot w1dot w2dot w3dot sFn sFf1 sFf2]);

%%
Sddot = [Sol.xddot; Sol.yddot; Sol.zddot; Sol.w1dot; Sol.w2dot; Sol.w3dot; Sol.sFn; Sol.sFf1; Sol.sFf2];
S = [x y z xdot ydot zdot w1 w2 w3].';
matlabFunction(Sddot, 'Vars', {S}, 'File', 'SddotFunc');

Sfull = [x y z xdot ydot zdot w1 w2 w3 xddot yddot zddot w1dot w2dot w3dot].';

matlabFunction(C1, 'Vars', {Sfull}, 'File', 'C1Func');
matlabFunction(C2, 'Vars', {Sfull}, 'File', 'C2Func');
matlabFunction(C3, 'Vars', {Sfull}, 'File', 'C3Func');

matlabFunction(N_n, 'Vars', {x, y}, 'File', 'N_nFunc')
%%
clear all, clc

%% Sim Check
close all
load('P')
m = P.m;
r = P.r;
sg = P.sg;
N_Icm = P.N_Icm;


xco = .3;
yco = 1;
N_no = N_nFunc(xco, yco);
Po = [xco, yco, Func(xco, yco)].' + N_no*r;
xo = Po(1);
yo = Po(2);
zo = Po(3);


xdoto = 0;
ydoto = 0;
zdoto = 0;

w1o = 0;
w2o = 0;
w3o = 0;

So = [xo yo zo xdoto ydoto zdoto w1o w2o w3o].';
t = [0:1:1000];
opt = odeset('RelTol', 10^-9, 'AbsTol', 10^-9);
[t, S] = ode45(@RoloCopDynFunc, t, So, opt);

% sFn = zeros(length(t), 1);
% sFf = zeros(length(t), 1);
Sfull = zeros(length(t), 15);
C1 = zeros(length(t), 1);
C2 = zeros(length(t), 1);
C3 = zeros(length(t), 1);
N_n = zeros(3, length(t));
N_lam = N_n;
E = zeros(length(t), 1);
for i = 1:length(t)
   [~, Sfull(i,:), C1(i), C2(i), C3(i)] = RoloCopDynFunc(t(i), S(i,:).');
   N_n(:,i) = N_nFunc(S(i,1), S(i,2));
   E(i) = .5*m*S(i,[4:6])*S(i,[4:6]).' + .5*S(i,[7:9])*N_Icm*S(i,[7:9]).' + m*sg*S(i,3);
end

dE = E - repmat(E(1), length(E), 1);

figure()
plot3(S(:,1), S(:,2), S(:,3),'.', 'Color', 'red')
hold on
[x, y] = meshgrid(linspace(-5, 5, 100), linspace(-5, 5, 100));
z = Func(x, y);
surf(x, y, z)
plot3(S(1,1), S(1,2), S(1,3), 'o')
plot3(S(end,1), S(end, 2), S(end,3), '*')
xlabel('x'), ylabel('y'), zlabel('z')
hold off

figure()
plot(t, C1)

figure()
plot(t, C2)

figure()
plot(t, C3)

figure()
plot(t, dE)




% V = S(:, 4:6);
% w = S(:, 7:9);
% E = zeros(length(V(:,1)), 1);
% for i = 1:length(V(:,1))
%    E(i) = .5*m*V(i,:)*V(i,:).' + .5*1*w(i,:)*w(i,:).' + m*sg*S(i,3);
%     
% end
% plot(linspace(-1.5*max(abs(S(:,1))), 1.5*max(abs(S(:,1))), 100), Func(linspace(-1.5*max(abs(S(:,1))), 1.5*max(abs(S(:,1))), 100)));
% plot(S(1,1), S(1,3), 'o')
% plot(S(end,1), S(end,3), '*')
% 
% 
% for i = 1:10:length(N_n(1,:))
%     plot([S(i,1), S(i,1)+N_n(2, i)],[S(i,3), S(i,3)+N_n(3, i)], 'Color', 'red')
%     plot([S(i,1), S(i,1)+N_lam(2, i)],[S(i,3), S(i,3)+N_lam(3, i)], 'Color', 'blue')
% end
% 
% axis([-20 20 -20 20])
% 
% hold off
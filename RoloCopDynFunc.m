function [Sdot, Sfull, C1, C2, C3] = RoloCopDynFunc(t, S)
x = S(1);
y = S(2);
z = S(3);
xdot = S(4);
ydot = S(5);
zdot = S(6);
w1 = S(7);
w2 = S(8);
w3 = S(9);

S = [x y z xdot ydot zdot w1 w2 w3].';
Sddot = SddotFunc(S);

Sfull = [x y z xdot ydot zdot w1 w2 w3 Sddot(1) Sddot(2) Sddot(3) Sddot(4) Sddot(5) Sddot(6)].';

C1 = C1Func(Sfull);
C2 = C2Func(Sfull);
C3 = C3Func(Sfull);


Sdot = [xdot ydot zdot Sddot(1) Sddot(2) Sddot(3) Sddot(4) Sddot(5) Sddot(6)].';
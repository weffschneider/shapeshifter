function [Sdot, sFn, sFf, C1, C2] = RoloCop2DDynFunc(t, S)

Sddot = SddotFunc(S);
sFn = Sddot(4);
sFf = Sddot(5);
Sfull = [S.', Sddot(1:3).'];
C1 = C1Func(Sfull);
C2 = C2Func(Sfull);
% Sddot = SddotFunc([S(1) S(2) S(5) S(6)].');
% zddot = zddotFunc(S(1), S(2), Sddot(1));
Sdot = [S(2), Sddot(1), S(4), Sddot(2), S(6), Sddot(3)].';

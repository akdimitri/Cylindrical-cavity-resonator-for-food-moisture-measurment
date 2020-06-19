%% Compare 0 to 180
A = dlmread('S21_0 lepta fourno 3 koryfi.txt');
[db_A, idx_A] = max(A(:,2));
f_A = A(idx_A,1);


B = dlmread('S21_180 lepta fourno 2 koryfi.txt');
[db_B, idx_B] = max(B(:,2));
f_B = B(idx_B,1);

figure;
hold on;

plot(A(:,1),A(:,2));
plot(B(:,1),B(:,2));
plot(f_A, db_A, '*');
plot(f_B, db_B, '*');
text(f_A, db_A, '4.866 GHz - 55%');
text(f_B, db_B, '4.89 GHz - 10%');
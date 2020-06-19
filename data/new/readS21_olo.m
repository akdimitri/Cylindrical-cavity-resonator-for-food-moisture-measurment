function [freq, db, max_val, max_freq] = readS21_olo(filename)

max_val = zeros(4);
max_freq = zeros(4);

A = dlmread(filename);              % read freq and S21 of given data file
freq = A(:,1);
db = A(:,2);

% 1st max
left = 3.4*10^9;
right = 3.68*10^9;

indeces = (A(:,1) > left) & (A(:,1) < right);
N = nnz(indeces);
cnt = 1;
array_ut = zeros(N,2);
for i = 1:length(indeces)
    if (indeces(i) == 1)
        array_ut(cnt,1) = A(i,1);
        array_ut(cnt,2) = A(i,2);
        cnt = cnt + 1;
    end
end

[max_val(1), idx] = max(array_ut(:,2));
max_freq(1) = array_ut(idx,1);
fprintf("1st: freq= %.4f GHz\t%f db\n", max_freq(1)/10^9, max_val(1));

% 2nd max
left = 3.68*10^9;
right = 3.95*10^9;

indeces = (A(:,1) > left) & (A(:,1) < right);
N = nnz(indeces);
cnt = 1;
array_ut = zeros(N,2);
for i = 1:length(indeces)
    if (indeces(i) == 1)
        array_ut(cnt,1) = A(i,1);
        array_ut(cnt,2) = A(i,2);
        cnt = cnt + 1;
    end
end

[max_val(2), idx] = max(array_ut(:,2));
max_freq(2) = array_ut(idx,1);
fprintf("2nd: freq= %.4f GHz\t%f db\n", max_freq(2)/10^9, max_val(2));

% 3rd max
left = 3.95*10^9;
right = 4.54*10^9;

indeces = (A(:,1) > left) & (A(:,1) < right);
N = nnz(indeces);
cnt = 1;
array_ut = zeros(N,2);
for i = 1:length(indeces)
    if (indeces(i) == 1)
        array_ut(cnt,1) = A(i,1);
        array_ut(cnt,2) = A(i,2);
        cnt = cnt + 1;
    end
end

[max_val(3), idx] = max(array_ut(:,2));
max_freq(3) = array_ut(idx,1);
fprintf("3rd: freq= %.4f GHz\t%f db\n", max_freq(3)/10^9, max_val(3));

% 3rd max
left = 4.54*10^9;
right = 5.2*10^9;

indeces = (A(:,1) > left) & (A(:,1) < right);
N = nnz(indeces);
cnt = 1;
array_ut = zeros(N,2);
for i = 1:length(indeces)
    if (indeces(i) == 1)
        array_ut(cnt,1) = A(i,1);
        array_ut(cnt,2) = A(i,2);
        cnt = cnt + 1;
    end
end

[max_val(4), idx] = max(array_ut(:,2));
max_freq(4) = array_ut(idx,1);
fprintf("4th: freq= %.4f GHz\t%f db\n", max_freq(4)/10^9, max_val(4));

% figure();
% plot(A(:,1),A(:,2));
% xlabel('Frequency (Hz)');
% ylabel('S21 (db)');
% name_png = extractAfter(filename,"./S21_");
% name_png = extractBefore(name_png, " olo.txt");
% name_png = strcat(name_png,'.png');
% saveas(gcf,name_png);
%close all
end
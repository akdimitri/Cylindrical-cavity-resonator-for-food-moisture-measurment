function [db, f, BW] = readS21_kor(filename)

A = dlmread(filename);              % read freq and S21 of given data file

[db, idx] = max(A(:,2));
f = A(idx,1);

% Find BW
%Find first value <= 3b left
flag = 0;
cnt = idx;
while(~flag && cnt > 0)
    if(A(cnt,2) < db-3)
        left = A(cnt+1,1);
        flag = 1;            
    end
    cnt = cnt - 1;
end

%Find first value <= 3b right
flag = 0;
cnt = idx;
while(~flag && cnt < length(A(:,1)))
    if(A(cnt,2) < db-3)
        right = A(cnt-1,1);
        flag = 1;            
    end
    cnt = cnt + 1;
end

% Calculate Bandwidth
BW = right-left;
Q = f/BW;

fprintf("freq= %.4f GHz\t%f db BW = %f MHz Q =%f GHz/db \n ", f/10^9, db, BW/10^6, Q);
% figure();
% plot(A(:,1),A(:,2));
% xlabel('Frequency (Hz)');
% ylabel('S21 (db)');
%name_png = extractAfter(filename,"./S21_");
%name_png = extractBefore(name_png, " koryfi.txt");
%name_png = strcat(name_png,'.png');
%saveas(gcf,name_png);

end
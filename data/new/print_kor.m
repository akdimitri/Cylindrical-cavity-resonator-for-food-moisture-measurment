%% Clean up
clc;
clear;

%% Read data files
FID = fopen('./list_kor.txt');    % read list of data files

%%
cnt = 1;
while ~feof(FID)    % read till you reach the end of list file
    
    line = fgetl(FID);              % read line = get name of a data file
    fprintf("%s\n",line);
    [db, f, BW] = readS21_kor(line);
    cnt = cnt + 1;
    if (cnt == 4)
        cnt = 1;
        pause;
    end
end

fclose(FID);
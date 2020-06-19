%% Clean up
clc;
clear;

%% Read data files
FID = fopen('list_of_S21_data.txt');    % read list of data files

% Initialisations
data = {};          % cell array to hold the data
count = 1;
s_count = 1;

%%
while ~feof(FID)    % read till you reach the end of list file
    
    line = fgetl(FID);              % read line = get name of a data file
    A = dlmread(line);              % read freq and S21 of given data file
    
    [val, idx] = max(A(:,2));       % find maximum value of S21 and its corresponding index
    freq = A(idx,1);                % store frequency of max S21
    
    data{count,2}(s_count) = freq;      % store freq to cell array
    data{count,3}(s_count) = val;       % store val to cell array
    
    % Find BW
    %Find first value <= 3b left
    flag = 0;
    cnt = idx;
    while(~flag && cnt > 0)
        if(A(cnt,2) < val-3)
            left = A(cnt+1,1);
            flag = 1;            
        end
        cnt = cnt - 1;
    end
    
    %Find first value <= 3b right
    flag = 0;
    cnt = idx;
    while(~flag && cnt < length(A(:,1)))
        if(A(cnt,2) < val-3)
            right = A(cnt-1,1);
            flag = 1;            
        end
        cnt = cnt + 1;
    end
    
    % Calculate Bandwidth
    BW = right-left;
    data{count,6}(s_count) = BW;
    %Calculate Q
    data{count,7}(s_count) = freq/BW;
    
    fprintf("%s freq = %f S21 = %f\n", line, freq, val);
    
    if (s_count == 1)
       data{count,1} = extractAfter(line,"./S21_");
       data{count,1} = extractBefore(data{count,1}, " 1 koryfi.txt");       
    end
        
    s_count = s_count + 1;
    if (s_count == 4)
       s_count = 1; 
       count = count + 1;
    end
end

fclose(FID);
clear A count s_count val freq idx line FID;
%% Rearrange

data_new(1,:) = data(1,:);
data_new(2,:) = data(2,:);
data_new(3,:) = data(6,:);
data_new(4,:) = data(7,:);
data_new(5,:) = data(8,:);
data_new(6,:) = data(9,:);
data_new(7,:) = data(3,:);
data_new(8,:) = data(4,:);
data_new(9,:) = data(5,:);

clear data;
%% Plot

figure;
hold on;

mean_values = [];

for i = 1:length(data_new)   
    plot(i, data_new{i,2}(1), '+');
    plot(i, data_new{i,2}(2), '+');
    plot(i, data_new{i,2}(3), '+');   
    m = mean(data_new{i,2});
    q = mean(data_new{i,7});
    Qs_mean(i) = q;
    mean_values(i) = m;
end
xticklabels(data_new(:,1)');
xtickangle(90);
axis([0.9 9.1 4.865*10^9 4.895*10^9]);
title('Experiment Data')
xlabel('Time in oven (m)')
ylabel('Frequency (Hz)')

clear m;

figure;
plot(mean_values);
xticklabels(data_new(:,1)');
xtickangle(90);
ylim([4.865*10^9 4.895*10^9]);
title('Average Data')
xlabel('Time in oven (m)')
ylabel('Average Frequency (Hz)') 


%% Add weight
data_new{1,4} = 2;
data_new{2,4} = 1.6;
data_new{3,4} = 1.4;
data_new{4,4} = 1.3;
data_new{5,4} = 1.2;
data_new{6,4} = 1.1;
data_new{7,4} = 1;
data_new{8,4} = 0.7;
data_new{9,4} = 0.8;

%% Add humidity
md = 0.75;

for i = 1:length(data_new(:,4))
   data_new{i,5} = (data_new{i,4} - md)/(data_new{i,4});
end


%% plot weight time in oven
figure;
hold on;
y = []; 
for i = 1:length(data_new(:,4))
   y(i) = data_new{i,4};
end

x = [0 10 20 30 50 80 120 150 180];

plot(x, y, '-x');
title('Average Weight per nut after certain time period in Oven')
xlabel('Time in oven (m)')
ylabel('Average weight per nut (g)') 


%% Create Fit for ABS Freq and Time in Oven
[fitresult, gof] = createFit(x, mean_values);


%% Calculate DF DT X
% Read empty cavity features
A = dlmread('./S21_metrisi mono me vasi koryfi.txt');              % read freq and S21 of given data file
    
[max_S21_empty, idx] = max(A(:,2));       % find maximum value of S21 and its corresponding index
f0 = A(idx,1);                % store frequency of max S21


% Find BW
%Find first value <= 3b left
flag = 0;
cnt = idx;
while(~flag && cnt > 0)
    if(A(cnt,2) < max_S21_empty-3)
        left = A(cnt+1,1);
        flag = 1;            
    end
    cnt = cnt - 1;
end

%Find first value <= 3b right
flag = 0;
cnt = idx;
while(~flag && cnt < length(A(:,1)))
    if(A(cnt,2) < max_S21_empty-3)
        right = A(cnt-1,1);
        flag = 1;            
    end
    cnt = cnt + 1;
end

% Calculate Bandwidth
BW0 = right-left;

%Calculate Q
Q0 = f0/BW0;

% Calculate DF DT X
for i = 1:length(data_new(:,7))
    for j = 1:3
        DF(i,j) = abs(f0 - data_new{i,2}(j));
        DT(i,j) = Q0/data_new{i,7}(j) - 1;
        X(i,j) = DF(i,j)/DT(i,j);
    end
end

%plot DF
figure;
hold on;
for i = 1:length(DF(:,1))
    for k =1:3
       plot(i,DF(i,k),'O'); 
    end    
end
xticklabels(data_new(:,1)');
xtickangle(90);
xlabel('Time in oven (m)')
ylabel('Delta Frequency (Hz)') 

%plot DT
figure;
hold on;
for i = 1:length(DF(:,1))
    for k =1:3
       plot(i,DT(i,k),'O'); 
    end    
end
xticklabels(data_new(:,1)');
xtickangle(90);
xlabel('Time in oven (m)')
ylabel('Delta T') 

%plot X
figure;
hold on;
for i = 1:length(DF(:,1))
    for k =1:3
       plot(i,X(i,k),'O'); 
    end    
end
xticklabels(data_new(:,1)');
xtickangle(90);
xlabel('Time in oven (m)')
ylabel('Ratio X') 


% Calculate means for interpolation
for i = 1:length(DF(:,1))
    for k =1:3
       DF_mean(i) = mean(DF(i,:));
       DT_mean(i) = mean(DT(i,:));
       X_mean(i) = mean(X(i,:));
    end    
end

% plot Interpolations
figure;
plot(DF_mean);
xticklabels(data_new(:,1)');
xtickangle(90);
xlabel('Time in oven (m)')
ylabel('Delta Frequency Average (Hz)') 

figure;
plot(DT_mean);
xticklabels(data_new(:,1)');
xtickangle(90);
xlabel('Time in oven (m)')
ylabel('Delta T Average') 

figure;
plot(X_mean);
xticklabels(data_new(:,1)');
xtickangle(90);
xlabel('Time in oven (m)')
ylabel('X Average') 

% Create Fit DF and DT vs time in Oven
[fitresult, gof] = createFit1(x, DF_mean);
[fitresult, gof] = createFit2(x, DT_mean);

% Plot humidity
figure;
mean_humidity = abs(cell2mat(data_new(:,5)));
plot(x,mean_humidity)
xlabel('Time in oven (m)')
ylabel('Humidity %') 

% Humidity Freq
[fitresult, gof] = createFit3(mean_values, mean_humidity);


% Q
figure;
hold on;
for i = 1:length(data_new(:,7))   
    plot(i, data_new{i,7}(1), '+');
    plot(i, data_new{i,7}(2), '+');
    plot(i, data_new{i,7}(3), '+');      
end
xticklabels(data_new(:,1)');
xlim([0.9 9.1])
xtickangle(90);
title('Q')
xlabel('Time in oven (m)')
ylabel('Q = f/BW')










%%
%./S21_ergostasiako 1 koryfi.txt
%./S21_ergostasiako 2 koryfi.txt
%./S21_ergostasiako 3 koryfi.txt
%./S21_metrisi mono me vasi koryfi.txt
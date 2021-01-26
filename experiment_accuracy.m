%%%% Perform the accuracy experimentations

%%% DFTL v/s BE temp
%{
path_dftl = '/home/vedant/Downloads/FTL-project/plot_data/DFTL/'; 
path_be = '/home/vedant/Downloads/FTL-project/plot_data/CS_BE_temp_1/'; 

%h = figure;
total = 5;

str_dftl = strcat(path_dftl,['N_' num2str(100) '_TS_'  num2str(0.01)]);
str_be = strcat(path_be,['N_' num2str(100) '_TS_'  num2str(0.01)]);
frames = 5/0.01;

X_mat_dftl_1 = dlmread(strcat(str_dftl,'_x_1.txt'));
Y_mat_dftl_1 = dlmread(strcat(str_dftl,'_y_1.txt'));

X_mat_be_1 = dlmread(strcat(str_be,'_x_1.txt'));
Y_mat_be_1 = dlmread(strcat(str_be,'_y_1.txt'));

dist_array_1 = get_dist(X_mat_dftl_1, Y_mat_dftl_1, X_mat_be_1, Y_mat_be_1);
time_arr = linspace(0,5,frames);

%plot(time_arr, dist_array_1);
%hold on;

str_dftl = strcat(path_dftl,['N_' num2str(100) '_TS_'  num2str(0.005)]);
str_be = strcat(path_be,['N_' num2str(100) '_TS_'  num2str(0.005)]);
frames = 5/0.005;

X_mat_dftl_2 = dlmread(strcat(str_dftl,'_x_1.txt'));
Y_mat_dftl_2 = dlmread(strcat(str_dftl,'_y_1.txt'));

X_mat_be_2 = dlmread(strcat(str_be,'_x_1.txt'));
Y_mat_be_2 = dlmread(strcat(str_be,'_y_1.txt'));

dist_array_2 = get_dist(X_mat_dftl_2, Y_mat_dftl_2, X_mat_be_2, Y_mat_be_2);
time_arr = linspace(0,5,frames);

%plot(time_arr, dist_array_2);
%hold on;

str_dftl = strcat(path_dftl,['N_' num2str(100) '_TS_'  num2str(1e-5)]);
str_be = strcat(path_be,['N_' num2str(100) '_TS_'  num2str(1e-5)]);
frames = 5/(1e-5);

X_mat_dftl_3 = load(strcat(str_dftl,'_x_1.txt'));
Y_mat_dftl_3 = load(strcat(str_dftl,'_y_1.txt'));

X_mat_be_3 = load(strcat(str_be,'_x_1.txt'));
Y_mat_be_3 = load(strcat(str_be,'_y_1.txt'));

temp = 499;
dist_array_3 = [];
for i=1:temp
    i
    
    temp_x_dftl = X_mat_dftl_3(:,((i-1)*1000 + 1):(i*1000));
    temp_y_dftl = Y_mat_dftl_3(:,((i-1)*1000 + 1):(i*1000));
    temp_x_be = X_mat_be_3(:,((i-1)*1000 + 1):(i*1000));
    temp_y_be = Y_mat_be_3(:,((i-1)*1000 + 1):(i*1000));
    
    temp_array = get_dist(temp_x_dftl, temp_y_dftl, temp_x_be, temp_y_be);
    dist_array_3 = [dist_array_3 temp_array];
end

i = 500;
b = 499999;
temp_x_dftl = X_mat_dftl_3(:,((i-1)*1000 + 1):b);
temp_y_dftl = Y_mat_dftl_3(:,((i-1)*1000 + 1):b);
temp_x_be = X_mat_be_3(:,((i-1)*1000 + 1):b);
temp_y_be = Y_mat_be_3(:,((i-1)*1000 + 1):b);
    
temp_array = get_dist(temp_x_dftl, temp_y_dftl, temp_x_be, temp_y_be);
dist_array_3 = [dist_array_3 temp_array];


h= figure;
frames = 5/0.01;
time_arr = linspace(0,5,frames);
plot(time_arr, dist_array_1);
hold on;

frames = 5/0.005;
time_arr = linspace(0,5,frames);
plot(time_arr, dist_array_2);
hold on;

temp = 1;
frames = floor(b/temp);
time_arr = linspace(0,5,frames);

temp_dist_3 = zeros(1,frames);
for i=1:frames
%    temp_dist_3(i) = mean(dist_array_3((i-1)*temp+1:i*temp-1));
    temp_dist_3(i) = dist_array_3(i*temp );
   
end
plot(time_arr, temp_dist_3);

xlabel('Time (in sec)');
ylabel('Average distance (in m)');
title('Mean distance between DFTL and BE systems');
leg = legend('0.01s','0.005s', '0.00001s');
title(leg,'Time step (sec)');
ylim([0,0.7])

saveas(h,'/home/vedant/Downloads/FTL-project/results/CS_BE_temp/accuracy_dftl_orig.jpg');

function dist_array = get_dist(x_approx, y_approx, x_real, y_real)
    dist_matrix = sqrt((x_real - x_approx).^2 + (y_real - y_approx).^2);
    dist_array = mean(dist_matrix,1);
end
%}

%%% Required Accuracy comparisons
path_dftl = '/home/vedant/Downloads/FTL-project/plot_data/DFTL/'; 
path_mem = '/home/vedant/Downloads/FTL-project/plot_data/FTL_Mem/';
path_be = '/home/vedant/Downloads/FTL-project/plot_data/CS_BE_temp_1/'; 

h = figure;
total = 5;

str_be = strcat(path_be,['N_' num2str(100) '_TS_'  num2str(1e-5)]);
frames = 5/(1e-5);

%X_mat_be_3 = load(strcat(str_be,'_x_1.txt'));
%Y_mat_be_3 = load(strcat(str_be,'_y_1.txt'));

str_dftl = strcat(path_dftl,['N_' num2str(100) '_TS_'  num2str(0.01)]);
str_mem = strcat(path_mem,['N_' num2str(100) '_TS_'  num2str(0.01)]);
frames = 5/0.01;

X_mat_dftl_1 = dlmread(strcat(str_dftl,'_x.txt'));
Y_mat_dftl_1 = dlmread(strcat(str_dftl,'_y.txt'));

X_mat_mem_1 = dlmread(strcat(str_mem,'_x.txt'));
Y_mat_mem_1 = dlmread(strcat(str_mem,'_y.txt'));

X_mat_be_1 = X_mat_be_3(:,1:1000:500000);
Y_mat_be_1 = Y_mat_be_3(:,1:1000:500000);

dist_array_dftl_1 = get_dist(X_mat_dftl_1, Y_mat_dftl_1, X_mat_be_1, Y_mat_be_1);
time_arr = linspace(0,5,frames);

plot(time_arr, dist_array_dftl_1);
hold on;

dist_array_mem_1 = get_dist(X_mat_mem_1, Y_mat_mem_1, X_mat_be_1, Y_mat_be_1);
plot(time_arr, dist_array_mem_1);

xlabel('Time (in sec)');
ylabel('Average distance (in m)');
title('Mean distance between the systems');
leg = legend('DFTL','FTL Mem');
title(leg,'Time step = 0.01s');
ylim([0,0.9])

saveas(h,'/home/vedant/Downloads/FTL-project/results/CS_BE_temp_1/accuracy_0.01.jpg');

%{
h = figure;
str_dftl = strcat(path_dftl,['N_' num2str(100) '_TS_'  num2str(0.0025)]);
str_mem = strcat(path_mem,['N_' num2str(100) '_TS_'  num2str(0.0025)]);
frames = 5/0.0025;

X_mat_dftl_1 = dlmread(strcat(str_dftl,'_x.txt'));
Y_mat_dftl_1 = dlmread(strcat(str_dftl,'_y.txt'));

X_mat_mem_1 = dlmread(strcat(str_mem,'_x.txt'));
Y_mat_mem_1 = dlmread(strcat(str_mem,'_y.txt'));

X_mat_be_1 = X_mat_be_3(:,1:250:500000);
Y_mat_be_1 = Y_mat_be_3(:,1:250:500000);

dist_array_dftl_1 = get_dist(X_mat_dftl_1, Y_mat_dftl_1, X_mat_be_1, Y_mat_be_1);
time_arr = linspace(0,5,frames);

plot(time_arr, dist_array_dftl_1);
hold on;

dist_array_mem_1 = get_dist(X_mat_mem_1, Y_mat_mem_1, X_mat_be_1, Y_mat_be_1);
plot(time_arr, dist_array_mem_1);

xlabel('Time (in sec)');
ylabel('Average distance (in m)');
title('Mean distance between the systems');
leg = legend('DFTL','FTL Mem');
title(leg,'Time step = 0.0025s');
ylim([0,0.9])

saveas(h,'/home/vedant/Downloads/FTL-project/results/CS_BE_temp_1/accuracy_0.0025.jpg');

%}
function dist_array = get_dist(x_approx, y_approx, x_real, y_real)
    dist_matrix = sqrt((x_real - x_approx).^2 + (y_real - y_approx).^2);
    dist_array = mean(dist_matrix,1);
end

%%% Comparison between DFTL and FTL Mem at very low time step. Using BE
%{
path_dftl = '/home/vedant/Downloads/FTL-project/plot_data/DFTL/'; 
path_mem = '/home/vedant/Downloads/FTL-project/plot_data/FTL_Mem/'; 
path_be = '/home/vedant/Downloads/FTL-project/plot_data/CS_BE_temp_1/'; 

total = 5;
frames = 5/(1e-5);

str_dftl = strcat(path_dftl,['N_' num2str(100) '_TS_'  num2str(1e-5)]);
str_be = strcat(path_be,['N_' num2str(100) '_TS_'  num2str(1e-5)]);
str_mem = strcat(path_mem,['N_' num2str(100) '_TS_'  num2str(1e-5)]);

X_mat_dftl_3 = load(strcat(str_dftl,'_x_1.txt'));
Y_mat_dftl_3 = load(strcat(str_dftl,'_y_1.txt'));

X_mat_be_3 = load(strcat(str_be,'_x_1.txt'));
Y_mat_be_3 = load(strcat(str_be,'_y_1.txt'));

X_mat_mem_3 = load(strcat(str_mem,'_x_1.txt'));
Y_mat_mem_3 = load(strcat(str_mem,'_y_1.txt'));

%%% Doing for DFTL first
temp = 499;
dist_array_3 = [];
for i=1:temp
    i
    
    temp_x_dftl = X_mat_dftl_3(:,((i-1)*1000 + 1):(i*1000));
    temp_y_dftl = Y_mat_dftl_3(:,((i-1)*1000 + 1):(i*1000));
    temp_x_be = X_mat_be_3(:,((i-1)*1000 + 1):(i*1000));
    temp_y_be = Y_mat_be_3(:,((i-1)*1000 + 1):(i*1000));
    
    temp_array = get_dist(temp_x_dftl, temp_y_dftl, temp_x_be, temp_y_be);
    dist_array_3 = [dist_array_3 temp_array];
end

i = 500;
b = 499999;
temp_x_dftl = X_mat_dftl_3(:,((i-1)*1000 + 1):b);
temp_y_dftl = Y_mat_dftl_3(:,((i-1)*1000 + 1):b);
temp_x_be = X_mat_be_3(:,((i-1)*1000 + 1):b);
temp_y_be = Y_mat_be_3(:,((i-1)*1000 + 1):b);
    
temp_array = get_dist(temp_x_dftl, temp_y_dftl, temp_x_be, temp_y_be);
dist_array_3 = [dist_array_3 temp_array];

%%% Doing for FTL Mem now
temp = 499;
dist_array_4 = [];
for i=1:temp
    i
    
    temp_x_mem = X_mat_mem_3(:,((i-1)*1000 + 1):(i*1000));
    temp_y_mem = Y_mat_mem_3(:,((i-1)*1000 + 1):(i*1000));
    temp_x_be = X_mat_be_3(:,((i-1)*1000 + 1):(i*1000));
    temp_y_be = Y_mat_be_3(:,((i-1)*1000 + 1):(i*1000));
    
    temp_array = get_dist(temp_x_mem, temp_y_mem, temp_x_be, temp_y_be);
    dist_array_4 = [dist_array_4 temp_array];
end

i = 500;
b = 499999;
temp_x_mem = X_mat_mem_3(:,((i-1)*1000 + 1):b);
temp_y_mem = Y_mat_mem_3(:,((i-1)*1000 + 1):b);
temp_x_be = X_mat_be_3(:,((i-1)*1000 + 1):b);
temp_y_be = Y_mat_be_3(:,((i-1)*1000 + 1):b);
    
temp_array = get_dist(temp_x_mem, temp_y_mem, temp_x_be, temp_y_be);
dist_array_4 = [dist_array_4 temp_array];


function dist_array = get_dist(x_approx, y_approx, x_real, y_real)
    dist_matrix = sqrt((x_real - x_approx).^2 + (y_real - y_approx).^2);
    dist_array = mean(dist_matrix,1);
end
%}

%{
h = figure;
time_arr = linspace(0,5,frames);

plot(time_arr, dist_array_3);
hold on;

plot(time_arr, dist_array_4);

xlabel('Time (in sec)');
ylabel('Average distance (in m)');
title('Mean distance between the systems');
leg = legend('DFTL','FTL Mem');
title(leg,'Time step = 0.00001s');
ylim([0,0.9])

saveas(h,'/home/vedant/Downloads/FTL-project/results/CS_BE_temp_1/accuracy_base_comp.jpg');
%}
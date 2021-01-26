%%%% Perform the Energy experimentations and obtain the results

%%% Improper velocity update/Energyp plots for the DFTL particles
%{
path = '/home/vedant/Downloads/FTL-project/plot_data/DFTL/'; 
h = figure;
total = 5;

str = strcat(path,['N_' num2str(100) '_TS_'  num2str(0.01)]);
frames = 5/0.01;

VelX_mat = dlmread(strcat(str,'_vx_temp.txt'));
VelY_mat = dlmread(strcat(str,'_vy_temp.txt'));
X_mat = dlmread(strcat(str,'_x.txt'));
Y_mat = dlmread(strcat(str,'_y.txt'));

time_arr = linspace(0,5,frames);

speed = sqrt(VelX_mat.^2 + VelY_mat.^2);
speed_arr = mean(speed,1);

% Calculating the kinetic energy
ke_i = 1/2 * m * (VelX_mat.^2 + VelY_mat.^2);
ke_t = sum(ke_i);

% Calculating the potential energy
pe_i = m * g * Y_mat;
pe_t = sum(pe_i);

% Calculating the total energy
energy_arr = pe_t + ke_t;

%plot(time_arr, speed_arr);
plot(time_arr, energy_arr);
hold on;

str = strcat(path,['N_' num2str(100) '_TS_'  num2str(0.005)]);
frames = 5/0.005;

VelX_mat = dlmread(strcat(str,'_vx_temp.txt'));
VelY_mat = dlmread(strcat(str,'_vy_temp.txt'));
X_mat = dlmread(strcat(str,'_x.txt'));
Y_mat = dlmread(strcat(str,'_y.txt'));

time_arr = linspace(0,5,frames);

speed = sqrt(VelX_mat.^2 + VelY_mat.^2);
speed_arr = mean(speed,1);

% Calculating the kinetic energy
ke_i = 1/2 * m * (VelX_mat.^2 + VelY_mat.^2);
ke_t = sum(ke_i);

% Calculating the potential energy
pe_i = m * g * Y_mat;
pe_t = sum(pe_i);

% Calculating the total energy
energy_arr = pe_t + ke_t;

%plot(time_arr, speed_arr);
plot(time_arr, energy_arr);
hold on;

str = strcat(path,['N_' num2str(100) '_TS_'  num2str(0.0025)]);
frames = 5/0.0025;

VelX_mat = dlmread(strcat(str,'_vx_temp.txt'));
VelY_mat = dlmread(strcat(str,'_vy_temp.txt'));
X_mat = dlmread(strcat(str,'_x.txt'));
Y_mat = dlmread(strcat(str,'_y.txt'));

time_arr = linspace(0,5,frames);

speed = sqrt(VelX_mat.^2 + VelY_mat.^2);
speed_arr = mean(speed,1);

% Calculating the kinetic energy
ke_i = 1/2 * m * (VelX_mat.^2 + VelY_mat.^2);
ke_t = sum(ke_i);

% Calculating the potential energy
pe_i = m * g * Y_mat;
pe_t = sum(pe_i);

% Calculating the total energy
energy_arr = pe_t + ke_t;

%plot(time_arr, speed_arr);
plot(time_arr, energy_arr);

xlabel('Time (in sec)');
ylabel('Energy (in J)');
title('Total System Energy v/s time');
leg = legend('0.01','0.005','0.0025');
title(leg,'Time step (sec)');
%ylim([0,2.3]);

saveas(h,'/home/vedant/Downloads/FTL-project/results/DFTL/energies_0.9_corrected.jpg');
%}

%%% Velocity convergence for DFTL
path = '/home/vedant/Downloads/FTL-project/plot_data/DFTL/'; 
h = figure;
%total = 5;

str = strcat(path,['N_' num2str(100) '_TS_'  num2str(1e-5)]);
frames = 5/1e-5;
m = 1.0/100;
g = 9.81;

VelX_mat = load(strcat(str,'_vx_temp_1.txt'));
VelY_mat = load(strcat(str,'_vy_temp_1.txt'));

time_arr = linspace(0,5,frames);

temp = 499;
speed_array_3 = [];
for i=1:temp
    i
    
    temp_x = VelX_mat(:,((i-1)*1000 + 1):(i*1000));
    temp_y = VelY_mat(:,((i-1)*1000 + 1):(i*1000));
    
    speed = sqrt(temp_x.^2 + temp_y.^2);
    speed_arr = mean(speed,1);
    speed_array_3 = [speed_array_3 speed_arr];
end

i = 500;
b = 499999;
temp_x = VelX_mat(:,((i-1)*1000 + 1):b);
temp_y = VelY_mat(:,((i-1)*1000 + 1):b);
    
speed = sqrt(temp_x.^2 + temp_y.^2);
speed_arr = mean(speed,1);
speed_array_3 = [speed_array_3 speed_arr];

plot(time_arr, speed_array_3);
hold on;

path = '/home/vedant/Downloads/FTL-project/plot_data/DFTL/'; 
%total = 5;

str = strcat(path,['N_' num2str(100) '_TS_'  num2str(1e-5)]);
frames = 5/1e-5;
m = 1.0/100;
g = 9.81;

VelX_mat = load(strcat(str,'_vx_1.txt'));
VelY_mat = load(strcat(str,'_vy_1.txt'));

time_arr = linspace(0,5,frames);

temp = 499;
speed_array_3 = [];
for i=1:temp
    i
    
    temp_x = VelX_mat(:,((i-1)*1000 + 1):(i*1000));
    temp_y = VelY_mat(:,((i-1)*1000 + 1):(i*1000));
    
    speed = sqrt(temp_x.^2 + temp_y.^2);
    speed_arr = mean(speed,1);
    speed_array_3 = [speed_array_3 speed_arr];
end

i = 500;
b = 499999;
temp_x = VelX_mat(:,((i-1)*1000 + 1):b);
temp_y = VelY_mat(:,((i-1)*1000 + 1):b);
    
speed = sqrt(temp_x.^2 + temp_y.^2);
speed_arr = mean(speed,1);
speed_array_3 = [speed_array_3 speed_arr];

plot(time_arr, speed_array_3);

xlabel('Time (in sec)');
ylabel('Speed (in m/s)');
title('Average particle speed v/s time');
leg = legend('Velocities updated','Velocities original');
%title(leg,'Time step (sec)');
%ylim([-6,8]);

saveas(h,'/home/vedant/Downloads/FTL-project/results/DFTL/vel_1_1e-5.jpg');

%%% Comparision of the DFTL energies
%{
path = '/home/vedant/Downloads/FTL-project/plot_data/FTL_Mem_1/'; 
h = figure;
%total = 5;

str = strcat(path,['N_' num2str(100) '_TS_'  num2str(0.005)]);
frames = 5/0.005;
m = 1.0/100;
g = 9.81;

VelX_mat = dlmread(strcat(str,'_vx_1.txt'));
VelY_mat = dlmread(strcat(str,'_vy_1.txt'));
X_mat = dlmread(strcat(str,'_x_1.txt'));
Y_mat = dlmread(strcat(str,'_y_1.txt'));

time_arr = linspace(0,5,frames);

% Calculating the kinetic energy
ke_i = 1/2 * m * (VelX_mat.^2 + VelY_mat.^2);
ke_t = sum(ke_i);

% Calculating the potential energy
pe_i = m * g * Y_mat;
pe_t = sum(pe_i);

% Calculating the total energy
energy_arr = pe_t + ke_t;

plot(time_arr, energy_arr);
hold on;

path = '/home/vedant/Downloads/FTL-project/plot_data/DFTL/'; 
%total = 5;

str = strcat(path,['N_' num2str(100) '_TS_'  num2str(0.0025)]);
frames = 5/0.0025;
m = 1.0/100;
g = 9.81;

VelX_mat = dlmread(strcat(str,'_vx_temp_1.txt'));
VelY_mat = dlmread(strcat(str,'_vy_temp_1.txt'));
X_mat = dlmread(strcat(str,'_x_1.txt'));
Y_mat = dlmread(strcat(str,'_y_1.txt'));

time_arr = linspace(0,5,frames);

% Calculating the kinetic energy
ke_i = 1/2 * m * (VelX_mat.^2 + VelY_mat.^2);
ke_t = sum(ke_i);

% Calculating the potential energy
pe_i = m * g * Y_mat;
pe_t = sum(pe_i);

% Calculating the total energy
energy_arr = pe_t + ke_t;

plot(time_arr, energy_arr);

xlabel('Time (in sec)');
ylabel('Energy (in J)');
title('Total system energy v/s time');
leg = legend('DFTL Updated','FTL Mem');
%title(leg,'Time step (sec)');
%ylim([-6,75]);

%saveas(h,'/home/vedant/Downloads/FTL-project/results/DFTL/energy_updated_comp_0.01.jpg');
%}

%%% Screenshot of simulation
%{
path = '/home/vedant/Downloads/FTL-project/plot_data/DFTL/'; 
h = figure;

str = strcat(path,['N_' num2str(100) '_TS_'  num2str(0.01)]);
X_mat = dlmread(strcat(str,'_x.txt'));
Y_mat = dlmread(strcat(str,'_y.txt'));

temp = 55;
    for i = 1 : 99
           X1 = X_mat(i,temp);
           X2 = X_mat(i+1,temp);
           Y1 = Y_mat(i,temp);
           Y2 = Y_mat(i+1,temp); 

           plot([X1,X2],[Y1,Y2],'r.');
           plot([X1,X2],[Y1,Y2],'r');
           
           hold on;
    end
    
path = '/home/vedant/Downloads/FTL-project/plot_data/FTL_Mem/'; 

str = strcat(path,['N_' num2str(100) '_TS_'  num2str(0.01)]);
X_mat = dlmread(strcat(str,'_x.txt'));
Y_mat = dlmread(strcat(str,'_y.txt'));
temp = 55;
    for i = 1 : 99
           X1 = X_mat(i,temp);
           X2 = X_mat(i+1,temp);
           Y1 = Y_mat(i,temp);
           Y2 = Y_mat(i+1,temp); 

           plot([X1,X2],[Y1,Y2],'b.');
           plot([X1,X2],[Y1,Y2],'b');
           hold on;
    end
    
path = '/home/vedant/Downloads/FTL-project/plot_data/DFTL/'; 
    
str = strcat(path,['N_' num2str(100) '_TS_'  num2str(0.01)]);
X_mat = dlmread(strcat(str,'_x.txt'));
Y_mat = dlmread(strcat(str,'_y.txt'));

temp = 100;
    for i = 1 : 99
           X1 = X_mat(i,temp);
           X2 = X_mat(i+1,temp);
           Y1 = Y_mat(i,temp);
           Y2 = Y_mat(i+1,temp); 

           plot([X1,X2],[Y1,Y2],'r*','MarkerSize',4);
           plot([X1,X2],[Y1,Y2],'r');
           
           hold on;
    end
    
path = '/home/vedant/Downloads/FTL-project/plot_data/FTL_Mem/'; 

str = strcat(path,['N_' num2str(100) '_TS_'  num2str(0.01)]);
X_mat = dlmread(strcat(str,'_x.txt'));
Y_mat = dlmread(strcat(str,'_y.txt'));
temp = 100;
    for i = 1 : 99
           X1 = X_mat(i,temp);
           X2 = X_mat(i+1,temp);
           Y1 = Y_mat(i,temp);
           Y2 = Y_mat(i+1,temp); 

           plot([X1,X2],[Y1,Y2],'b*','MarkerSize',4);
           plot([X1,X2],[Y1,Y2],'b');
           hold on;
    end
    
xlim([-1,1]);
ylim([-1,0]);
h = gcf;
h.PaperUnits = 'inches';
h.PaperPosition = [0 0 8 4];
set(gca,'xtick',[])
set(gca,'ytick',[])
axis off;
saveas(h,'/home/vedant/Downloads/FTL-project/results/FTL_Mem/simulation_100_0.01.jpg');
%}

%%% DFTL Energies for very low time step
%{
path = '/home/vedant/Downloads/FTL-project/plot_data/DFTL/'; 

m = 1.0/100;
g = 9.81;
str = strcat(path,['N_' num2str(100) '_TS_'  num2str(1e-5)]);
frames = 5/(1e-5);

%X_mat = load(strcat(str,'_x_1.txt'));
%Y_mat = load(strcat(str,'_y_1.txt'));
%VelX_mat = load(strcat(str,'_vx_temp_1.txt'));
%VelY_mat = load(strcat(str,'_vy_temp_1.txt'));

time_arr = linspace(0,5,frames);

% Calculating the kinetic energy
ke_i = 1/2 * m * (VelX_mat.^2 + VelY_mat.^2);
ke_t = sum(ke_i);

% Calculating the potential energy
pe_i = m * g * Y_mat;
pe_t = sum(pe_i);

% Calculating the total energy
energy_arr_dftl = pe_t + ke_t;

%%% FTL Mem energies for very low time step
path = '/home/vedant/Downloads/FTL-project/plot_data/FTL_Mem/'; 

str = strcat(path,['N_' num2str(100) '_TS_'  num2str(1e-5)]);
frames = 5/(1e-5);

X_mat = load(strcat(str,'_x_1.txt'));
Y_mat = load(strcat(str,'_y_1.txt'));
VelX_mat = load(strcat(str,'_vx_1.txt'));
VelY_mat = load(strcat(str,'_vy_1.txt'));

time_arr = linspace(0,5,frames);

% Calculating the kinetic energy
ke_i = 1/2 * m * (VelX_mat.^2 + VelY_mat.^2);
ke_t = sum(ke_i);

% Calculating the potential energy
pe_i = m * g * Y_mat;
pe_t = sum(pe_i);

% Calculating the total energy
energy_arr_mem = pe_t + ke_t;

%%% Plotting both of them at once
h = figure;
plot(time_arr, energy_arr_dftl);
hold on;
plot(time_arr, energy_arr_mem);
leg = legend('DFTL','FTL Mem');
xlabel('Time (in sec)');
ylabel('Energy (in J)');
title('Total system energy v/s time');
saveas(h,'/home/vedant/Downloads/FTL-project/results/FTL_Mem/energy_gt_approx.jpg');
%}
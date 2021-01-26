%%% Path to the methods
path_dftl = '/home/vedant/Downloads/FTL-project/plot_data/DFTL/'; 
path_mem = '/home/vedant/Downloads/FTL-project/plot_data/FTL_Mem/';
path_be = '/home/vedant/Downloads/FTL-project/plot_data/CS_BE_temp_1/'; 
path_save = '/home/vedant/Downloads/FTL-project/Images_Exp/';

% The values of basic parameters
time_step = 0.0025;
n = 100;
total = 5;
total_frames = 250;
display_rate = ((total/time_step)/total_frames);
rate_for_be = floor((total/1e-5)/total_frames);

str_dftl = strcat(path_dftl,['N_' num2str(n) '_TS_'  num2str(time_step)]);
str_mem = strcat(path_mem,['N_' num2str(n) '_TS_'  num2str(time_step)]);
str_be = strcat(path_be,['N_' num2str(n) '_TS_'  num2str(1e-5)]);
str_save = strcat(path_save,['N_' num2str(n) '_TS_'  num2str(time_step)]);

% DFTL matrices for s=0.9
X_mat_dftl = dlmread(strcat(str_dftl,'_x.txt'));
Y_mat_dftl = dlmread(strcat(str_dftl,'_y.txt'));

% DFTL matrices for s=1.0
X_mat_dftl_1 = dlmread(strcat(str_dftl,'_x_1.txt'));
Y_mat_dftl_1 = dlmread(strcat(str_dftl,'_y_1.txt'));

% Mem matrices for s=0.9
X_mat_mem = dlmread(strcat(str_mem,'_x.txt'));
Y_mat_mem = dlmread(strcat(str_mem,'_y.txt'));

% Mem matrices for s=1.0
X_mat_mem_1 = dlmread(strcat(str_mem,'_x_1.txt'));
Y_mat_mem_1 = dlmread(strcat(str_mem,'_y_1.txt'));

% BE matrices 
X_mat_be = load(strcat(str_be,'_x_1.txt'));
Y_mat_be = load(strcat(str_be,'_y_1.txt'));

% Indices for the methods 
i_dftl = 1;
i_mem = 1;
i_be = 1;

% Color pattern:
% DFTl with s=1 => Blue (b)
% DFTL with s=0.9 => Green (g)
% Mem with s=1 => Red (r)
% Mem with s=0.9 => Magenta (m)
% BE => Black (k)

% Making images one-by-one
for t = 1:total_frames
    
    %%%% Doing for DFTL
    % Plotting DFTL images with s=1
    for i= 1 : (n-1)
           X1 = X_mat_dftl_1(i,i_dftl);
           X2 = X_mat_dftl_1(i+1,i_dftl);
           Y1 = Y_mat_dftl_1(i,i_dftl);
           Y2 = Y_mat_dftl_1(i+1,i_dftl); 

           plot([X1,X2],[Y1,Y2],'b.');
           plot([X1,X2],[Y1,Y2],'b');
           hold on;        
    end
    
    % Plotting DFTL images with s=0.9
    for i= 1 : (n-1)
           X1 = X_mat_dftl(i,i_dftl);
           X2 = X_mat_dftl(i+1,i_dftl);
           Y1 = Y_mat_dftl(i,i_dftl);
           Y2 = Y_mat_dftl(i+1,i_dftl); 

           plot([X1,X2],[Y1,Y2],'g.');
           plot([X1,X2],[Y1,Y2],'g');
           hold on;        
    end
    
    % Updating the counter for DFTL
    i_dftl = i_dftl + display_rate;
    
    %%%% Doing for FTL Mem
    % Plotting Mem images with s=1
    for i= 1 : (n-1)
           X1 = X_mat_mem_1(i,i_mem);
           X2 = X_mat_mem_1(i+1,i_mem);
           Y1 = Y_mat_mem_1(i,i_mem);
           Y2 = Y_mat_mem_1(i+1,i_mem); 

           plot([X1,X2],[Y1,Y2],'r.');
           plot([X1,X2],[Y1,Y2],'r');
           hold on;        
    end
    
    % Plotting Mem images with s=0.9
    for i= 1 : (n-1)
           X1 = X_mat_mem(i,i_mem);
           X2 = X_mat_mem(i+1,i_mem);
           Y1 = Y_mat_mem(i,i_mem);
           Y2 = Y_mat_mem(i+1,i_mem); 

           plot([X1,X2],[Y1,Y2],'m.');
           plot([X1,X2],[Y1,Y2],'m');
           hold on;        
    end
    
    % Updating the counter for Mem
    i_mem = i_mem + display_rate;
    
    %%%% Doing for BE
    % Plotting Backward Euler images
    for i= 1 : (n-1)
           X1 = X_mat_be(i,i_be);
           X2 = X_mat_be(i+1,i_be);
           Y1 = Y_mat_be(i,i_be);
           Y2 = Y_mat_be(i+1,i_be); 

           plot([X1,X2],[Y1,Y2],'k.');
           plot([X1,X2],[Y1,Y2],'k');
           hold on;        
    end
    
    % Updating the counter for Mem
    i_be = i_be +rate_for_be;
    
    %%%% Plotting the images
    xlim([-1,1]);
    ylim([-1,0.2]);
    h = gcf;
    h.PaperUnits = 'inches';
    h.PaperPosition = [0 0 10 6];
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    axis off;
    
     if t < 10
            s_temp = strcat(str_save,'/test-00');
            s = strcat(s_temp,int2str(t));
     elseif t < 100  
            s_temp = strcat(str_save,'/test-0');
            s = strcat(s_temp,int2str(t));
     else   
            s_temp = strcat(str_save,'/test-');
            s = strcat(s_temp,int2str(t));
     end
     
     t
     saveas(h,s,'jpg');
     close(h);
     
end
%%% Path to the methods
path_dftl = '/home/vedant/Downloads/FTL-project/plot_data/DFTL/'; 
path_be = '/home/vedant/Downloads/FTL-project/plot_data/CS_BE_temp_1/'; 
path_save = '/home/vedant/Downloads/FTL-project/Images_Exp/';

% The values of basic parameters
time_step = 1e-5;
n = 100;
total = 5;
total_frames = 250;
rate_for_be = floor((total/1e-5)/total_frames);

str_dftl = strcat(path_dftl,['N_' num2str(n) '_TS_'  num2str(time_step)]);
str_be = strcat(path_be,['N_' num2str(n) '_TS_'  num2str(1e-5)]);
str_save = strcat(path_save,'DFTL_BE');

% DFTL matrices for s=1.0
X_mat_dftl = load(strcat(str_dftl,'_x_1.txt'));
Y_mat_dftl = load(strcat(str_dftl,'_y_1.txt'));

% DFTL matrices for s=1.0
X_mat_be = load(strcat(str_be,'_x_1.txt'));
Y_mat_be = load(strcat(str_be,'_y_1.txt'));

% Indices for the methods 
i_be = 1;

% Color pattern:
% DFTl with s=1 => Blue (b)
% BE => Black (k)

% Making images one-by-one
for t = 1:total_frames
    
    %%%% Doing for DFTL
    % Plotting DFTL images with s=1
    for i= 1 : (n-1)
           X1 = X_mat_dftl(i,i_be);
           X2 = X_mat_dftl(i+1,i_be);
           Y1 = Y_mat_dftl(i,i_be);
           Y2 = Y_mat_dftl(i+1,i_be); 

           plot([X1,X2],[Y1,Y2],'b.');
           plot([X1,X2],[Y1,Y2],'b');
           hold on;        
    end
            
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


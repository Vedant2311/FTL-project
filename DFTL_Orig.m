%The space is going to be 2D

size = input('Enter the total number of particles: ');
delta_time = input('Enter your delta T: ');
total = input('Enter the entire duration of the animation: ');

% The Damping included 
s_damp = 0.9;

totalTimeFrames = floor(total/delta_time);

X_mat = zeros(size,totalTimeFrames);
Y_mat = zeros(size,totalTimeFrames);

Eplot_X = {};
Eplot_Y = {};

Energy_New = 0;
Energy_Gravity = 0;

DeltaX_vect = zeros(size+1);
DeltaY_vect = zeros(size+1);

VelX_mat = zeros(size,totalTimeFrames);
VelY_mat = zeros(size,totalTimeFrames);

VelX_mat1 = zeros(size,totalTimeFrames);
VelY_mat1 = zeros(size,totalTimeFrames);

VelX_mat2 = zeros(size,totalTimeFrames);
VelY_mat2 = zeros(size,totalTimeFrames);

% Initializing the positions


g = 9.81;   %Acceleration due to gravity, modified to fit the ideal assumption
m = 1.0/size;       %Mass of the particles

r = 1.0/(size-1);      %Initial length between the particles

for i=1:size
           
    X_mat(i,1) = (i-1)*r;
    Y_mat(i,1) = 0;
    
end 


for t= 2:totalTimeFrames
   
    Energy_New = 0;
    
    X_mat(1,t) = X_mat(1,1);
    Y_mat(1,t) = Y_mat(1,1);
    
    VelX_mat(1,t) = 0;
    VelY_mat(1,t) = 0;
    
    % Implemented the PBD 
    for i = 2 : size
                
        X_mat(i,t) = X_mat(i,t-1) + delta_time*(VelX_mat(i,t-1));
        Y_mat(i,t) = Y_mat(i,t-1) + delta_time*(VelY_mat(i,t-1))  + (delta_time * delta_time) * (-g);
        
    end
    
    % Doing the FTL correction
    for i=2: size
       
        Xn = X_mat(i-1,t);
        Yn = Y_mat(i-1,t);
        
        Xn1 = X_mat(i,t);
        Yn1 = Y_mat(i,t);
      
        rel_vec = [(Xn1-Xn),(Yn1-Yn)];
        normVal = norm(rel_vec);
        rel_vec = rel_vec * r/normVal;

        X_mat(i,t) = Xn + rel_vec(1);
        Y_mat(i,t)= Yn + rel_vec(2);
        
        DeltaX_vect(i) = X_mat(i,t) - Xn1;
        DeltaY_vect(i) = Y_mat(i,t) - Yn1;
        
        Energy_New = Energy_New + m * g * Y_mat(i,t);

    end
    
    Energy_Gravity = Energy_New;
    % Doing the Velocity Correction as mentioned in the paper
    for i=2: size
        
        VelX_mat(i,t) = (X_mat(i,t) - X_mat(i,t-1))/(delta_time) - (s_damp) * (DeltaX_vect(i+1))/(delta_time);
        VelY_mat(i,t) = (Y_mat(i,t) - Y_mat(i,t-1))/(delta_time) - (s_damp) * (DeltaY_vect(i+1))/(delta_time);
        
        VelX_mat2(i,t) = (X_mat(i,t) - X_mat(i,t-1))/(delta_time);
        VelY_mat2(i,t) = (Y_mat(i,t) - Y_mat(i,t-1))/(delta_time);
        
        temp = ((dot([VelX_mat2(i,t) VelY_mat2(i,t)],[DeltaX_vect(i+1) DeltaY_vect(i+1)]))/(norm([VelX_mat2(i,t) VelY_mat2(i,t)]) ^2));
        
        VelX_mat1(i,t) = VelX_mat2(i,t) - (s_damp/delta_time) * temp * VelX_mat2(i,t);
        VelY_mat1(i,t) = VelY_mat2(i,t) - (s_damp/delta_time) * temp * VelY_mat2(i,t);
        
        Energy_New = Energy_New + (1/2) * m * ((VelX_mat2(i,t))^2 + (VelY_mat2(i,t))^2);
        
    end
    Eplot_Y = {[cell2mat(Eplot_Y),Energy_New]};
    Eplot_X = {[cell2mat(Eplot_X),(t/totalTimeFrames)*total]};
    
    
end

%%% Saving all the matrixes here
path = '/home/vedant/Downloads/FTL-project/plot_data/DFTL/'; 
str = strcat(path,['N_' num2str(size) '_TS_'  num2str(delta_time)]);

dlmwrite(strcat(str,'_vx.txt'),VelX_mat);
dlmwrite(strcat(str,'_vy.txt'),VelY_mat);
dlmwrite(strcat(str,'_x.txt'),X_mat);
dlmwrite(strcat(str,'_y.txt'),Y_mat);

dlmwrite(strcat(str,'_vx_temp.txt'),VelX_mat2);
dlmwrite(strcat(str,'_vy_temp.txt'),VelY_mat2);

figure,plot(cell2mat(Eplot_X),cell2mat(Eplot_Y));


count = 1;

% The value for time step differences is 5 to time step=0.01, so that
% we get 100 images in a frame

% Storing the Sampled Images for making the Animation
%{
for t = 1: 10: totalTimeFrames
    
    h = figure('visible','off');
    
    for i = 1 : size-1
       
       X1 = X_mat(i,t);
       X2 = X_mat(i+1,t);
       Y1 = Y_mat(i,t);
       Y2 = Y_mat(i+1,t); 
       
       plot([X1,X2],[Y1,Y2],'k');
       hold on;
       
       plot (X1,Y1,'r*');
       hold on;
    end
    
      plot(X_mat(size,t),Y_mat(size,t),'r*');
      
     % The final location can be anything you want
     if count < 10  
%      s = strcat('C:\Users\Lenovo\Downloads\FTL project\Images_DFTL_Orig\test-00',int2str(count));
       s = strcat('/home/vedant/Downloads/FTL-project/Images_DFTL_Orig/test-00',int2str(count));
     elseif count < 100  
%       s = strcat('C:\Users\Lenovo\Downloads\FTL project\Images_DFTL_Orig\test-0',int2str(count));      
       s = strcat('/home/vedant/Downloads/FTL-project/Images_DFTL_Orig/test-0',int2str(count));

     else   
%         s = strcat('C:\Users\Lenovo\Downloads\FTL project\Images_DFTL_Orig\test-',int2str(count));        
       s = strcat('/home/vedant/Downloads/FTL-project/Images_DFTL_Orig/test-',int2str(count));

     end
      
       xlim([-r*(size-1) r*(size-1)]);
       ylim ([-(r * (size-1)) (r*(size-1))/10]);    
       
      saveas(h,s,'jpg');
      close(h);
      
      count = count + 1;
end
%}

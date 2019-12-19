%The space is going to be 2D

size = input('Enter the total number of particles: ');
delta_time = input('Enter your delta T: ');
total = input('Enter the entire duration of the animation: ');

% The Damping included 
s_damp = 1;

totalTimeFrames = floor(total/delta_time);

X_mat = zeros(size,totalTimeFrames);
Y_mat = zeros(size,totalTimeFrames);

DeltaX_vect = zeros(size+1);
DeltaY_vect = zeros(size+1);

VelX_mat = zeros(size,totalTimeFrames);
VelY_mat = zeros(size,totalTimeFrames);

% Initializing the positions

for i=1:size
           
    X_mat(i,1) = i-1;
    Y_mat(i,1) = 0;
    
end 

g = 9.81;   %Acceleration due to gravity, modified to fit the ideal assumption
m =1;       %Mass of the particles

r = 1;      %Initial length between the particles

for t= 2:totalTimeFrames
   
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
      
        % The position correction steps
        q = Xn + ((r*(Xn1-Xn))/(sqrt((Xn1 - Xn)^2 + (Yn1 - Yn)^2)));
        
        Xn2 = q;
        Yn2 = Yn + (((Yn1 - Yn)/(Xn1 - Xn))*(q - Xn));
        
        if (((Yn2 - Yn1)^2 + (Xn2 - Xn1)^2)>((Xn - Xn1)^2 + (Yn - Yn1)^2))
            q = -q;
        end 
        
        % Storing the correct positions
        X_mat(i,t) = q;
        Y_mat(i,t)= Yn + (((Yn1 - Yn)/(Xn1 - Xn))*(q - Xn));
        
        DeltaX_vect(i) = X_mat(i,t) - Xn1;
        DeltaY_vect(i) = Y_mat(i,t) - Yn1;
        
        
    end
    
    % Doing the Velocity Correction as mentioned in the paper
    for i=2: size
        
        VelX_mat(i,t) = (X_mat(i,t) - X_mat(i,t-1))/(delta_time) - (s_damp) * (DeltaX_vect(i+1))/(delta_time);
        VelY_mat(i,t) = (Y_mat(i,t) - Y_mat(i,t-1))/(delta_time) - (s_damp) * (DeltaY_vect(i+1))/(delta_time);
        
    end
    
    
end


count = 1;

% Storing the Sampled Images for making the Animation
for t = 1: 500: totalTimeFrames
    
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
      s = strcat('C:\Users\Lenovo\Downloads\FTL-project-master\Images_DFTL_Orig\test-00',int2str(count));
     elseif count < 100  
       s = strcat('C:\Users\Lenovo\Downloads\FTL-project-master\Images_DFTL_Orig\test-0',int2str(count));      
     else   
         s = strcat('C:\Users\Lenovo\Downloads\FTL-project-master\Images_DFTL_Orig\test-',int2str(count));        
     end
      
       xlim([-11 11]);
       ylim ([-11 1]);    
       
      saveas(h,s,'jpg');
      close(h);
      
      count = count + 1;
end



        


%The space is going to be 2D

size = input('Enter the total number of particles: ');
delta_time = input('Enter your delta T: ');
total = input('Enter the entire duration of the animation: ');

totalTimeFrames = floor(total/delta_time);

X_mat = zeros(size,totalTimeFrames);
Y_mat = zeros(size,totalTimeFrames);
VelX_mat = zeros(size,totalTimeFrames);
VelY_mat = zeros(size,totalTimeFrames);

r = 1/(size-1);      %Initial length
m = 1/(size);       %Mass of the particles

%Initializing the positions

for i=1:size
           
    X_mat(i,1) = (i-1)*r;
    Y_mat(i,1) = 0;
    
end 

g = 9.81;   %Acceleration due to gravity, modified to fit the ideal assumption

k_s = 1000.0;   % The spring force constant

k_d = 5.0;    %The damping constant

force_X = zeros(size,totalTimeFrames);    %Storing the instantaneous X force
force_Y = zeros(size,totalTimeFrames);    %Storing the instantaneous Y force


for i = 1 : size-1

    spring(i) = struct('x',i,'y',i+1);
    
end


for i=2:size

    force_Y(i,1) = -m*g;
    
end

force_Y(1,1) = 0;

% The Mass Tensor
M = zeros(2*size, 2*size);

for i=1:2*size

    for j=1:2*size
    
        if i==j
        
            M(i,j) = m;
        end
    
    end

end

% dF/dV
Dfv = zeros(2*size, 2*size);

% dF/dX
Dfx = zeros(2*size, 2*size);

A = zeros(2*size, 2* size);
B = zeros(2*size,1);

% Initial Force and Velocity Vectors
F0 = zeros(2*size,1);
V0 = zeros(2*size,1);

dV = zeros(2*size,1);

% The X and Y Jacobians
Jx = zeros(2,2);
Jv = zeros(2,2);

Delta_x = zeros(2,1);

for t= 2:totalTimeFrames
    
    for i=1: 2 : 2*size-1
       
        F0(i,1) = force_X(((i+1)/2),(t-1));
        F0(i+1,1) = force_Y(((i+1)/2),(t-1));
        
        V0(i,1) = VelX_mat(((i+1)/2),(t-1));
        V0(i+1,1) = VelY_mat(((i+1)/2),(t-1));
        
    end
    
    % Forces and Jacobians
    for i=1:size-1
    
        Delta_x(1,1) = X_mat(i,t-1) - X_mat(i+1,t-1);
        Delta_x(2,1) = Y_mat(i,t-1) - Y_mat(i+1,t-1);
        
        Jv = eye(2) * k_d;
        Jx = k_s * (((Delta_x * Delta_x.')/(Delta_x.' * Delta_x)) + ((eye(2) - ((Delta_x * Delta_x.')/(Delta_x.' * Delta_x))) * (1 - (r/(norm(Delta_x))))));
        
        Dfx([(2*i-1) (2*i)],[(2*(i+1)-1) (2*(i+1))]) = Dfx([(2*i-1) (2*i)],[(2*(i+1)-1) (2*(i+1))]) + Jx;
        Dfx([(2*(i+1)-1) (2*(i+1))],[(2*(i)-1) (2*(i))]) = Dfx([(2*(i+1)-1) (2*(i+1))],[(2*(i)-1) (2*(i))]) + Jx;
        
        Dfx([(2*i-1) (2*i)],[(2*(i)-1) (2*(i))]) = Dfx([(2*i-1) (2*i)],[(2*(i)-1) (2*(i))]) - Jx;
        Dfx([(2*(i+1)-1) (2*(i+1))],[(2*(i+1)-1) (2*(i+1))]) = Dfx([(2*(i+1)-1) (2*(i+1))],[(2*(i+1)-1) (2*(i+1))]) - Jx;
        
        
        
        Dfv([(2*i-1) (2*i)],[(2*(i+1)-1) (2*(i+1))]) = Dfv([(2*i-1) (2*i)],[(2*(i+1)-1) (2*(i+1))]) + Jv;
        Dfv([(2*(i+1)-1) (2*(i+1))],[(2*(i)-1) (2*(i))]) = Dfv([(2*(i+1)-1) (2*(i+1))],[(2*(i)-1) (2*(i))]) + Jv;
        
        Dfv([(2*i-1) (2*i)],[(2*(i)-1) (2*(i))]) = Dfv([(2*i-1) (2*i)],[(2*(i)-1) (2*(i))]) - Jv;
        Dfv([(2*(i+1)-1) (2*(i+1))],[(2*(i+1)-1) (2*(i+1))]) = Dfv([(2*(i+1)-1) (2*(i+1))],[(2*(i+1)-1) (2*(i+1))]) - Jv;
        
        
    end
    
    A = M - ((delta_time)*(Dfv)) - ((delta_time * delta_time)*(Dfx));
    B = (delta_time)*(F0 + ((delta_time)*(Dfx)*(V0)));
    
    % Obtaining the Change in Velocity 
    dV = A\B;
        
    % Doing the Backward Euler Time Step
    for i=2:size
            
            force_X(i,t) = 0;
            force_Y(i,t) = -m * g;
         
            VelX_mat(i,t) = V0(2*i-1,1) + dV(2*i-1,1);
            VelY_mat(i,t) = V0(2*i,1) + dV(2*i,1);
            
            X_mat(i,t) = X_mat(i,t-1) + (VelX_mat(i,t))*(delta_time);
            Y_mat(i,t) = Y_mat(i,t-1) + (VelY_mat(i,t))*(delta_time);
            
            
    end
      
    % Obtaining the Forces at this time "t" now 
    % By considering all the different Springs
    for spr = 1: size-1
        
        P = spring(spr).x;
        Q = spring(spr).y;
        
        X_diff = abs(X_mat(P,t) - X_mat(Q,t));
        Y_diff = abs(Y_mat(P,t) - Y_mat(Q,t));
        
        len = sqrt(X_diff*X_diff + Y_diff * Y_diff);
        
        F_P_x1 = (k_s) * (1- (r/len))* ((X_mat(Q,t)-X_mat(P,t)));
        F_P_y1 = (k_s) * (1- (r/len))* ((Y_mat(Q,t)-Y_mat(P,t)));
        
        
        F_P_x2 = (k_d) * (VelX_mat(Q,t) - VelX_mat(P,t));
        F_P_y2 = (k_d) * (VelY_mat(Q,t) - VelY_mat(P,t));
        
        F_P_x = F_P_x1 + F_P_x2;
        F_P_y = F_P_y1 + F_P_y2;
        
        F_Q_x = - F_P_x;
        F_Q_y = - F_P_y;
        
        force_X(P,t) = force_X(P,t) + F_P_x;
        force_Y(P,t) = force_Y(P,t) + F_P_y;
        force_X(Q,t) = force_X(Q,t) + F_Q_x;        
        force_Y(Q,t) = force_Y(Q,t) + F_Q_y;        
        
        
    end
        
    X_mat(1,t) = X_mat(1,1);
    Y_mat(1,t) = Y_mat(1,1);
    
    VelX_mat(1,t) = 0;
    VelY_mat(1,t) = 0;
    
    force_X(1,t) = 0;
    force_Y(1,t) = 0;
    
    
    for i=1:2*size
            
        for j=1:2*size
                
             Dfx(i,j) = 0;
             Dfv(i,j) = 0;
        end
                        
    end
        
end


%%% Saving all the matrixes here
path = '/home/vedant/Downloads/FTL-project/plot_data/BE/'; 
str = strcat(path,['N_' num2str(size) '_TS_'  num2str(delta_time)]);

dlmwrite(strcat(str,'_vx_1.txt'),VelX_mat);
dlmwrite(strcat(str,'_vy_1.txt'),VelY_mat);
dlmwrite(strcat(str,'_x_1.txt'),X_mat);
dlmwrite(strcat(str,'_y_1.txt'),Y_mat);

count = 1;

% Sampling the Images for the Animation
for t = 1: 5000: totalTimeFrames
    
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
      
     % The final Location can be anything you want
     if count < 10  
%         s = strcat('C:\Users\Lenovo\Downloads\FTL-project-master\Images_BE\test-00',int2str(count));
          s = strcat('/home/vedant/Downloads/FTL-project/Images_BE/test-00',int2str(count));

     elseif count < 100  
%         s = strcat('C:\Users\Lenovo\Downloads\FTL-project-master\Images_BE\test-0',int2str(count));      
          s = strcat('/home/vedant/Downloads/FTL-project/Images_BE/test-0',int2str(count));
         
     else   
%         s = strcat('C:\Users\Lenovo\Downloads\FTL-project-master\Images_BE\test-',int2str(count));        
          s = strcat('/home/vedant/Downloads/FTL-project/Images_BE/test-',int2str(count));         
     end
      
       xlim([-r*(size-1) r*(size-1)]);
       ylim ([-(r * (size-1)) (r*(size-1))/10]);    
       
      saveas(h,s,'jpg');
      close(h);
      
      count = count + 1;
end


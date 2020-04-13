%The space is going to be 2D

size = input('Enter the total number of particles: ');
delta_time = input('Enter your delta T: ');
total = input('Enter the entire duration of the animation: ');

totalTimeFrames = floor(total/delta_time);

X_mat = zeros(size,totalTimeFrames);
Y_mat = zeros(size,totalTimeFrames);
VelX_mat = zeros(size,totalTimeFrames);
VelY_mat = zeros(size,totalTimeFrames);


%Initializing the positions

for i=1:size
           
    X_mat(i,1) = i-1;
    Y_mat(i,1) = 0;
    
end 

g = 9.81;   %Acceleration due to gravity, modified to fit the ideal assumption
m =1;       %Mass of the particles

k_s = 1000.0;   % The spring constant


r = 1;      %Initial length

k_d = 5;    %damping constant

force_X = zeros(size,totalTimeFrames);    %Storing the instantaneous X force
force_Y = zeros(size,totalTimeFrames);    %Storing the instantaneous Y force



for i = 1 : size-1

    spring(i) = struct('x',i,'y',i+1);
    
end


for i=2:size

    force_Y(i,1) = -m*g;
    
end

force_Y(1,1) = 0;

% The mass Tensor
M = zeros(2*size, 2*size);

for i=1:2*size

    for j=1:2*size
    
        if i==j
        
            M(i,j) = m;
        end
    
    end

end

% dF/dV vector
Dfv = zeros(2*size, 2*size);

% dF/dX vector
Dfx = zeros(2*size, 2*size);

A = zeros(2*size, 2* size);
B = zeros(2*size,1);

F0 = zeros(2*size,1);
V0 = zeros(2*size,1);

% The Jacobians
Jx = zeros(2,2);
Jv = zeros(2,2);

Delta_x = zeros(2,1);
Delta_x_old = zeros(2,1);


Kn = zeros(2*size, 2*size);
Cn = zeros(2*size, 2*size);

% The constraint Vector
cons_n = zeros(size -1, 1);

% Jacobian and it's transpose 
Jtn = zeros(2*size, size-1);
Jn = zeros(size-1 , 2*size);

lambda = zeros(size-1, 1);

Dx = zeros(2*size,1);

Zero_mat = zeros(size-1, size-1);

% The three matrices used for the Final Calculations of the BE with
% constrained Dynamics
LHS_mat = zeros(3*size -1, 3*size -1);
RHS_mat = zeros(3*size -1 , 1);

Result_mat = zeros(3*size - 1,1);

for t= 2:totalTimeFrames
  
    % Calculating F0 and V0
    for i=1: 2 : 2*size-1
       
        F0(i,1) = force_X(((i+1)/2),(t-1));
        F0(i+1,1) = force_Y(((i+1)/2),(t-1));
        
        V0(i,1) = VelX_mat(((i+1)/2),(t-1));
        V0(i+1,1) = VelY_mat(((i+1)/2),(t-1));
        
        
    end
    
    % Jacobians and Forces
    for i=1:size-1
    
        Delta_x(1,1) = X_mat(i,t-1) - X_mat(i+1,t-1);
        Delta_x(2,1) = Y_mat(i,t-1) - Y_mat(i+1,t-1);
        
        % Initializing the Constraint Vector
        cons_n(i,1) = (Delta_x(1,1))^2 + (Delta_x(2,1))^2 - r^2;
        
        if (i==1) 
            
            Jtn([1 2],1) = 2* Delta_x;
            
        else
            
            Jtn([(2*i-1) (2*i)],i) = 2 * Delta_x;
            
            Delta_x_old(1,1) = X_mat(i-1,t-1) - X_mat(i,t-1);
            Delta_x_old(2,1) = Y_mat(i-1,t-1) - Y_mat(i,t-1);
            
            Jtn([(2*i-1) (2*i)], i-1) = -2 * Delta_x_old;
            
        end
        
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
    
    % Applying the BE and the Constraint Satisfaction
    Kn = -Dfx;
    Cn = -Dfv;
        
    Jn = Jtn.';
        
    A = Kn + ((Cn)/(delta_time)) + ((M)/(delta_time^2));
    B = (M*V0)/(delta_time) + F0 + (Cn * V0);
        
    LHS_mat = [A Jtn; Jn Zero_mat];
    RHS_mat = [B; -cons_n];
        
    Result_mat = LHS_mat\RHS_mat;
        
    % The final Assignment for the Change in position for all the particles
    Dx = Result_mat(1:2*size);
        
     % Applying the BE time step
     for i=2:size
            
            force_X(i,t) = 0;
            force_Y(i,t) = -m * g;
         
            VelX_mat(i,t) = Dx(2*i-1,1)/delta_time;
            VelY_mat(i,t) = Dx(2*i,1)/delta_time;
            
            X_mat(i,t) = X_mat(i,t-1) + Dx(2*i-1,1);
            Y_mat(i,t) = Y_mat(i,t-1) + Dx(2*i,1);
            
            
     end
       
     % Calculating the Forces for the nth time for all the springs
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
        
        for i=1:2*size
            
            for j=1:2*size
                
                Dfx(i,j) = 0;
                Dfv(i,j) = 0;
            end
                        
        end
        
end

count = 1;

% Sampling the Images for the Animation
for t = 1: 100: totalTimeFrames
    
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
      s = strcat('C:\Users\Lenovo\Downloads\FTL-project-master\Images_CS_BE\test-00',int2str(count));
     elseif count < 100  
       s = strcat('C:\Users\Lenovo\Downloads\FTL-project-master\Images_CS_BE\test-0',int2str(count));      
     else   
         s = strcat('C:\Users\Lenovo\Downloads\FTL-project-master\Images_CS_BE\test-',int2str(count));        
     end
      
       xlim([-11 11]);
       ylim ([-11 1]);    
       
      saveas(h,s,'jpg');
      close(h);
      
      count = count + 1;
end

%The space is going to be 2D

size = input('Enter the total number of particles: ');
delta_time = input('Enter your delta T: ');
total = input('Enter the entire duration of the animation: ');

totalTimeFrames = floor(total/delta_time);

X_mat = zeros(size,totalTimeFrames);
Y_mat = zeros(size,totalTimeFrames);

VelX_mat = zeros(size,totalTimeFrames);
VelY_mat = zeros(size,totalTimeFrames);

% Initializing the positions

for i=1:size
           
    X_mat(i,1) = i-1;
    Y_mat(i,1) = 0;
    
end 

g = 9.81;   %Acceleration due to gravity, modified to fit the ideal assumption
m =1;       %Mass of the particles

k_s = 1700.0;   %The spring force constant


r = 1;      %Initial length

k_d = 20;   % The damping constant

force_X = zeros(size,totalTimeFrames);    %Storing the instantaneous X force
force_Y = zeros(size,totalTimeFrames);    %Storing the instantaneous Y force


for i = 1 : size-1

    spring(i) = struct('x',i,'y',i+1);
    
end


for i=2:size

    force_Y(i,1) = -m*g;
    
end

force_Y(1,1) = 0;

for t= 2:totalTimeFrames
   
    X_mat(1,t) = X_mat(1,1);
    Y_mat(1,t) = Y_mat(1,1);
    
    VelX_mat(1,t) = 0;
    VelY_mat(1,t) = 0;

    
    % Applying the Symplectic Euler Time step
    for i = 2 : size
        
        force_X(i,t) = 0;
        force_Y(i,t) = -m * g;
        
        VelX_mat(i,t) = VelX_mat(i,t-1) + (delta_time/m)*(force_X(i,t-1));
        VelY_mat(i,t) = VelY_mat(i,t-1) + (delta_time/m)*(force_Y(i,t-1));
        
        X_mat(i,t) = X_mat(i,t-1) + delta_time*(VelX_mat(i,t));
        Y_mat(i,t) = Y_mat(i,t-1) + delta_time*(VelY_mat(i,t));

        
    end
    
    % Adding the Spring Forces
    for spr = 1: size-1
        
        P = spring(spr).x;
        Q = spring(spr).y;
        
        X_diff = abs(X_mat(P,t) - X_mat(Q,t));
        Y_diff = abs(Y_mat(P,t) - Y_mat(Q,t));
        
        len = sqrt(X_diff*X_diff + Y_diff * Y_diff);
        
        % Corresponding to the k*x force
        F_P_x1 = (k_s * (((len)/r)-1))* ((X_mat(Q,t)-X_mat(P,t))/len);
        F_P_y1 = (k_s * (((len)/r)-1))* ((Y_mat(Q,t)-Y_mat(P,t))/len);
        
        % Corresponding to the Damping force
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
    
    force_X(1,t) = 0;
    force_Y(1,t) = 0;
      
    % Applying the Follow the Leader Correction
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
        
        % Storing the Correct Positions
        X_mat(i,t) = q;
        Y_mat(i,t)= Yn + (((Yn1 - Yn)/(Xn1 - Xn))*(q - Xn));
        
        % Applying the Velocity Correction steps
        % For the Velocities to be normal to the length
        m_vec = [(X_mat(i,t) - X_mat(i-1,t));(Y_mat(i,t) - Y_mat(i-1,t))];
        v_vec = [VelX_mat(i,t); VelY_mat(i,t)];
        
        Vf_vec = v_vec - (dot(m_vec, v_vec))*(m_vec)/(norm(m_vec));
        
        VelX_mat(i,t) =    Vf_vec(1);
        VelY_mat(i,t) =   Vf_vec(2);
        
    end
    
end

count = 1;

% Storing selected Images for the Animation video to be processed
for t = 1: 400: totalTimeFrames
    
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
      
     % The final Locations can be as you want them to be
     if count < 10  
      s = strcat('C:\Users\Lenovo\Downloads\FTL-project-master\Images_FTL_SE\test-00',int2str(count));
     elseif count < 100  
       s = strcat('C:\Users\Lenovo\Downloads\FTL-project-master\Images_FTL_SE\test-0',int2str(count));      
     else   
         s = strcat('C:\Users\Lenovo\Downloads\FTL-project-master\Images_FTL_SE\test-',int2str(count));        
     end
      
       xlim([-11 11]);
       ylim ([-11 1]);    
       
      saveas(h,s,'jpg');
      close(h);
      
      count = count + 1;
end



        


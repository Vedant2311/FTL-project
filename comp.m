%The space is going to be 2D

size = input('Enter the total number of particles: ');
delta_time = input('Enter your delta T: ');
total = input('Enter the entire duration of the animation: ');

% The Damping included 
s_damp = 0.8;
s_damp1 = 0.8;

totalTimeFrames = floor(total/delta_time);

X_mat = zeros(size,totalTimeFrames);
Y_mat = zeros(size,totalTimeFrames);

X_mat1 = zeros(size,totalTimeFrames);
Y_mat1 = zeros(size,totalTimeFrames);

Eplot_X = {};
Eplot_Y = {};

Energy_New = 0;
Energy_Gravity = 0;

DeltaX_vect = zeros(size+1);
DeltaY_vect = zeros(size+1);

DeltaX_vect1 = zeros(size+1);
DeltaY_vect1 = zeros(size+1);

VelX_mat = zeros(size,totalTimeFrames);
VelY_mat = zeros(size,totalTimeFrames);

VelX_mat1 = zeros(size,totalTimeFrames);
VelY_mat1 = zeros(size,totalTimeFrames);

% Initializing the positions
g = 9.81;   %Acceleration due to gravity, modified to fit the ideal assumption
m =0.05;       %Mass of the particles

r = 0.05;      %Initial length between the particles

for i=1:size
           
    X_mat(i,1) = (i-1)*r;
    Y_mat(i,1) = 0;
    
    X_mat1(i,1) = X_mat(i,1);
    Y_mat1(i,1) = Y_mat(i,1);
    
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

        X_mat1(i,t) = X_mat1(i,t-1) + delta_time*(VelX_mat1(i,t-1));
        Y_mat1(i,t) = Y_mat1(i,t-1) + delta_time*(VelY_mat1(i,t-1))  + (delta_time * delta_time) * (-g);

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

        %%%%%%%%%%%%%%%%
        
        Xn_1 = X_mat1(i-1,t);
        Yn_1 = Y_mat1(i-1,t);
        
        Xn1_1 = X_mat1(i,t);
        Yn1_1 = Y_mat1(i,t);
      
        rel_vec = [(Xn1_1-Xn_1),(Yn1_1-Yn_1)];
        normVal = norm(rel_vec);
        rel_vec = rel_vec * r/normVal;

        X_mat1(i,t) = Xn_1 + rel_vec(1);
        Y_mat1(i,t)= Yn_1 + rel_vec(2);

        DeltaX_vect1(i) = X_mat1(i,t) - Xn1_1;
        DeltaY_vect1(i) = Y_mat1(i,t) - Yn1_1;
        
        Energy_New = Energy_New + m * g * Y_mat(i,t);

    end
    
    Energy_Gravity = Energy_New;
    % Doing the Velocity Correction as mentioned in the paper
    for i=2: size
        
        VelX_mat(i,t) = (X_mat(i,t) - X_mat(i,t-1))/(delta_time) - (s_damp) * (DeltaX_vect(i+1))/(delta_time);
        VelY_mat(i,t) = (Y_mat(i,t) - Y_mat(i,t-1))/(delta_time) - (s_damp) * (DeltaY_vect(i+1))/(delta_time);
        
        %%%%%%%%%%%%
        VelX_mat1(i,t) = (X_mat1(i,t) - X_mat1(i,t-1))/(delta_time) - (s_damp1) * (DeltaX_vect1(i+1))/(delta_time);
        VelY_mat1(i,t) = (Y_mat1(i,t) - Y_mat1(i,t-1))/(delta_time) - (s_damp1) * (DeltaY_vect1(i+1))/(delta_time);
        
        Energy_New = Energy_New + (1/2) * m * ((VelX_mat(i,t))^2 + (VelY_mat(i,t))^2);
        
    end
    Eplot_Y = {[cell2mat(Eplot_Y),Energy_New]};
    Eplot_X = {[cell2mat(Eplot_X),t]};
    
    s_damp1 = 0.8 - 0.7 * (t^2/(totalTimeFrames^2));
    
end

h = figure('visible','on');

for t = 1 : 3 : totalTimeFrames
    for i = 1 : size-1

           X1 = X_mat(i,t);
           X2 = X_mat(i+1,t);
           Y1 = Y_mat(i,t);
           Y2 = Y_mat(i+1,t); 

           X1_1 = X_mat1(i,t);
           X2_1 = X_mat1(i+1,t);
           Y1_1 = Y_mat1(i,t);
           Y2_1 = Y_mat1(i+1,t); 
           
           plot([X1,X2],[Y1,Y2],'r');
           hold on;

           %%%%%%%%%%%%%%

           plot([X1_1,X2_1],[Y1_1,Y2_1],'b');
           hold on;

    end

    plot(X_mat(size,t),Y_mat(size,t),'r.');
    hold on;
    plot(X_mat1(size,t),Y_mat1(size,t),'b.');
    hold on;
end

legend_str = {'DFTL_{Orig}','','DFTL_{Quad}'};

legend(legend_str{1},legend_str{3});

function [VS,HEEL,iter,FLAG,R] = solve_Newton(VS0,HEEL0,TWS,TWA,hulldata,rigdata,SAILSET,R)

    %---------------------------------------------------
    % VPP solver unit that solves for VS & HEEL
    %
    %
    %---------------------------------------------------

    step  = [666;666];         % Starting values for step vector [VS;HEEL]
    iter  = 0;        % Count iterations
    FLAG  =0;         % Warning flag for heel, FLAG=1 HEEL>35 deg else FLAG=0
    dVS   = 0.0001;        % [m/s]  Step length for derivatives by finite differences
    dHEEL = 0.0001;         % [rad]  Step length for derivatives by finite differences
   
    X = [VS0,HEEL0]'; % Create vector X with the initial guesses
    conv = [ 0.01; 0.1*pi/180]; % convergence criteria -> [velocity [m/s], heel[rad]]
    
   
    % Set up Newton solver loop
     while ( abs(step(1))> conv(1) || abs( step(2))> conv(2)) % SOLVER LOOP STARTS HERE    
        VS = X(1); HEEL = X(2);
        
        %-----------------------------------------------------------------
        % DO NOT USE THIS BLOCK OF CODE IN EXERCISE 1!
        %-----------------------------------------------------------------
        % Count and check number if iterations
        iter = iter+1;          % Count iterations
        if iter>100; break; end  % Return to main.m Limit for maximum number of iterations is reached
        
        % Check heel angle for violation
        if HEEL>35*pi/180; 
            R = R - 0.05;
%             HEELdeg = HEEL*180/pi;
              X=[VS0,HEEL0]';  % Sets X to initial guess
             FLAG=1;         % Sets FLAG=1 since HEEL exceeds 35 deg          
%              break           % Exit solver loop and return to main.m
% sice VPP prenitialize VS0, HEEL0 and R0 with values from previous iteration it is moetimes necessary to unreef
% elseif is not simple - it results in a infinite loop
        elseif( HEEL<35*pi/180 && R< 1 && FLAG == 0) 
             R = R + 0.05;
              X=[VS0,HEEL0]';  % Sets X to initial guess
%               FLAG=0;         % Sets FLAG=1 since HEEL exceeds 35 deg  
        end;
        %-----------------------------------------------------------------
        
        % Ensure positive heel
        HEEL = max(0,HEEL); 
        
        % Calculate moment and force residuals F and M
        [F M] = calc_residuals_Newton(VS,HEEL,TWS,TWA,hulldata,rigdata,SAILSET,R);

        % Calculation of derivatives using the forward finite difference method
        [FdVS,~]    = calc_residuals_Newton(VS+dVS,HEEL,TWS,TWA,hulldata,rigdata,SAILSET,R);
        dFdVS       =   (FdVS -F)/dVS;
        
        [FdHEEL,~]  = calc_residuals_Newton(VS,HEEL + dHEEL,TWS,TWA,hulldata,rigdata,SAILSET,R);
        dFdHEEL     =  (FdHEEL -F)/dHEEL;
        
        [~,MdVS]    = calc_residuals_Newton(VS+dVS,HEEL,TWS,TWA,hulldata,rigdata,SAILSET,R);
        dMdVS       = (MdVS - M)/dVS;
        
        [~,MdHEEL]  =  calc_residuals_Newton(VS,HEEL + dHEEL,TWS,TWA,hulldata,rigdata,SAILSET,R);
        dMdHEEL     = (MdHEEL - M)/dHEEL;
        
        % Construct jacobian and calculate newton step
        J    = [    dFdVS   ,  dFdHEEL;
                    dMdVS    ,  dMdHEEL]; % Jacobian matrix
        step =    inv(J)* [F ;M];                                % Newton step
        step = sign(step).*min(abs(step),[VS/10;HEEL/10]); % Limit the step length
        X    =    X - step;                                  % Next iteration x 
    end % SOLVER LOOP ENDS HERE
    
    VS   = X(1);    
    HEEL = X(2);   
    
   
    
    
    
    
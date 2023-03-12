function res = ML_est_eqs(theta, R, dt)
    [n, p] = size(R);
    r_cur  = R(2:end, :)';       % r_cur is the r_(t_(j+1)) vector
    r_lag  = R(1:(end - 1), :)'; % r_lag is the r_(t_(j))   vector

    % Paramters to be Estimated
    R_ast = reshape(theta(1:p), p, 1);
    A     = reshape(theta((p + 1):(p + 1 + p*p - 1)), p, p);
    Sigma = reshape(theta((p + p*p + 1):end), p, p);
    
    % Defining the summations for R_ast, A and Sigma
    Eqq2a = zeros(p, p);
    Eqq2b = zeros(p, p);
    Eqq3  = zeros(p, p);
  
    % Equation for R_ast
    Eq1 = R_ast - (mean(r_lag, 2) + (A\sum((r_cur - r_lag),2))/(n*dt));
    
    % Summation for A 
    for i = 1:(n - 1)
        Eqq2a = Eqq2a + (R_ast - r_lag(:, i))*(R_ast - r_lag(:, i))';
        Eqq2b = Eqq2b + (R_ast - r_lag(:, i))*(r_cur(:, i) - r_lag(:, i))';
    end
        
    % Equation for A
    Eq2 = A - (1/dt)*(Eqq2a\Eqq2b)';
    
    % Summation for Sigma
    for i = 1:(n - 1)
        x = (r_cur(1:2, i) - r_lag(1:2, i)) - A*(R_ast- r_lag(1:2, i)).*dt;
        Eqq3 = Eqq3 + x*x';
    end 

    % Equation for Sigma
    Eq3 = Sigma - (1/((n - 1)*dt))*(Eqq3);
    
    % Output
    res = [Eq1; reshape(Eq2, p^2, 1); reshape(Eq3, p^2, 1)];

    return;
end
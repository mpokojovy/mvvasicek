rng(1);

time_grid_historic = datetime("7/1/2020", 'InputFormat', 'MM/dd/uuuu'):datetime("6/30/2021", 'InputFormat', 'MM/dd/uuuu');
time_grid_backtest = datetime("7/1/2021", 'InputFormat', 'MM/dd/uuuu'):datetime("9/30/2021", 'InputFormat', 'MM/dd/uuuu');

run load_data.m

US_rates_historic = interp1(US_dates, US_rates, time_grid_historic, 'linear', 'extrap');
EU_rates_historic = interp1(EU_dates, EU_rates, time_grid_historic, 'linear', 'extrap');

US_rates_backtest = interp1(US_dates, US_rates, time_grid_backtest, 'linear', 'extrap');
EU_rates_backtest = interp1(EU_dates, EU_rates, time_grid_backtest, 'linear', 'extrap');

% Plot data
figure(1);
plot_short_rates(time_grid_historic, time_grid_backtest, ...
                 US_rates_historic, EU_rates_historic, ...
                 US_rates_backtest, EU_rates_backtest);

%% Model calibration
dt = 1.0;

R_hist = [US_rates_historic; EU_rates_historic]';
R_bm   = [US_rates_backtest; EU_rates_backtest]';

R0 = R_bm(1, :);

[R_ast_0, A_0, Sigma_0] = inverse_map(R_hist, dt, "var", 1E-8, 1E6);
[R_ast_1, A_1, Sigma_1] = inverse_map(R_hist, dt, "ols", 1E-8, 1E6);

%% Rate projection
conf_level = 0.90;

nrep = 10000;
n = length(time_grid_backtest);

pred_0 = forward_map(R_ast_0, A_0, Sigma_0, R0, dt, n, nrep);
pred_1 = forward_map(R_ast_1, A_1, Sigma_1, R0, dt, n, nrep);

figure(2);
plot_comparison(time_grid_historic, time_grid_backtest, ...
                US_rates_historic, EU_rates_historic, ...
                US_rates_backtest, EU_rates_backtest, ...
                pred_0, pred_1, conf_level);

%% Backtesting - Error comparison
figure(3);
plot_error_backtest(time_grid_backtest, US_rates_backtest, EU_rates_backtest, ...
                    pred_0, pred_1);

%% Empirical residuals
figure(4);
plot_empirical_residuals(US_rates_historic, EU_rates_historic, dt, 0.05, ...
                         R_ast_0, A_0, Sigma_0, ...
                         R_ast_1, A_1, Sigma_1);

%% Simulation - MSE
R0 = [4; 7];

R_ast_true = [5; 6];
A_true     = (1/365)*[9 4; 2 3];
Sigma_true = (1/365^2)*[7 3; 3 7];

T_array = [60:30:360];

nrep = 5000; % Reduce to 500 or 50 for faster runs

figure(5);
plot_convergence_rates(R_ast_true, A_true, Sigma_true, R0, T_array, nrep);
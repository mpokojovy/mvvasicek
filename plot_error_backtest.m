function plot_error_backtest(time_grid_backtest, US_rates_backtest, EU_rates_backtest, ...
                             pred_0, pred_1)

    set(gcf, 'PaperUnits', 'centimeters');
    xSize = 26; ySize = 12;
    xLeft = (21 - xSize)/2; yTop = (30 - ySize)/2;
    set(gcf,'PaperPosition', [xLeft yTop xSize ySize]);
    set(gcf,'Position', [0 0 xSize*50 ySize*50]);

    [~, n, nrep] = size(pred_0);

    MSE0 = zeros(n, 1);
    MSE1 = zeros(n, 1);

    MAPE0 = zeros(n, 1);
    MAPE1 = zeros(n, 1);

    for i = 1:n
    for rep = 1:nrep
        x = [US_rates_backtest(i); EU_rates_backtest(i)];

        MSE0(i) = MSE0(i) + sum((pred_0(:, i, rep) - x).^2)/nrep;
        MSE1(i) = MSE1(i) + sum((pred_1(:, i, rep) - x).^2)/nrep;
            
        MAPE0(i) = MAPE0(i) + 100.0*sum(abs((pred_0(:, i, rep) - x)./x))/nrep;
        MAPE1(i) = MAPE1(i) + 100.0*sum(abs((pred_1(:, i, rep) - x)./x))/nrep;
    end
    end

    % root-MSE vs Date
    subplot_tight(1, 2, 1, [0.08 0.06]);
    hold on

    title('Empirical Root-MSE vs Date', 'interpreter', 'latex', 'FontSize', 18);

    plot(time_grid_backtest, sqrt(MSE1), 'b-',  'LineWidth', 1.5);
    plot(time_grid_backtest, sqrt(MSE0), 'r--', 'LineWidth', 1.5);

    xlabel("Date", 'interpreter', 'latex', 'FontSize', 18);
    ylabel("Root-MSE", 'interpreter', 'latex', 'FontSize', 18);

    legend({'Our MLE', 'OLS'}, ...
           'Location', 'NorthWest', 'interpreter', 'latex', 'FontSize', 18);

    % MPE vs Date
    subplot_tight(1, 2, 2, [0.08 0.06]);
    hold on
    
    title('Empirical MAPE vs Date', 'interpreter', 'latex', 'FontSize', 18);

    plot(time_grid_backtest, MAPE1, 'b-',  'LineWidth', 1.5);
    plot(time_grid_backtest, MAPE0, 'r--', 'LineWidth', 1.5);  

    xlabel("Date", 'interpreter', 'latex', 'FontSize', 18);
    ylabel("MAPE (\%)", 'interpreter', 'latex', 'FontSize', 18);

    legend({'Our MLE', 'OLS'}, ...
           'Location', 'NorthWest', 'interpreter', 'latex', 'FontSize', 18);
end
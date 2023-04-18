function plot_comparison(time_grid_historic, time_grid_backtest, ...
                         US_rates_historic, EU_rates_historic, ...
                         US_rates_backtest, EU_rates_backtest, ...
                         projection_ML, projection_OLS, conf_level)

    set(gcf, 'PaperUnits', 'centimeters');
    xSize = 26; ySize = 12;
    xLeft = (21 - xSize)/2; yTop = (30 - ySize)/2;
    set(gcf,'PaperPosition', [xLeft yTop xSize ySize]);
    set(gcf,'Position', [0 0 xSize*50 ySize*50]);

    time_grid = [time_grid_historic time_grid_backtest(2:end)];
        
    US_rates = [US_rates_historic US_rates_backtest(2:end)];
    EU_rates = [EU_rates_historic EU_rates_backtest(2:end)];
    
    low_rate = 0.50*(min([US_rates EU_rates]) + max([US_rates EU_rates])) - ...
               0.75*(max([US_rates EU_rates]) - min([US_rates EU_rates]));

    high_rate = 0.50*(min([US_rates EU_rates]) + max([US_rates EU_rates])) + ...
                1.00*(max([US_rates EU_rates]) - min([US_rates EU_rates]));

    %% Projection 1
    subplot_tight(1, 2, 1, [0.08 0.06]);
    hold on;

    title('Our MLE', 'interpreter', 'latex', 'FontSize', 18);
    
    patch([time_grid_backtest, flip(time_grid_backtest)], ...
          [quantile(squeeze(projection_ML(1, :, :)), 0.5*(1.0 - conf_level), 2)', ...
          flip(quantile(squeeze(projection_ML(1, :, :)), 1.0 - 0.5*(1.0 - conf_level), 2))'], [0.9, 0.9, 0.9], ...
          'EdgeColor', 'none', 'FaceColor', [0,      0.4470, 0.7410], 'FaceAlpha', 0.1);
    
    patch([time_grid_backtest, flip(time_grid_backtest)], ...
          [quantile(squeeze(projection_ML(2, :, :)), 0.5*(1.0 - conf_level), 2)', ...
          flip(quantile(squeeze(projection_ML(2, :, :)), 1.0 - 0.5*(1.0 - conf_level), 2))'], [0.9, 0.9, 0.9], ...
          'EdgeColor', 'none', 'FaceColor', [0.8500, 0.3250, 0.0980], 'FaceAlpha', 0.1);
    
    US_pred = plot(time_grid_backtest, mean(squeeze(projection_ML(1, :, :)), 2), ...
                   'Color', [0,      0.4470, 0.7410], 'LineStyle', '--');
    EU_pred = plot(time_grid_backtest, mean(squeeze(projection_ML(2, :, :)), 2), ...
                   'Color', [0.8500, 0.3250, 0.0980], 'LineStyle', '--');

    plot(time_grid_backtest, quantile(squeeze(projection_ML(1, :, :)), 0.5*(1.0 - conf_level), 2), 'k:');
    plot(time_grid_backtest, quantile(squeeze(projection_ML(1, :, :)), 1.0 - 0.5*(1.0 - conf_level), 2), 'k:');
    
    plot(time_grid_backtest, quantile(squeeze(projection_ML(2, :, :)), 0.5*(1.0 - conf_level), 2), 'k:');
    plot(time_grid_backtest, quantile(squeeze(projection_ML(2, :, :)), 1.0 - 0.5*(1.0 - conf_level), 2), 'k:');
    
    US = plot(time_grid, US_rates, 'Color', [0,      0.4470, 0.7410]);
    EU = plot(time_grid, EU_rates, 'Color', [0.8500, 0.3250, 0.0980]);
    plot(time_grid_backtest([1 1]), [-10, 10], 'k:');
    
    xlabel("Date", 'interpreter', 'latex', 'FontSize', 18);
    ylabel("Daily short rate", 'interpreter', 'latex', 'FontSize', 18);
    xlim([min(time_grid) max(time_grid)]);
    ylim([low_rate high_rate]);
    
    legend([US, EU, US_pred, EU_pred], {'US obs', 'EU obs', 'US mean proj', 'EU mean proj'}, ...
           'Location', 'NorthWest', 'interpreter', 'latex', 'FontSize', 14);

    %% Projection 2
    subplot_tight(1, 2, 2, [0.08 0.06]);
    hold on;

    title('OLS', 'interpreter', 'latex', 'FontSize', 18);
    
    patch([time_grid_backtest, flip(time_grid_backtest)], ...
          [quantile(squeeze(projection_OLS(1, :, :)), 0.5*(1.0 - conf_level), 2)', ...
          flip(quantile(squeeze(projection_OLS(1, :, :)), 1.0 - 0.5*(1.0 - conf_level), 2))'], [0.9, 0.9, 0.9], ...
          'EdgeColor', 'none', 'FaceColor', [0,      0.4470, 0.7410], 'FaceAlpha', 0.1);
    
    patch([time_grid_backtest, flip(time_grid_backtest)], ...
          [quantile(squeeze(projection_OLS(2, :, :)), 0.5*(1.0 - conf_level), 2)', ...
          flip(quantile(squeeze(projection_OLS(2, :, :)), 1.0 - 0.5*(1.0 - conf_level), 2))'], [0.9, 0.9, 0.9], ...
          'EdgeColor', 'none', 'FaceColor', [0.8500, 0.3250, 0.0980], 'FaceAlpha', 0.1);
    
    US_pred = plot(time_grid_backtest, mean(squeeze(projection_ML(1, :, :)), 2), ...
                   'Color', [0,      0.4470, 0.7410], 'LineStyle', '--');
    EU_pred = plot(time_grid_backtest, mean(squeeze(projection_ML(2, :, :)), 2), ...
                   'Color', [0.8500, 0.3250, 0.0980], 'LineStyle', '--');

    plot(time_grid_backtest, quantile(squeeze(projection_OLS(1, :, :)), 0.5*(1.0 - conf_level), 2), 'k:');
    plot(time_grid_backtest, quantile(squeeze(projection_OLS(1, :, :)), 1.0 - 0.5*(1.0 - conf_level), 2), 'k:');
    
    plot(time_grid_backtest, quantile(squeeze(projection_OLS(2, :, :)), 0.5*(1.0 - conf_level), 2), 'k:');
    plot(time_grid_backtest, quantile(squeeze(projection_OLS(2, :, :)), 1.0 - 0.5*(1.0 - conf_level), 2), 'k:');
    
    US = plot(time_grid, US_rates, 'Color', [0,      0.4470, 0.7410]);
    EU = plot(time_grid, EU_rates, 'Color', [0.8500, 0.3250, 0.0980]);
    plot(time_grid_backtest([1 1]), [-10, 10], 'k:');
    
    xlabel("Date", 'interpreter', 'latex', 'FontSize', 18);
    ylabel("Daily short rate", 'interpreter', 'latex', 'FontSize', 18);
    xlim([min(time_grid) max(time_grid)]);
    ylim([low_rate high_rate]);
    
    legend([US, EU, US_pred, EU_pred], {'US obs', 'EU obs', 'US mean proj', 'EU mean proj'}, ...
           'Location', 'NorthWest', 'interpreter', 'latex', 'FontSize', 14);
end
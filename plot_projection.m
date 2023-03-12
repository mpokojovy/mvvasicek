function plot_projection(time_grid_historic, time_grid_benchmark, ...
                          US_rates_historic, EU_rates_historic, ...
                          US_rates_benchmark, EU_rates_benchmark, ...
                          projection, conf_level)

    time_grid = [time_grid_historic time_grid_benchmark(2:end)];
    
    US_rates = [US_rates_historic US_rates_benchmark(2:end)];
    EU_rates = [EU_rates_historic EU_rates_benchmark(2:end)];

    % Historic plus projection
    subplot(1, 2, 1);
    hold on;

    patch([time_grid_benchmark, flip(time_grid_benchmark)], ...
          [quantile(squeeze(projection(1, :, :)), 0.5*(1.0 - conf_level), 2)', ...
          flip(quantile(squeeze(projection(1, :, :)), 1.0 - 0.5*(1.0 - conf_level), 2))'], [0.9, 0.9, 0.9], ...
          'EdgeColor', 'none', 'FaceColor', [0.9, 0.9, 0.9]);

    patch([time_grid_benchmark, flip(time_grid_benchmark)], ...
          [quantile(squeeze(projection(2, :, :)), 0.5*(1.0 - conf_level), 2)', ...
          flip(quantile(squeeze(projection(2, :, :)), 1.0 - 0.5*(1.0 - conf_level), 2))'], [0.9, 0.9, 0.9], ...
          'EdgeColor', 'none', 'FaceColor', [0.9, 0.9, 0.9]);

    plot(time_grid_benchmark, quantile(squeeze(projection(1, :, :)), 0.5*(1.0 - conf_level), 2), 'k--');
    plot(time_grid_benchmark, quantile(squeeze(projection(1, :, :)), 1.0 - 0.5*(1.0 - conf_level), 2), 'k--');

    plot(time_grid_benchmark, quantile(squeeze(projection(2, :, :)), 0.5*(1.0 - conf_level), 2), 'k--');
    plot(time_grid_benchmark, quantile(squeeze(projection(2, :, :)), 1.0 - 0.5*(1.0 - conf_level), 2), 'k--');

    US = plot(time_grid, US_rates);
    EU = plot(time_grid, EU_rates);
    plot(time_grid_benchmark([1 1]), [-10, 10], 'Color', 'Black');

    xlabel("Date");
    ylabel("Daily short rate");
    xlim([min(time_grid) max(time_grid)]);
    ylim([-2.0 3.0]);

    legend([US, EU], {'US', 'EU'}, 'Location', 'NorthWest');

    % Projection only
    subplot(1, 2, 2);
    hold on;

    patch([time_grid_benchmark, flip(time_grid_benchmark)], ...
          [quantile(squeeze(projection(1, :, :)), 0.5*(1.0 - conf_level), 2)', ...
          flip(quantile(squeeze(projection(1, :, :)), 1.0 - 0.5*(1.0 - conf_level), 2))'], [0.9, 0.9, 0.9], ...
          'EdgeColor', 'none', 'FaceColor', [0.9, 0.9, 0.9]);

    patch([time_grid_benchmark, flip(time_grid_benchmark)], ...
          [quantile(squeeze(projection(2, :, :)), 0.5*(1.0 - conf_level), 2)', ...
          flip(quantile(squeeze(projection(2, :, :)), 1.0 - 0.5*(1.0 - conf_level), 2))'], [0.9, 0.9, 0.9], ...
          'EdgeColor', 'none', 'FaceColor', [0.9, 0.9, 0.9]);

    plot(time_grid_benchmark, quantile(squeeze(projection(1, :, :)), 0.5*(1.0 - conf_level), 2), 'k--');
    plot(time_grid_benchmark, quantile(squeeze(projection(1, :, :)), 1.0 - 0.5*(1.0 - conf_level), 2), 'k--');

    plot(time_grid_benchmark, quantile(squeeze(projection(2, :, :)), 0.5*(1.0 - conf_level), 2), 'k--');
    plot(time_grid_benchmark, quantile(squeeze(projection(2, :, :)), 1.0 - 0.5*(1.0 - conf_level), 2), 'k--');  

    US = plot(time_grid_benchmark, US_rates_benchmark);
    EU = plot(time_grid_benchmark, EU_rates_benchmark);

    xlabel("Date");
    ylabel("Daily short rate");
    xlim([min(time_grid_benchmark) max(time_grid_benchmark)]);
    ylim([-2.0 3.0]);

    legend([US, EU], {'US', 'EU'}, 'Location', 'NorthWest');
end
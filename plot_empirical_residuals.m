function plot_empirical_residuals(US_rates, EU_rates, dt, alpha, ...
                                  R_ast_0, A_0, Sigma_0, ...
                                  R_ast_1, A_1, Sigma_1)
    function plot_circle(radius)
        phi_array = linspace(0, 2*pi, 501);
        plot(radius*cos(phi_array(1:end - 1)), radius*sin(phi_array(1:end - 1)), 'k--', 'LineWidth', 2)
    end

    set(gcf, 'PaperUnits', 'centimeters');
    xSize = 24; ySize = 12;
    xLeft = (21 - xSize)/2; yTop = (30 - ySize)/2;
    set(gcf,'PaperPosition', [xLeft yTop xSize ySize]);
    set(gcf,'Position', [0 0 xSize*50 ySize*50]);

    n = length(US_rates) - 1;

    %% MLE
    subplot_tight(1, 2, 1, [0.08 0.06]);
    hold on

    axis equal;

    dr = [diff(US_rates, 1); diff(EU_rates, 1)]' - ...
         (R_ast_0 - [US_rates(1:end - 1); EU_rates(1:end - 1)])'*A_0'*dt;

    res = dr*inv(sqrtm(Sigma_0)*dt);
    plot(res(:, 1), res(:, 2), 'bo');

    alpha_cor = 1 - (1 - alpha)^(1/n);
    radius = sqrt(chi2inv(1 - alpha_cor, 2));
    plot_circle(radius);

    I = find(sum(res.*res, 2) >= radius^2);
    plot(res(I, 1), res(I, 2), 'b*');

    title('Our MLE', 'interpreter', 'latex', 'FontSize', 18);

    xlabel("US residuals", 'interpreter', 'latex', 'FontSize', 18);
    ylabel("EU residuals", 'interpreter', 'latex', 'FontSize', 18);

    %% OLS
    subplot_tight(1, 2, 2, [0.08 0.06]);
    hold on

    axis equal;

    dr = [diff(US_rates, 1); diff(EU_rates, 1)]' - ...
         (R_ast_1 - [US_rates(1:end - 1); EU_rates(1:end - 1)])'*A_1'*dt;

    res = dr*inv(sqrtm(Sigma_0)*dt);
    plot(res(:, 1), res(:, 2), 'ro');

    alpha_cor = 1 - (1 - alpha)^(1/n);
    radius = sqrt(chi2inv(1 - alpha_cor, 2));
    plot_circle(radius);

    I = find(sum(res.*res, 2) >= radius^2);
    plot(res(I, 1), res(I, 2), 'r*');

    title('OLS', 'interpreter', 'latex', 'FontSize', 18);

    xlabel("US residuals", 'interpreter', 'latex', 'FontSize', 18);
    ylabel("EU residuals", 'interpreter', 'latex', 'FontSize', 18);
end
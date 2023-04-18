function plot_convergence_rates(R_ast, A, Sigma, R0, T_array, nrep)
    set(gcf, 'PaperUnits', 'centimeters');
    xSize = 30; ySize = 12;
    xLeft = (21 - xSize)/2; yTop = (30 - ySize)/2;
    set(gcf,'PaperPosition', [xLeft yTop xSize ySize]);
    set(gcf,'Position', [0 0 xSize*50 ySize*50]);

    p = size(A, 1);

    iA = inv(A);
    iSigma = inv(Sigma);

    R_ast_errors_1 = zeros(length(T_array), nrep);
    A_errors_1     = zeros(length(T_array), nrep);
    Sigma_errors_1 = zeros(length(T_array), nrep);

    R_ast_errors_0 = zeros(length(T_array), nrep);
    A_errors_0     = zeros(length(T_array), nrep);
    Sigma_errors_0 = zeros(length(T_array), nrep);
    
    for rep = 1:nrep
    for i_T = 1:length(T_array)
        n  = T_array(i_T);
        dt = 1.0;

        R = squeeze(forward_map(R_ast, A, Sigma, R0, dt, n, 1))';

        [R_ast_hat, A_hat, Sigma_hat] = inverse_map(R, dt, "ml", 1E-6, 1E6);
        iA_hat     = pinv(A_hat);
        iSigma_hat = pinv(Sigma_hat);
        R_ast_errors_1(i_T, rep) = mean((R_ast_hat - R_ast).^2, 'all');
        A_errors_1(i_T, rep)     = mean((eye(p) - iA*A_hat).^2, 'all') + ...
                                   mean((eye(p) - A*iA_hat).^2, 'all');
        Sigma_errors_1(i_T, rep) = mean((eye(p) - iSigma*Sigma_hat).^2, 'all') + ...
                                   mean((eye(p) - Sigma*iSigma_hat).^2, 'all');

        [R_ast_hat, A_hat, Sigma_hat] = inverse_map(R, dt, "ols", 1E-6, 1E6);
        iA_hat     = pinv(A_hat);
        iSigma_hat = pinv(Sigma_hat);        
        R_ast_errors_0(i_T, rep) = mean((R_ast_hat - R_ast).^2, 'all');
        A_errors_0(i_T, rep)     = mean((eye(p) - iA*A_hat).^2, 'all') + ...
                                   mean((eye(p) - A*iA_hat).^2, 'all');
        Sigma_errors_0(i_T, rep) = mean((eye(p) - iSigma*Sigma_hat).^2, 'all') + ...
                                   mean((eye(p) - Sigma*iSigma_hat).^2, 'all');
    end
    end
    
    subplot_tight(1, 3, 1, [0.08 0.04]);
    hold on;
    ymax = min(25.0, max([sqrt(mean(R_ast_errors_1, 2)); sqrt(mean(R_ast_errors_0, 2))]))*1.25;
    xlim([min(T_array) max(T_array)]);
    ylim([0 ymax]);
    plot(T_array, sqrt(mean(R_ast_errors_1, 2)), 'b-', 'LineWidth', 1.5);
    plot(T_array, sqrt(mean(R_ast_errors_0, 2)), 'r--', 'LineWidth', 1.5);
    title('Estimator $\hat{\bf{R}}^{\ast}$', 'interpreter', 'latex', 'FontSize', 18);
    xlabel("Calibration time horizon (days)", 'interpreter', 'latex', 'FontSize', 18);
    ylabel("Empirical root-MSE", 'interpreter', 'latex', 'FontSize', 18);
    legend('Our MLE', 'OLS', 'Location', 'NorthWest', 'interpreter', 'latex', 'FontSize', 14);

    subplot_tight(1, 3, 2, [0.08 0.04]);
    hold on;
    ymax = min(25.0, max([sqrt(mean(A_errors_1, 2)); sqrt(mean(A_errors_0, 2))]))*1.25;
    xlim([min(T_array) max(T_array)]);
    ylim([0 ymax]);
    plot(T_array, sqrt(mean(A_errors_1, 2)), 'b-', 'LineWidth', 1.5);
    plot(T_array, sqrt(mean(A_errors_0, 2)), 'r--', 'LineWidth', 1.5);
    title('Estimator $\hat{\bf{A}}$', 'interpreter', 'latex', 'FontSize', 18);
    xlabel("Calibration time horizon (days)", 'interpreter', 'latex', 'FontSize', 18);
    ylabel("Empirical root-MSE", 'interpreter', 'latex', 'FontSize', 18);
    legend('Our MLE', 'OLS', 'Location', 'NorthWest', 'interpreter', 'latex', 'FontSize', 14);

    subplot_tight(1, 3, 3, [0.08 0.06]);
    hold on;
    ymax = max([sqrt(mean(Sigma_errors_1, 2)); sqrt(mean(Sigma_errors_0, 2))])*1.25;
    xlim([min(T_array) max(T_array)]);
    ylim([0 ymax]);
    plot(T_array, sqrt(mean(Sigma_errors_1, 2)), 'b-', 'LineWidth', 1.5);
    plot(T_array, sqrt(mean(Sigma_errors_0, 2)), 'r--', 'LineWidth', 1.5);
    title('Estimator $\hat{\bf{\Sigma}}$', 'interpreter', 'latex', 'FontSize', 18);
    xlabel("Calibration time horizon (days)", 'interpreter', 'latex', 'FontSize', 18);
    ylabel("Empirical root-MSE", 'interpreter', 'latex', 'FontSize', 18);
    legend('Our MLE', 'OLS', 'Location', 'NorthWest', 'interpreter', 'latex', 'FontSize', 14);

    %%
    figure;
    set(gcf, 'PaperUnits', 'centimeters');
    xSize = 15; ySize = 12;
    xLeft = (21 - xSize)/2; yTop = (30 - ySize)/2;
    set(gcf,'PaperPosition', [xLeft yTop xSize ySize]);
    set(gcf,'Position', [0 0 xSize*50 ySize*50]);

    plot(T_array, sqrt(mean(Sigma_errors_1, 2))./sqrt(mean(Sigma_errors_0, 2)), 'k-', 'LineWidth', 1.5);
    title('MSE-root ratio (MLE to OLS) for $\hat{\bf{\Sigma}}$', 'interpreter', 'latex', 'FontSize', 18);
    xlabel("Calibration time horizon (days)", 'interpreter', 'latex', 'FontSize', 18);
    ylabel("Empirical root-MSE ratio", 'interpreter', 'latex', 'FontSize', 18);
end
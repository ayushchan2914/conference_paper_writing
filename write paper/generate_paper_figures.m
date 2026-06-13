%% generate_paper_figures.m
%  Re-exports existing .fig files with publication-quality formatting:
%  black text, Times New Roman, 300 DPI, clean white background.
%
%  Run from: C:\New folder\conf paper latex\write paper\
%  Output:   pareto_nsga2_30kw.png, pareto_mopso_30kw.png, pareto_spea2_30kw.png

function generate_paper_figures()
    paperDir = fileparts(mfilename('fullpath'));
    baseDir = fullfile(paperDir, '..');

    nsga2Dir = fullfile(baseDir, '30 kw', ...
        'batch_nsga2_charger_rate_30kw_max_charges_3_4_5_6_30_20260611_181659');
    mopsoDir = fullfile(baseDir, '30 kw', ...
        'batch_mopso_charger_rate_30kw_max_charges_3_4_5_6_30_20260611_181659');
    spea2Dir = fullfile(baseDir, '30 kw', ...
        'batch_spea2_charger_rate_30kw_max_charges_3_4_5_6_30_20260611_181659');

    figs = {
        fullfile(nsga2Dir, 'max_charges_4', 'nsgaii', 'evcs_nsgaii_pareto_plot.fig'), 'pareto_nsga2_30kw.png', 'NSGA-II';
        fullfile(mopsoDir, 'max_charges_4', 'mopso',  'evcs_mopso_pareto_plot.fig'),  'pareto_mopso_30kw.png', 'MOPSO';
        fullfile(spea2Dir, 'max_charges_4', 'spea2',  'evcs_spea2_pareto_plot.fig'),  'pareto_spea2_30kw.png', 'SPEA2';
    };

    for i = 1:size(figs,1)
        figPath  = figs{i,1};
        outName  = figs{i,2};
        algLabel = figs{i,3};

        if ~isfile(figPath)
            fprintf('SKIP: %s not found\n', figPath);
            continue;
        end

        fprintf('Processing: %s (%s)\n', outName, algLabel);
        h = openfig(figPath, 'invisible');
        reformatFigure(h);
        sgtitle(h, sprintf('%s Pareto Front (N_{max} = 4, 30 kW)', algLabel), ...
            'FontSize', 16, 'FontWeight', 'bold', 'FontName', 'Times New Roman', ...
            'Color', [0 0 0]);
        outPath = fullfile(paperDir, outName);
        exportgraphics(h, outPath, 'Resolution', 300);
        fprintf('  Saved: %s\n', outPath);
        close(h);
    end

    fprintf('\nDone.\n');
end

function reformatFigure(h)
    allAxes = findall(h, 'Type', 'axes');
    for axIdx = 1:numel(allAxes)
        ax = allAxes(axIdx);
        set(ax, 'FontName', 'Times New Roman', 'FontSize', 11, ...
            'XColor', [0 0 0], 'YColor', [0 0 0], 'ZColor', [0 0 0], ...
            'Color', [1 1 1], 'Box', 'on', 'LineWidth', 1.2);
        set(get(ax,'Title'),  'Color',[0 0 0], 'FontName','Times New Roman', 'FontSize',13, 'FontWeight','bold');
        set(get(ax,'XLabel'),'Color',[0 0 0], 'FontName','Times New Roman', 'FontSize',12, 'FontWeight','bold');
        set(get(ax,'YLabel'),'Color',[0 0 0], 'FontName','Times New Roman', 'FontSize',12, 'FontWeight','bold');
        zlab = get(ax,'ZLabel');
        if ~isempty(zlab), set(zlab,'Color',[0 0 0],'FontName','Times New Roman','FontSize',12,'FontWeight','bold'); end
        set(ax, 'GridColor',[0.6 0.6 0.6], 'GridAlpha',0.3);
    end
    leg = findobj(h,'Type','legend');
    for l = 1:numel(leg)
        set(leg(l),'TextColor',[0 0 0],'FontName','Times New Roman','FontSize',10,'EdgeColor',[0 0 0],'LineWidth',0.8);
    end
end

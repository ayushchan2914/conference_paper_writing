%% generate_paper_figures.m
%  Re-exports existing .fig files with publication-quality formatting:
%  black text, Times New Roman, 300 DPI, clean white background.

function generate_paper_figures()
    set(0, 'DefaultFigureVisible', 'off');

    paperDir = fileparts(mfilename('fullpath'));
    baseDir = fullfile(paperDir, '..');

    figs = {
        fullfile(baseDir, '30 kw', 'batch_nsga2_charger_rate_30kw_max_charges_3_4_5_6_30_20260611_181659', 'max_charges_4', 'nsgaii', 'evcs_nsgaii_pareto_plot.fig'), 'pareto_nsga2_30kw.png', 'NSGA-II';
        fullfile(baseDir, '30 kw', 'batch_nsga2_charger_rate_30kw_max_charges_3_4_5_6_30_20260611_181659', 'max_charges_4', 'nsgaii', 'evcs_nsgaii_pareto_plot.fig'), 'pareto_nsga2_30kw_3d.png', 'NSGA-II';
        fullfile(baseDir, '30 kw', 'batch_mopso_charger_rate_30kw_max_charges_3_4_5_6_30_20260611_181659', 'max_charges_4', 'mopso',  'evcs_mopso_pareto_plot.fig'),  'pareto_mopso_30kw.png', 'MOPSO';
        fullfile(baseDir, '30 kw', 'batch_spea2_charger_rate_30kw_max_charges_3_4_5_6_30_20260611_181659', 'max_charges_4', 'spea2',  'evcs_spea2_pareto_plot.fig'),  'pareto_spea2_30kw.png', 'SPEA2';
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

        set(h, 'Color', 'white', 'PaperPositionMode', 'auto', 'InvertHardcopy', 'off');

        allAxes = findall(h, 'Type', 'axes');
        for axIdx = 1:numel(allAxes)
            ax = allAxes(axIdx);
            is3D = ~isempty(findobj(ax, 'Type', 'scatter3')) || ~isempty(findobj(ax, 'Type', 'surface'));
            if is3D
                labelFontSize = 8;
                tickFontSize = 7;
                titleFontSize = 10;
            else
                labelFontSize = 11;
                tickFontSize = 10;
                titleFontSize = 12;
            end
            set(ax, 'FontName', 'Times New Roman', 'FontSize', tickFontSize, ...
                'XColor', [0 0 0], 'YColor', [0 0 0], 'ZColor', [0 0 0], ...
                'Color', [1 1 1], 'Box', 'on', 'LineWidth', 1.2);
            titleH = get(ax, 'Title');
            if ~isempty(titleH), set(titleH, 'Color', [0 0 0], 'FontName', 'Times New Roman', 'FontSize', titleFontSize, 'FontWeight', 'bold'); end
            xlabelH = get(ax, 'XLabel');
            if ~isempty(xlabelH), set(xlabelH, 'Color', [0 0 0], 'FontName', 'Times New Roman', 'FontSize', labelFontSize, 'FontWeight', 'bold'); end
            ylabelH = get(ax, 'YLabel');
            if ~isempty(ylabelH), set(ylabelH, 'Color', [0 0 0], 'FontName', 'Times New Roman', 'FontSize', labelFontSize, 'FontWeight', 'bold'); end
            zlabelH = get(ax, 'ZLabel');
            if ~isempty(zlabelH), set(zlabelH, 'Color', [0 0 0], 'FontName', 'Times New Roman', 'FontSize', labelFontSize, 'FontWeight', 'bold'); end
            set(ax, 'GridColor', [0.6 0.6 0.6], 'GridAlpha', 0.3);
        end

        allColorbars = findobj(h, 'Type', 'colorbar');
        for cIdx = 1:numel(allColorbars)
            cb = allColorbars(cIdx);
            set(cb, 'Color', [1 1 1], 'Box', 'on', 'LineWidth', 0.8);
            cbPatches = findobj(cb, 'Type', 'patch');
            for p = 1:numel(cbPatches)
                set(cbPatches(p), 'FaceColor', [1 1 1], 'EdgeColor', 'none');
            end
            cbImages = findobj(cb, 'Type', 'image');
            if ~isempty(cbImages)
                set(cb, 'Color', [1 1 1]);
            end
        end

        leg = findobj(h, 'Type', 'legend');
        for l = 1:numel(leg)
            set(leg(l), 'TextColor', [0 0 0], 'FontName', 'Times New Roman', ...
                'FontSize', 10, 'EdgeColor', [0 0 0], 'LineWidth', 0.8, ...
                'Color', [1 1 1], 'Location', 'southoutside', 'Orientation', 'horizontal');
            legChildren = findobj(leg(l), 'Type', 'patch');
            for p = 1:numel(legChildren)
                set(legChildren(p), 'FaceColor', [1 1 1], 'EdgeColor', 'none');
            end
        end

        % Fix star marker visibility: add white edge to Entropy-MADM markers
        allScatter = findall(h, 'Type', 'scatter');
        for sIdx = 1:numel(allScatter)
            sc = allScatter(sIdx);
            if strcmp(sc.Marker, 'pentagram') || strcmp(sc.Marker, 'star')
                sc.MarkerFaceColor = [1 1 1];
                sc.MarkerEdgeColor = [0 0 0];
                sc.LineWidth = 1.5;
            end
        end
        allLines = findall(h, 'Type', 'line');
        for lIdx = 1:numel(allLines)
            ln = allLines(lIdx);
            if strcmp(ln.Marker, 'pentagram') || strcmp(ln.Marker, 'star')
                ln.MarkerFaceColor = [1 1 1];
                ln.MarkerEdgeColor = [0 0 0];
                ln.LineWidth = 1.5;
            end
        end

        sgtitle(h, sprintf('%s Pareto Front (N_{max} = 4, 30 kW)', algLabel), ...
            'FontSize', 16, 'FontWeight', 'bold', 'FontName', 'Times New Roman', ...
            'Color', [0 0 0]);

        outPath = fullfile(paperDir, outName);
        print(h, outPath, '-dpng', '-r300');
        fprintf('  Saved: %s\n', outPath);
        close(h);
    end

    fprintf('\nDone.\n');
end

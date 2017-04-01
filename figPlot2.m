function figPlot2(x1, x2, y1, y2, sTitle, xLableS, yLableS, legendS1, legendS2, fileName1, fileName2)
    figure
    plot(x1, y1, x2, y2, 'LineWidth', 2);
    title(sTitle, 'FontSize', 20);
    set(gca, 'FontSize', 18, 'LineWidth', 1.5);
    xlabel(xLableS, 'FontSize', 20) % x-axis label
    ylabel(yLableS, 'FontSize', 20) % y-axis label
    legend(legendS1, legendS2);
    saveas(gcf, fileName1);
    saveas(gcf, fileName2);
end
function figPlot3(x1, x2, x3, y1, y2, y3, sTitle, xLableS, yLableS, legendS1, legendS2, legendS3, fileName1, fileName2)
    figure
    plot(x1, y1, x2, y2, x3, y3, 'LineWidth', 2);
    title(sTitle, 'FontSize', 20);
    set(gca, 'FontSize', 18, 'LineWidth', 1.5);
    xlabel(xLableS, 'FontSize', 20) % x-axis label
    ylabel(yLableS, 'FontSize', 20) % y-axis label
    legend(legendS1, legendS2, legendS3);
    saveas(gcf, fileName1);
    saveas(gcf, fileName2);
end
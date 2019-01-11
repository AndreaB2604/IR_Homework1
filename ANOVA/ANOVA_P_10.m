%
% Copyright 2018-2019 University of Padua, Italy
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%     http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%
% Author: Nicola Ferro (ferro@dei.unipd.it)
%load('ap_C09.mat')
clear

x = [1.0000, 0.4000, 0.5000, 0.5000, 0.4000, 0.0000, 0.8000, 0.6000, 0.2000, 0.4000, 0.5000, 0.3000, 0.1000, 0.7000, 1.0000, 0.8000, 0.8000, 0.9000, 0.3000, 0.2000, 0.1000, 0.7000, 0.6000, 0.4000, 0.8000, 0.0000, 0.5000, 0.4000, 0.1000, 0.2000, 0.2000, 0.8000, 0.3000, 0.5000, 0.8000, 0.1000, 0.3000, 0.3000, 0.2000, 1.0000, 0.9000, 0.8000, 0.3000, 0.1000, 0.3000, 0.9000, 0.8000, 0.2000, 0.4000, 0.7000];
y = [1.0000, 0.4000, 0.5000, 0.5000, 0.4000, 0.0000, 0.8000, 0.6000, 0.2000, 0.4000, 0.5000, 0.2000, 0.1000, 0.7000, 1.0000, 0.7000, 0.7000, 0.9000, 0.3000, 0.2000, 0.1000, 0.8000, 0.6000, 0.4000, 0.8000, 0.0000, 0.5000, 0.3000, 0.1000, 0.2000, 0.2000, 0.8000, 0.3000, 0.5000, 0.8000, 0.1000, 0.3000, 0.3000, 0.2000, 1.0000, 0.8000, 0.8000, 0.3000, 0.2000, 0.3000, 1.0000, 0.8000, 0.2000, 0.4000, 0.7000];
z = [1.0000, 0.0000, 0.5000, 0.0000, 0.2000, 0.0000, 0.0000, 0.6000, 0.1000, 0.6000, 0.5000, 0.2000, 0.1000, 0.9000, 1.0000, 0.4000, 0.4000, 0.8000, 0.2000, 0.0000, 0.0000, 0.5000, 0.0000, 0.3000, 0.3000, 0.0000, 0.3000, 0.0000, 0.1000, 0.2000, 0.1000, 0.0000, 0.3000, 0.0000, 0.6000, 0.0000, 0.2000, 0.4000, 0.2000, 1.0000, 0.0000, 0.1000, 0.2000, 0.0000, 0.0000, 1.0000, 0.7000, 0.1000, 0.3000, 0.7000];
w = [1.0000, 0.5000, 0.7000, 0.5000, 0.3000, 0.0000, 0.6000, 0.2000, 0.1000, 0.9000, 0.5000, 0.2000, 0.0000, 0.7000, 1.0000, 0.7000, 0.5000, 0.9000, 0.2000, 0.3000, 0.1000, 0.6000, 0.6000, 0.4000, 0.7000, 0.0000, 0.4000, 0.2000, 0.3000, 0.2000, 0.1000, 0.7000, 0.2000, 0.3000, 0.4000, 0.0000, 0.3000, 0.3000, 0.1000, 0.9000, 0.9000, 0.5000, 0.4000, 0.1000, 0.3000, 1.0000, 0.4000, 0.1000, 0.2000, 0.8000];

measure = [x.' y.' z.' w.'];
runID = ["Run 1", "Run 2", "Run 3", "Run 4"];
runID = strtrim(cellstr(runID));
topicID = 351:400;
topicID = arrayfun(@num2str,topicID,'UniformOutput',false);

% the mean for each run across the topics
% Note that if the measure is AP (Average Precision), 
% this is exactly MAP (Mean Average Precision) for each run
m = mean(measure);

% sort in descending order of mean score
[~, idx] = sort(m, 'descend');

% re-order runs by ascending mean of the measure
% needed to have a more nice looking box plot
measure = measure(:, idx);
runID = runID(idx);

% perform the ANOVA
[~, tbl, sts] = anova1(measure, runID, 'off');

% display the ANOVA table
tbl

% define the parameters in order to print the F-test
% the parameters have been already computed in the anova1 function called before 
alpha = 0.05;

df_col = tbl{2,3};
df_error = tbl{3,3};

Fcrit = finv(1 - alpha, df_col, df_error);

Fstat = tbl{2,5};


% perform
c = multcompare(sts, 'Alpha', 0.05, 'Ctype', 'hsd'); 

% display the multiple comparisons
c

%% plots of the data
%get the Tukey HSD test figure
currentFigure = gcf;
    ax = gca;
    ax.FontSize = 20;
    %ax.XLabel.String = 'Precision at 10';
    %ax.YLabel.String = 'Run';

    currentFigure.PaperPositionMode = 'auto';
    currentFigure.PaperUnits = 'centimeters';
    currentFigure.PaperSize = [42 22];
    currentFigure.PaperPosition = [1 1 40 20];

print(currentFigure, '-dpdf', 'p10-tukey.pdf');

% box plot
currentFigure = figure;
    % need to reverse the order of the columns to have bloxplot displayed
    % as the Tukey HSD plot
    boxplot(measure(:, end:-1:1), 'Labels', runID(end:-1:1), ...
        'Orientation', 'horizontal', 'Notch','off', 'Symbol', 'ro')
    
    ax = gca;
    ax.FontSize = 20;
    %ax.XLabel.String = 'Precision at 10';
    %ax.YLabel.String = 'Run';
    
    currentFigure.PaperPositionMode = 'auto';
    currentFigure.PaperUnits = 'centimeters';
    currentFigure.PaperSize = [42 22];
    currentFigure.PaperPosition = [1 1 40 20];

print(currentFigure, '-dpdf', 'p10-boxplot.pdf');


% F distribution
a = 0:.01:6;
f = fpdf(a, df_col, df_error);

% find where we are above and below tCrit
idx_t = a >= Fcrit;

currentFigure = figure;
    % plot the F distribution
    plot(a, f, 'LineWidth', 4, 'Color', 'k')
    hold on
    
    % plot a vertical line corresponding to Fcrit
    h(1) = plot([Fcrit Fcrit], get(gca,'ylim'), 'Color', 'r', 'LineWidth', 3, 'LineStyle', '--');
    
    % color the area under the t distribution above Fcrit
    area(a(idx_t), f(idx_t), 'FaceColor', 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'none')
    
    % plot a vertical lines corresponding to Fstat
    h(2) = plot([Fstat Fstat], get(gca,'ylim'), 'Color', 'b', 'LineWidth', 3, 'LineStyle', '--');
    
    legend(h, {'$F_{crit}$', '$F_{stat}$'}, 'Interpreter', 'Latex', 'FontSize', 36);
    
    % adjust the axes
    ax = gca;
    ax.FontSize = 36;
    ax.YLim = [0 ax.YLim(2) + 0.05];

    % print the figure
    currentFigure.PaperPositionMode = 'auto';
    currentFigure.PaperUnits = 'centimeters';
    currentFigure.PaperSize = [47 22];
    currentFigure.PaperPosition = [1 1 45 20];
    print(currentFigure, '-dpdf', 'p10-f.pdf');
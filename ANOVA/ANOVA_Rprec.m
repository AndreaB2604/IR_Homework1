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

x = [0.5208, 0.0772, 0.4262, 0.2853, 0.2444, 0.0000, 0.3926, 0.3137, 0.0714, 0.3576, 0.4444, 0.2051, 0.1250, 0.5143, 0.6857, 0.4141, 0.2011, 0.4098, 0.3077, 0.2292, 0.1176, 0.3265, 0.4545, 0.3775, 0.3250, 0.0490, 0.3077, 0.1122, 0.1250, 0.2857, 0.0714, 0.5909, 0.0890, 0.2549, 0.2442, 0.0526, 0.1647, 0.3529, 0.0412, 0.2313, 0.3202, 0.4476, 0.0986, 0.1176, 0.2207, 0.3220, 0.3704, 0.2069, 0.1667, 0.4560];
y = [0.5208, 0.0772, 0.4344, 0.2715, 0.2444, 0.0000, 0.4000, 0.3333, 0.1071, 0.3444, 0.4444, 0.2051, 0.1250, 0.5143, 0.6857, 0.3939, 0.2063, 0.4098, 0.3077, 0.2083, 0.1176, 0.3265, 0.4545, 0.3775, 0.3250, 0.0686, 0.3077, 0.1122, 0.1250, 0.2857, 0.1071, 0.5909, 0.0822, 0.2353, 0.2674, 0.0526, 0.1882, 0.3333, 0.0412, 0.2388, 0.3427, 0.4381, 0.0986, 0.1176, 0.2254, 0.3390, 0.3704, 0.2069, 0.1569, 0.4560];
z = [0.3958, 0.0000, 0.4180, 0.0693, 0.1556, 0.0000, 0.0000, 0.3137, 0.1071, 0.2384, 0.4444, 0.2051, 0.0625, 0.4857, 0.6571, 0.2929, 0.1217, 0.3770, 0.1538, 0.0030, 0.0588, 0.2857, 0.0000, 0.3137, 0.1750, 0.0000, 0.2821, 0.0000, 0.0625, 0.1429, 0.0357, 0.0455, 0.0959, 0.0000, 0.2209, 0.0526, 0.1529, 0.3333, 0.0361, 0.2090, 0.0000, 0.0286, 0.0845, 0.0000, 0.0516, 0.3390, 0.3704, 0.0552, 0.1569, 0.4160];
w = [0.4583, 0.0691, 0.4508, 0.2216, 0.1333, 0.0000, 0.4074, 0.3137, 0.1429, 0.5033, 0.4444, 0.2308, 0.0000, 0.6000, 0.7143, 0.2323, 0.1693, 0.4590, 0.2308, 0.1756, 0.1765, 0.2857, 0.4545, 0.3529, 0.3250, 0.0392, 0.2821, 0.1020, 0.3125, 0.1429, 0.0357, 0.4091, 0.0890, 0.2353, 0.1860, 0.1053, 0.1529, 0.2549, 0.0155, 0.1642, 0.4438, 0.2381, 0.1127, 0.1176, 0.2066, 0.3559, 0.1481, 0.1931, 0.0980, 0.4320];

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
    %ax.XLabel.String = 'Rprec';
    %ax.YLabel.String = 'Run';

    currentFigure.PaperPositionMode = 'auto';
    currentFigure.PaperUnits = 'centimeters';
    currentFigure.PaperSize = [42 22];
    currentFigure.PaperPosition = [1 1 40 20];

print(currentFigure, '-dpdf', 'rprec-tukey.pdf');

% box plot
currentFigure = figure;
    % need to reverse the order of the columns to have bloxplot displayed
    % as the Tukey HSD plot
    boxplot(measure(:, end:-1:1), 'Labels', runID(end:-1:1), ...
        'Orientation', 'horizontal', 'Notch','off', 'Symbol', 'ro')
    
    ax = gca;
    ax.FontSize = 20;
    %ax.XLabel.String = 'Rprec';
    %ax.YLabel.String = 'Run';
    
    currentFigure.PaperPositionMode = 'auto';
    currentFigure.PaperUnits = 'centimeters';
    currentFigure.PaperSize = [42 22];
    currentFigure.PaperPosition = [1 1 40 20];

print(currentFigure, '-dpdf', 'rprec-boxplot.pdf');


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
    print(currentFigure, '-dpdf', 'rprec-f.pdf');

%% FCT_STAT
% -------------------------------------------------------------------------
% Statistic Analysis of the measured particles 
% Date: 24.05.2021
% Author: Kai Haas 
% -------------------------------------------------------------------------


%% Start of the FKT_STAT function
% -------------------------------------------------------------------------
function [] =  FKT_STAT(Plot_graphic, subplottitle);

% Import txt. file
folder = pwd;     
HA_1   = importdata(strcat(folder, filesep, 'Major_axis.txt'));     
HA_2   = importdata(strcat(folder ,filesep, 'Minor_axis.txt'));   
fclose('all'); 


% Statistic parameters
n      = length(HA_1);
m_HA_1 = mean(HA_1);
s_HA_1 = std(HA_1);
m_HA_2 = mean(HA_2);
s_HA_2 = std(HA_2);
M_HA_1 = median(HA_1);
M_HA_2 = median(HA_2);
F_HA_1 = max(HA_1);
F_HA_2 = max(HA_2);


% Particle morphology
AS   = HA_1./HA_2;
m_AS = mean(AS);
s_AS = std(AS);
M_AS = median(AS);
F_AS = max(AS);
for i=1:n   % Generated proportion > 1
ASS(i) = HA_1(i)/HA_2(i);
	if ASS(i)<1 
       ASS(i) = HA_2(i)/HA_1(i);
    end
AS(i) = ASS(i);  
end


% Values for FCT_density_function.m
x_AS   = linspace(0,max(AS),1000);
x_HA_1 = linspace(0,max(HA_1),1000);
x_HA_2 = linspace(0,max(HA_2),1000);


%% Table of statistic parameters
% -------------------------------------------------------------------------
r = 2;
statistic_parameters = {'Mean';'Median';'Standard deviation';'Max. value';'Sample size';};
a = [round(m_HA_1, r);round(M_HA_1, r);round(s_HA_1, r);round(F_HA_1, r);n;];     
b = [round(m_HA_2, r);round(M_HA_2, r);round(s_HA_2, r);round(F_HA_2, r);n;];     
E = [round(m_AS, r)  ;round(M_AS, r)  ;round(s_AS, r)  ;round(F_AS, r)  ;n;];    
T = table(statistic_parameters, a, b, E)


%% Graphics
% -------------------------------------------------------------------------
if Plot_graphic==true;
F = figure(1);
sgtitle(subplottitle)
subplot(3,1,1)
set(F, 'Position', [400, 200, 1000, 700]); 

% Histogram 
subplot(331)
histogram(AS, 'Normalization', 'probability', 'BinWidth', 1/4)
grid on
title('Histogram of the Morphology proportion')
ylabel('Relative frequency')
xlabel('Morphology proportion E=a/b')

% Empirical distribution function
subplot(332)
cdfplot(AS) 
title('Empirical distribution function')
xlabel('Morphology proportion E=a/b')
ylabel('Relative frequency')
axis([.95 4 0 1.0])
grid on

% Normal distribution
subplot(333)
[f] = FCT_density_function(x_AS, s_AS, m_AS);
plot(x_AS, f);
grid on
xlabel('Morphology proportion E=a/b')
title('Normal distribution');


%--------------------------------------------------------------------------


% Histogram 
subplot(334)
histogram(HA_1, 'Normalization', 'probability', 'BinWidth', 5)
title('Histogram of the particle size')
xlabel('Max. Feret diameter in \mum');
ylabel('Relative frequency')
grid on

% Empirical distribution function
subplot(335)
y = evrnd(m_HA_1, s_HA_1, 1500, 1);  
cdfplot(y), hold on
ecdf(HA_1, 'Function', 'cdf')
legend('Theoretical CDF', 'Empirical CDF', 'Location', 'south east')
axis([0,80 0 1])
title('Empirical distribution function')
xlabel('Max. Feret diameter in \mum');
ylabel('Relative frequency')

% Normal distribution
subplot(336)
[f] = FCT_density_function(x_HA_1, s_HA_1, m_HA_1);
plot(x_HA_1, f);
grid on
xlabel('Max. Feret diameter in \mum');
title('Normal distribution');



%--------------------------------------------------------------------------


% Histogram 
subplot(337)
histogram(HA_2, 'Normalization', 'probability', 'BinWidth', 5)
title('Histogram of the particle size')
xlabel('Min. Feret diameter in \mum');
ylabel('Relative frequency')
grid on

% Empirical distribution function
subplot(338)
y = evrnd(m_HA_2, s_HA_2, 1500, 1);   
cdfplot(y), hold on
ecdf(HA_2, 'Function', 'cdf')
legend('Theoretical CDF', 'Empirical CDF', 'Location', 'south east')
axis([0,80 0 1])
title('Empirical distribution function')
xlabel('Min. Feret diameter in \mum');
ylabel('Relative frequency')

% Normal distribution
subplot(339)
[f] = FCT_density_function(x_HA_2, s_HA_2, m_HA_2);
plot(x_HA_2, f);
grid on
xlabel('Min. Feret diameter in \mum');
title('Normal distribution');
hold off
end
end
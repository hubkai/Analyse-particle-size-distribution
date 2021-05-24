%% START_PSD_AUTO.m
% -------------------------------------------------------------------------
% Analyse the particle size distribution with the 'Image Processing Toolbox'
% Date: 24.05.2021
% Author: Kai Haas 
% -------------------------------------------------------------------------
clear all 


%% Import pictures from folder
% -------------------------------------------------------------------------
folder = 'Folder_name';
files  = dir(cat(2, folder, '\*jpg'));     
names  = {files.name}; 


%% Parameter for the function FCT_PSD_AUTO
% -------------------------------------------------------------------------
write     = true;          % Writes data in txt. file    
threshold = 0.30;          % Threshold for circularity
scale     = 792;           % Scale of the picture, Unit: Micrometer                        

% Automated import 
for i=1:numel(names);
    name  = names{i};
    Image = imread(strcat(folder, filesep, name));
    
    % OEA function
    FCT_PSD_AUTO(Image, write, threshold, scale);
end 


%% Parameters for FCT_STAT
% -------------------------------------------------------------------------
Plot_graphic = true;
subplottitle = 'Add title'; 
if i==numel(names)
    FCT_STAT(Plot_graphic, subplottitle)
end
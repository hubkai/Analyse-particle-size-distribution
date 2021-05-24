%% FCT_PSD_AUTO.m
% -------------------------------------------------------------------------
% Analyse the particle size distribution with the 'Image Processing Toolbox'
% Date: 24.05.2021
% Author: Kai Haas 
% -------------------------------------------------------------------------


%% Start of the FKT_PSD_AUTO function
% -------------------------------------------------------------------------
function [] = FCT_PSD_AUTO(Image, write, threshold, scale)

% Import and prepare pictures for analysis
% -------------------------------------------------------------------------
I   = Image;
Bw  = imsharpen(I,'Radius',5,'Amount',0.7);
BWI = imbinarize(Bw);         
BW  = bwareaopen(BWI,0,8);     
dim = size(BW);
SE  = strel("disk",1);
bw1 = imerode(BW,SE);
bw  = imdilate(bw1,SE); 


% Get Parameters for analysis
% -------------------------------------------------------------------------
bw_filled       = imfill(bw, 'holes');
[boundaries, L] = bwboundaries(bw_filled, 'noholes');   
stats           = regionprops(L, 'Area', 'Centroid');
Max_feret       = regionprops(L, 'MaxFeretProperties');
Min_feret       = regionprops(L, 'MinFeretProperties');
factor          = dim(2)/scale; % Unit: Pixel/Micrometer

% Open txt. files
if write == true;
fileID1 = fopen('Major_axis.txt', 'a'); fprintf(fileID1, '\n', '');   
fileID2 = fopen('Minor_axis.txt', 'a'); fprintf(fileID2, '\n', '');      
end


%% Loop over all particles
% -------------------------------------------------------------------------
for k=1:length(boundaries)
    
    % Get boundary for each partcle 
    boundary = boundaries{k};
    
    % Estimation of the perimeter for each particle
    delta_sq  = diff(boundary).^2;     
    perimeter = sum(sqrt(sum(delta_sq,2)));
    
    % Get area of each particle
    area = stats(k).Area;
    
    % Calculate circularity metric (Page 624 in IPT doc.)
    metric(k) = 4*pi*area/perimeter^2;
    
    % Circularity threshold
    if metric(k) > threshold;  
        
       % Get point of origin for each particle
       center(k,:) = stats(k).Centroid;   
       
       % Exclude boundary area of the picture
       if center(k,1) > 30 && center(k,1) < max(dim(:,1))-30;     
          if center(k,2) > 30 && center(k,2) < max(dim(:,2))-30;        
              
             % Get Feret values
             Feret_Max = Max_feret(k).MaxFeretDiameter;    
             Feret_Min = Min_feret(k).MinFeretDiameter;
             
             % Smallest allowed particle mm^-3
             if 10 < Feret_Max/factor 
       
             % Write values in txt. files
             if write == true;
             fprintf(fileID1, '%20.2f\n', [Feret_Max/factor]);    
             fprintf(fileID2, '%20.2f\n', [Feret_Min/factor]);          
             end
             end
          end
       end
    end
end % End For-Schleife
fclose('all'); % Close txt. file
end % End function
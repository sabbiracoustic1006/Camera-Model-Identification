tic
clc;clear all;

% Ask user to select folder_______________________________________________
topLevelFolder = uigetdir('e:\');
main_folder_length = length(topLevelFolder) + 2;

if topLevelFolder == 0
    return;
end

% get list of all subfolders______________________________________________
allSubFolders = genpath(topLevelFolder);

% Parse into a cell array_________________________________________________
remain = allSubFolders;
listOfFolderNames = {};

while true
    [singleSubFolder, remain] = strtok(remain, ';');
    if isempty(singleSubFolder)
        break;
    end
    listOfFolderNames = [listOfFolderNames singleSubFolder];
end

numberOfFolders = length(listOfFolderNames);

% feature and label variables initialization______________________________
features = [];
labels = {};

feature = zeros(1, 1372);
% Process all image files in those folders________________________________
for folder = 2 : numberOfFolders
    
    % Get this folder and print it out____________________________________
    thisFolder = listOfFolderNames{folder};
    fprintf('Processing folder %s\n', thisFolder);
    
    % Get Pgm files_______________________________________________________
    filePattern = sprintf('%s/*.jpg', thisFolder);
    baseFileNames = dir(filePattern);
    numberOfImageFiles = length(baseFileNames);
    
    % Go through all those image files____________________________________
    for i = 1 : 2
%        numberOfImageFiles 
        fullFileName = fullfile(thisFolder, baseFileNames(i).name);
        
        t_start = tic;
        
        % features extraction_____________________________________________
        d = demosaicingfeature(fullFileName);
        
        feature(1:numel(d)) = d;
        features=[features; feature];
        
        % labels__________________________________________________________
        labels = [labels; thisFolder(main_folder_length:end)];
        
        t_end = toc(t_start);
        
        fprintf(' - processed in %.2f seconds', t_end);
        fprintf('Processing image file %s\n', fullFileName);
        
        
    end
    
end

% create a table of features and labels
T = table(features, labels);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Note: Use Classification Learner App for machine learning part %                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

toc
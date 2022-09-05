% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  Copyright (C) 2020 HOLOEYE Photonics AG. All rights reserved.
%  Contact: https://holoeye.com/contact/
%  
%  This file is part of HOLOEYE SLM Display SDK.
%  
%  You may use this file under the terms and conditions of the
%  "HOLOEYE SLM Display SDK Standard License v1.0" license agreement.
%  
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% Plays a slideshow on the SLM with pre-loaded image files from a single folder.
% The image files are pre-loaded to the GPU once, and then each image is shown on the SLM by selecting the 
% appropriate ID of the pre-laoded file on the GPU to reach higher performance.
% The duration each image is shown can be configured and is maintained by the GPU as much as possible.
% For holograms, please use image formats which are uncompressed (e.g. BMP) or which use lossless compression, like PNG.

% Show text output immediately:
more off;

% Import SDK:
add_heds_path;
heds_types;

% Check if the installed SDK supports the required API version
heds_requires_version(3);

% Make some enumerations available locally to avoid too much code:
heds_types;

% Detect SLMs and open a window on the selected SLM:
heds_slm_init;

% Open the SLM preview window in non-scaled mode:
% This might have an impact on performance, especially in "Capture SLM screen" mode.
% Please adapt the file show_slm_preview.m if preview window is not at the right position or even not visible.
show_slm_preview(1.0);

% Delete all old handles to free up video card memory:
heds_datahandle_release_all;

% Configure slideshow:
imageFolder = strcat( fileparts(mfilename('fullpath')), '/data/vertical_grating' ) % please specify the folder with the slideshow you want to play
imageDisplayDurationMilliSec = 100 % please select the duration in ms each image file shall be shown on the SLM
repeatSlideshow = 3  % <= 0 (e. g. -1) repeats until Ctrl-C is pressed in terminal

% Please select how to scale and transform image files while displaying:
displayOptions = heds_showflags.Auto;

% Search image files in given folder:
% For a full list of supported file formats, please refer to the documentation of the function heds_load_data_fromfile().
imagesList = listFiles(imageFolder, {'png', 'gif', 'bmp', 'jpg'});
for i=1:length(imagesList)
    fprintf(imagesList{i});
    fprintf('\n');
end
fprintf('Number of images found in imageFolder = %d\n', length(imagesList));

if (length(imagesList) <= 0),
    return;
end

% Load the data we want to show:
disp('Loading data ...');
tic;

dataHandles = {};
calcPercent = 0;

durationInFrames = int32((imageDisplayDurationMilliSec/1000) * heds_slm_refreshrate_hz)
if durationInFrames <= 0
    durationInFrames = 1  % The minimum duration is one video frame of the SLM
end


nHandle = 0; %total number of images loaded to GPU
for i = 1:length(imagesList)
    % Print progress:
    percent = int32(nHandle / length(imagesList) * 100);
    if percent / 10 > calcPercent
        calcPercent = percent / 10;
        fprintf('%d%%\n', percent);
    end

    % Load data from image file to GPU:
    handle = heds_load_data_fromfile(imagesList{i});

    % Set properties of the handle:
    handle.durationInFrames = durationInFrames;
    heds_datahandle_apply(handle, heds_datahandle_applyvalue.DurationInFrames);
    
    nHandle = nHandle+1;
    dataHandles{nHandle} = handle;
end

% Make sure all data was loaded:
for i = 1:length(dataHandles)
    heds_datahandle_waitfor(dataHandles{i}.id, heds_state.ReadyToRender);
end

disp('100%');
fprintf('Upload took %0.3f seconds\n', toc);

% Show the preloaded data:
disp('Showing data...');

disp('Please press Ctrl-C to exit.');

n = 0;
while ((n < repeatSlideshow) || (repeatSlideshow <= 0)),
    n = n+1;
  
    fprintf('Show images for the %d. time ...\n', n)
    
    for i = 1:length(dataHandles)
        heds_show_datahandle(dataHandles{i}.id, displayOptions);
    end
    
    % Update the handles to the latest state:
    clear dataHandles2;
    for i = 1:length(dataHandles)-1 % The last handle might have a wrong visible time here.
        dataHandles2{i} = heds_datahandle_update( dataHandles{i}.id );
    end

    % Print the actual timing statistics:
    disp('Timing statistics:')
    printStat(dataHandles2, 'delayTimeMs')
    printStat(dataHandles2, 'processingWaitTimeMs')
    printStat(dataHandles2, 'loadingTimeMs')
    printStat(dataHandles2, 'conversionTimeMs')
    printStat(dataHandles2, 'processingTimeMs')
    printStat(dataHandles2, 'transferTimeMs')
    printStat(dataHandles2, 'renderWaitTimeMs')
    printStat(dataHandles2, 'renderTimeMs')
    printStat(dataHandles2, 'becomeVisibleTimeMs')
    printStat(dataHandles2, 'visibleTimeMs')
    
end

% Please uncomment to close SDK at the end:
% heds_close_slm
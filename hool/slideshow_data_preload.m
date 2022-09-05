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
% Plays a slideshow on the SLM with pre-calculated 2d phase fields consisting of vertical blazed gratings with different periods.
% The data fields are pre-calculated and uploaded to the GPU once, and then each frame is shown on the SLM by selecting the 
% appropriate phase values field on the GPU directly to reach higher performance.

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

% Configure slideshow (steer the laser beam from left to right and back):
gratingPeriodMin = 8
gratingPeriodMax = 64
gratingPeriodStepSize = 4
dataDisplayDurationMilliSec = 100  % duration of each data frame in ms
repeatSlideshow = 3  % <= 0 (e. g. -1) repeats until Ctrl-C is pressed in terminal

gratingPeriodList = [-gratingPeriodMin:-gratingPeriodStepSize:-gratingPeriodMax];
gratingPeriodList = [gratingPeriodList, gratingPeriodMax:-gratingPeriodStepSize:gratingPeriodMin];
gratingPeriodList = [gratingPeriodList, gratingPeriodMin:gratingPeriodStepSize:gratingPeriodMax];
gratingPeriodList = [gratingPeriodList, -gratingPeriodMax:gratingPeriodStepSize:-gratingPeriodMin];

gratingPeriodList
fprintf('length(gratingPeriodList) = %d\n', length(gratingPeriodList));


% Calculate the data we want to show:
disp('Calculating data ...');
tic;

% Pre-calculate the phase fields in full SLM size:
phaseModulation = 2*pi; % radian
dataWidth = heds_slm_width_px
dataHeight = heds_slm_height_px
phaseData = zeros(dataHeight, dataWidth, 'single');

dataHandles = {};
calcPercent = 0;

durationInFrames = int32((dataDisplayDurationMilliSec/1000) * heds_slm_refreshrate_hz)


nHandle = 0; %total number of images loaded to GPU
for blazePeriod = gratingPeriodList
    % Print progress:
    percent = int32(nHandle / length(gratingPeriodList) * 100);
    if percent / 10 > calcPercent
        calcPercent = percent / 10;
        fprintf('%d%%\n', percent);
    end

    % Calculate data:
    phaseData(:, :) = phaseModulation .* (repmat((1:dataWidth)-1 - dataWidth/2, dataHeight, 1)) ./ blazePeriod;
    
    % Slow, but general version:
    %for x = 1:dataWidth
    %    for (y = 1:dataHeight)
    %        phaseData(y, x) = phaseModulation * (x-1) / blazePeriod;
    %    end
    %end

    % Load data to GPU using automatic wrapping and values in radian:
    handle = heds_load_phasevalues(phaseData);

    % Set properties of the handle:
    handle.durationInFrames = durationInFrames;
    
    heds_datahandle_apply(handle, heds_datahandle_applyvalue.DurationInFrames);
    
    % Wait for actual upload to GPU:
    heds_datahandle_waitfor(handle.id, heds_state.ReadyToRender);
    
    nHandle = nHandle+1;
    dataHandles{nHandle} = handle;
end

disp('100%');
fprintf('Calculation took %0.3f seconds\n', toc);

% Show the precalculated data:
disp('Showing data...');

n = 0;
while ((n < repeatSlideshow) || (repeatSlideshow <= 0)),
    n = n+1;
  
    fprintf('Show data for the %d. time ...\n', n)
    
    for i = 1:length(dataHandles)
        heds_show_datahandle(dataHandles{i}.id, heds_showflags.Auto);
    end
    
    % Update the handles to the latest state:
    dataHandles2 = {};
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

% One last image to clear the SLM screen after the slideshow playback :
heds_show_blankscreen(128);

% Please uncomment to close SDK at the end:
% heds_close_slm
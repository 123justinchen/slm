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
% Plays a slideshow on the SLM with live-calculated 1d float (single) data fields 
% consisting of vertical blazed gratings with different periods.
% Each frame is shown on the SLM as soon as the data was transmitted.

% Show text output immediately:
more off;

% Import SDK:
add_heds_path;

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

% Configure slideshow (steer the laser beam from left to right and back):
gratingPeriodMin = 8
gratingPeriodMax = 64
gratingPeriodStepSize = 4
dataDisplayDurationMilliSec = 100 % duration of each data frame in ms
repeatSlideshow = 3  % <= 0 (e. g. -1) repeats until Ctrl-C is pressed in terminal

gratingPeriodList = [-gratingPeriodMin:-gratingPeriodStepSize:-gratingPeriodMax];
gratingPeriodList = [gratingPeriodList, gratingPeriodMax:-gratingPeriodStepSize:gratingPeriodMin];
gratingPeriodList = [gratingPeriodList, gratingPeriodMin:gratingPeriodStepSize:gratingPeriodMax];
gratingPeriodList = [gratingPeriodList, -gratingPeriodMax:gratingPeriodStepSize:-gratingPeriodMin];

gratingPeriodList
fprintf('length(gratingPeriodList) = %d\n', length(gratingPeriodList));

dataWidth = heds_slm_width_px

tic;

% Play slideshow:  
avgFPSStartTime = toc;
n = 0;
while ((n < repeatSlideshow) || (repeatSlideshow <= 0)),
    n = n+1;

    for blazePeriod = gratingPeriodList
      
        currentFPSStartTime = toc;
        
        % Calculate data:
        blazeData = zeros(1, dataWidth, 'single');
        for x = 1:dataWidth
            blazeData(x) = 2*pi * (x-1 - dataWidth/2) / blazePeriod;
        end
        
        fprintf('n = %3d: blazePeriod = %7d', n, blazePeriod);
        
        % Show data on SLM. Function returns after image was loaded and displayed:
        heds_show_phasevalues(blazeData);
        passedTime = toc - currentFPSStartTime;
        
        % Wait for next image. Wait rest of desired time after heds_show_phasevalues() took some time already:
        wait_time = dataDisplayDurationMilliSec/1000.0 - passedTime; 
        if (wait_time > 0.0)
            pause(wait_time);
        end
        
        currentFPSEndTime = toc;
        fprintf('   FPS = %5.2f\n', 1.0/(currentFPSEndTime - currentFPSStartTime));
    end

end

avgFPSEndTime = toc;
fprintf('--- Average FPS = %6.2f ---\n', (repeatSlideshow * length(gratingPeriodList))/(avgFPSEndTime - avgFPSStartTime));

heds_show_blankscreen(128);

% Please uncomment to close SDK at the end:
% heds_close_slm
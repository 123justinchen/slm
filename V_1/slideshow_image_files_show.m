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
% Plays a slideshow on the SLM using image files from a single folder.
% The image files are shown directly on the SLM as soon as the data was transmitted,
% using the API function heds_show_data_fromfile().
% The duration each image is shown can be configured and is maintained by simple sleep commands.
% For holograms, please use image formats which are uncompressed (e.g. BMP) or which use lossless compression, like PNG.

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
    fprintf([imagesList{i}, '\n']);
end
fprintf('Number of images found in imageFolder = %d\n', length(imagesList));

if (length(imagesList) <= 0),
    return;
end


% Show the image files:
disp('Playing images on SLM ...');

disp('Please press Ctrl-C to exit.');

tic;
  
avgFPSStartTime = toc;

n = 0;
while ((n < repeatSlideshow) || (repeatSlideshow <= 0)),
    n = n+1;
  
    fprintf('Show images for the %d. time ...\n', n);
    
    for i = 1:length(imagesList)
        currentFPSStartTime = toc;
        
        filename = imagesList{i};
      
        % Show image on SLM. Function returns after image was loaded and displayed:
        heds_show_data_fromfile(filename, displayOptions);
        passedTime = toc - currentFPSStartTime;
      
        % Wait for next image. Wait rest of desired time after heds_show_data_fromfile() took some time already:
        wait_time = imageDisplayDurationMilliSec/1000.0 - passedTime;
        if (wait_time > 0.0)
            pause(wait_time);
        end
        
        currentFPSEndTime = toc;
        
        fprintf('n = %3d', n);
        fprintf('   FPS = %5.2f', 1.0/(currentFPSEndTime - currentFPSStartTime));
        fprintf('   file number = %5d', i);
        fprintf('   file name: %s\n', imagesList{i});
        
    end
    
end

avgFPSEndTime = toc;
fprintf('--- Average FPS = %6.2f ---\n', (repeatSlideshow * length(imagesList))/(avgFPSEndTime - avgFPSStartTime));

heds_show_blankscreen(128);

% Please uncomment to close SDK at the end:
% heds_close_slm
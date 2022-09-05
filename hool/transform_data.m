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
% Loads an RGB image file into a data handle, applies some transformations 
% (shift x, y, and scale in x and y), and shows it on the SLM.

% Import SDK:
add_heds_path;

% Check if the installed SDK supports the required API version
heds_requires_version(3);

% Make some enumerations available locally to avoid too much code:
heds_types;

% Detect SLMs and open a window on the selected SLM:
heds_slm_init;

% Open the SLM preview window in "Fit" mode:
% Please adapt the file show_slm_preview.m if preview window
% is not at the right position or even not visible.
show_slm_preview(0.0);

% Load image file data to GPU:
filename = strcat( fileparts(mfilename('fullpath')), '/data/RGBCMY01.png' );
handle = heds_load_data_fromfile(filename);

% Wait for the data to be processed internally to speed up the heds_show_datahandle(handle) call later:
heds_datahandle_waitfor(handle, heds_state.ReadyToRender);

% Make the data with overlay visible on SLM screen without any transform:
heds_show_datahandle(handle.id, heds_showflags.Auto);


% Wait 2 seconds until we apply transformations to make the loaded data visible first:
heds_utils_wait_s(2.0);

% Now, after loadData(), we apply values to the transform parameters of the handle:
handle.transformShiftX = heds_slm_width_px/4;
handle.transformShiftY = heds_slm_height_px/4;
handle.transformScale = .5;

% Apply the transform values from the handle structure to the SLM Display SDK.
% This will take effect on SLM screen directly, because we made the handle visible before applying values.
% Of course we also can apply the parameters before showing the handle on screen.
% We explicitly pass which values to apply by using the "heds_datahandle_applyvalue" flags:
heds_datahandle_apply(handle, heds_datahandle_applyvalue.Transform)

% Now the data should have changed by our transformations.

% Please uncomment to close SDK at the end:
% heds_close_slm

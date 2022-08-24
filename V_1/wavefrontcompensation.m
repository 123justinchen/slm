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
% Loads a demo wavefront compensation file and shows it on the SLM.

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
% The additional flag HEDSSLMPF_ShowWavefrontCompensation presses the
% button to show the wavefront compensation in preview window from code.
show_slm_preview(0.0, heds_slmpreview_flags.ShowWavefrontCompensation);

% Configure the blank screen:
grayValue = 128;

% Set the used incident laser wavelength in nanometer:
laser_wavelength_nm = 532.0;


% Show gray value on SLM:
heds_show_blankscreen(grayValue);


% Load the wavefront compensation. Depending on your build setup, in some cases the relative path may not work.
% The demo file does not compensate any device correctly. It just adds a HOLOEYE logo into the addressed image.
heds_slm_wavefrontcompensation_load('data/wfcdemo_holoeye_logo.h5', laser_wavelength_nm, heds_wavefrontcompensationflags.None, 0, 0);

% Please uncomment to close SDK at the end:
% heds_close_slm


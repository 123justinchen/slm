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
% Uses the built-in blank screen function to show a given grayscale value on the full SLM.
% Then we use the Zernike functions as an overlay.

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
% The additional flag ShowZernikeRadius presses the button to
% show the Zernike radius visualization in preview window from code.
show_slm_preview(0.0, heds_slmpreview_flags.ShowZernikeRadius);

% Configure the blank screen:
grayValue = 128

% Show gray value on SLM without using a handle:
heds_show_blankscreen(grayValue);

zernikeRadius = heds_slm_height_px / 2.0 + 0.5  % default Zernike radius in HOLOEYE Pattern Generator

% zernikeDataVector consists of:
% index 1: Zernike radius in pixel.
% index 2: tip (blazed grating with deviation ix x-direction).
% index 3: tilt (blazed grating with deviation ix y-direction).
% index 4: second order astigmatism.
% index 5: defocus (r^2), has the same effect like a lens.
% ...
% The vector does not need to hold all elements, it just must have the size up to the last non-zero element, e.g.
%zernikeDataVector = [zernikeRadius, 1.0, -1.0, 0.0, 1.0];

% We also can create the vector in more general way and set the Zernike coefficients by their names:
zernikeDataVector = zeros(heds_zernike_values.COUNT, 1, 'single');
zernikeDataVector(heds_zernike_values.RadiusPx) = zernikeRadius;  % default is half diagonal of SLM in pixel.
zernikeDataVector(heds_zernike_values.TiltX) = 0.2;
zernikeDataVector(heds_zernike_values.TiltY) = 0.1;
zernikeDataVector(heds_zernike_values.Defocus) = 1.0;
zernikeDataVector(heds_zernike_values.ComaX) = 0.25;

heds_slm_zernike(zernikeDataVector);
disp('Zernike values were applied successfully. Waiting for 5 seconds ...');

% Caution: When not resetting applied Zernike values, these values will perist until the SDK is reinitialized.
% To make sure running other functions on the SLM after this script was executed, we clear the Zernike values after a delay.
% Please remove this if you want to see the result for an unlimited duration:

heds_utils_wait_s(5);

% Clear Zernike values
heds_slm_zernike(0);
disp('Zernike values were reset to defaults after waiting 5 seconds.');



% Please uncomment to close SDK at the end:
% heds_close_slm

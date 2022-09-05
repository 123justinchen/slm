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
% Calculates a lens with speed-optimized code and shows it on the SLM.

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

% Configure the lens properties:
innerRadius = heds_slm_height_px / 3
centerX = 0
centerY = 0

% Calculate the phase values of a lens in a pixel-wise matrix using matrix 
% multiplications to optimize for calculation speed:

%pre-calc. helper variables:
phaseModulation = 2*pi;
dataWidth = heds_slm_width_px
dataHeight = heds_slm_height_px

x = (1:dataWidth) - dataWidth/2 - centerX;
x2 = single(x.*x);
  
y = (1:dataHeight) - dataHeight/2 + centerY;
y2 = y.*y;
y2 = single(y2');

% Calculate phase data matrix:
phaseData = single(phaseModulation) * (ones(dataHeight, 1, 'single')*x2 + y2*ones(1, dataWidth, 'single')) / single(innerRadius*innerRadius);

% Show data on the SLM:
heds_show_phasevalues(phaseData)

% Please uncomment to close SDK at the end:
% heds_close_slm
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
% Calculates an axicon and shows it on the SLM.

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

% Configure the axicon properties:
innerRadius = heds_slm_height_px / 3
centerX = 0
centerY = 0

% Calculate the phase values of an axicon in a pixel-wise matrix:

%pre-calc. helper variables:
phaseModulation = 2*pi;
dataWidth = heds_slm_width_px
dataHeight = heds_slm_height_px
dataWidth_2 = dataWidth / 2;
dataHeight_2 = dataHeight / 2;

% Reserve memory for the phase data matrix.
% Use data type single to optimize performance:
phaseData = zeros(dataHeight, dataWidth, 'single');

% Fill the phaseData matrix:
% Warning: "for"-loops are very slow when using Octave, 
% please refer to "axicon_fast.m" for improvements.
for y = 1:dataHeight
    y2 = (y - dataHeight_2 + centerY) ^ 2;
    for x = 1:dataWidth
        x2 = (x - dataWidth_2 - centerX) ^ 2;
        r = sqrt(x2 + y2);
        phaseData(y, x) = phaseModulation * r / innerRadius;
    end
end

% Show the matrix of phase values on the SLM:
heds_show_phasevalues(phaseData);

% Please uncomment to close SDK at the end:
% heds_close_slm
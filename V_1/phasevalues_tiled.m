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
% Shows a 1d vector of phase values with data type float (single) on the SLM.
% The phase values have a range from 0 to 2pi, non-fitting values will be wrapped automatically on the GPU.
% We use the show-flags to replicate (tile) the 1d vector to the full SLM size.

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

% Calculate e.g. a horizontal blazed grating column:
blazePeriod = 77

phaseModulation = 2*pi; % radian
dataWidth = blazePeriod
dataHeight = 1
phaseData = zeros(dataHeight, dataWidth, 'single');

% Calculate phase data. The values are calculated in unit radian without any wrapping:
for x = 1:dataWidth
  grayValue = phaseModulation * (x-1) / blazePeriod;
  phaseData(x) = grayValue;
end

% Show phase data on the SLM:
heds_show_phasevalues(phaseData, heds_showflags.TiledCentered)

% Please uncomment to close SDK at the end:
% heds_close_slm

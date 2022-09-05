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
% Shows a 2d matrix of phase values with data type float (single) on the SLM.
% The phase values have a range from 0 to 2pi, non-fitting values will be wrapped automatically on the GPU.

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

% Calculate e.g. a vertical blazed grating:
blazePeriod = 77

phaseModulation = 2*pi; % radian
dataWidth = heds_slm_width_px
dataHeight = heds_slm_height_px
phaseData = zeros(dataHeight, dataWidth, 'single');


% Calculate phase data. The values are calculated in unit radian without any wrapping:
% Warning: "for"-loops are very slow when using Octave, 
% please refer to "axicon_fast.m" for improvements.
for x = 1:dataWidth
  grayValue = phaseModulation * (x-1) / blazePeriod;
  for y = 1:dataHeight
    phaseData(y, x) = grayValue;
  end
  % phaseData(:,x) = grayValue; % faster but less general
end

% Show phase data on SLM:
heds_show_phasevalues(phaseData)

% Please uncomment to close SDK at the end:
% heds_close_slm

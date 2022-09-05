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
% Shows a 1d vector of grayscale data with data type uint8 (byte) on the SLM.
% The gray values have a range from 0 to 255, non-fitting values will be cropped by MATLAB/Octave.
% We use the show-flags to replicate (tile) the 1d vector to the full SLM size.

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

% Calculate e.g. a horizontal blazed grating column:
blazePeriod = 77

% Reserve memory for the data:
dataWidth = blazePeriod
dataHeight = 1
data = zeros(dataHeight, dataWidth, 'uint8');

% Calculate the data:
for x = 1:dataWidth
  grayValue = 256 * mod(x-1, blazePeriod) / blazePeriod;
  data(x) = grayValue;
end

% Show data on SLM:
heds_show_data(data, heds_showflags.TiledCentered)

% Please uncomment to close SDK at the end:
% heds_close_slm

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
% Uses the built-in functions to split the SLM in two halfs with two different gray values.
% This can be useful for example for phase measurements and calibration.

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

% Configure divided screen:
grayValueA = 0
grayValueB = 255
screenDivider = 0.5
flipped = false
vertical = true

% Show divided screen on SLM:
if (vertical),
  heds_show_dividedscreen_vertical(grayValueA, grayValueB, screenDivider, flipped)
else
  heds_show_dividedscreen_horizontal(grayValueA, grayValueB, screenDivider, flipped)
end

% Please uncomment to close SDK at the end:
% heds_close_slm
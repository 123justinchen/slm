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
% Uses the built-in function to show a binary grating on the SLM.

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

% Configure binary grating:
widthA = 4
widthB = 4
grayValueA = 0
grayValueB = 128 % gray level 128 means 1 pi radian phase shift on a 2 pi radian SLM
shift = 0
vertical = true

% Show binary grating on SLM:
if (vertical),
  heds_show_grating_vertical_binary(widthA, widthB, grayValueA, grayValueB, shift)
else
  heds_show_grating_horizontal_binary(widthA, widthB, grayValueA, grayValueB, shift)
end

% Please uncomment to close SDK at the end:
% heds_close_slm
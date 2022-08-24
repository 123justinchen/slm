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
% This function prints some statistics of a list of data handles.
% It is not meant to be a self-contained example script, but is used by the 
% slideshow_precalculate.m example of the HOLOEYE SLM Display SDK.

function printStat(dataHandles, stat)
    sum = 0.0;
    count = 0;
    min = 10000;
    max = -10000;

    for i = 1:length(dataHandles)
        % get the stat from the handle
        v = getfield(dataHandles{i}, stat);

        % check if this action did happen at all
        if ~isscalar(v)
            continue
        end

        % process value
        sum = sum + single(v);
        count = count + 1;

        if v < min
            min = v;
        end    

        if v > max
            max = v;
        end
    end    

    % check if any handle did this action
    if count > 0 && max >= 0
        avg = sum / count;

        disp(sprintf('%-24s -> min: %-3d  -  avg: %6.2f  -  max: %-3d', stat, min, avg, max))
    else
        disp(sprintf('%-24s -> min: n/a  -  avg:   n/a   -  max: n/a', stat))
    end    
end
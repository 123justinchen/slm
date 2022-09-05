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
% listOfFoundFiles = listFiles(base_path, fileEndings)
% 
% Lists all files matching fileEndings in a single folder.
% If fileEndings is empty, all files are returned.
% listOfFoundFiles and fileEndings is expected to be a cell array of strings.

function listOfFoundFiles = listFiles(base_path, fileEndings)
    
    % Allow no backslash
    base_path = strrep(base_path, '\', '/');
    
    % Search files in given folder:
    isMATLAB = 1;  %~(exist ('OCTAVE_VERSION', 'builtin') > 0);
    j = 0;
    listOfFoundFiles = {};
    
    % Make file extensions consistent (add a '.' to the given endings):
    if ( iscell(fileEndings) && ~isempty(fileEndings) )
        for k = 1:length(fileEndings)
            fileEndings{k} = strcat('.', lower(fileEndings{k}));
        end
    end

    foundFiles = dir(base_path);
    for i = 1:length(foundFiles)
        filename = foundFiles(i).name;
        if strcmp(filename, '.'), continue; end
        if strcmp(filename, '..'), continue; end
        if ~(foundFiles(i).isdir) %foundFiles{i} is not a subdir
            
            [filepath, filebase, fileext] = fileparts(filename);
            isCorrectFileEnding = false;
            if iscell(fileEndings)
                if (~isempty(fileEndings))
                    for k = 1:length(fileEndings)
                        if strcmpi(fileext, fileEndings{k})
                            isCorrectFileEnding = strcmpi(fileext, fileEndings{k});
                            break;
                        end
                    end
               else
                    isCorrectFileEnding = true;
               end
                
            else
                isCorrectFileEnding = false;
            end
                
            if isCorrectFileEnding
                j = j+1;
                listOfFoundFiles{j} = [base_path, '/', filename];
            end
        end
    end
    
end



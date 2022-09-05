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
% This code adds the HOLOEYE SLM Display SDK installation path to MATLAB's (Octave's) search path.
% 
% Please make sure that the mex files inside the added folder are properly compiled.
% Under MATLAB, the mexw64 files are shipped with the installer, so there is no need to recompile anything on the win64 platform.
% When using MATLAB in the 32-bit version, you will need to compile these mex files. To do this, you need to install an appropriate 
% compiler. See MATLAB documentation about supported compilers.
% For Octave, the mex files are generated for the selected Octave installation during the SDK installation process.
% If you want to use the SDK from another Octave version on your computer, you need to recompile these mex files.
% 
% MEX file compilation can be done by running the script
% heds_build_sdk_mex_files
% which is installed into the win64 and win32 folders.

% Read environment variable:
if (exist ('OCTAVE_VERSION', 'builtin') > 0)
  env_path = getenv('HEDS_3_OCTAVE');
else
  env_path = getenv('HEDS_3_MATLAB');
end
  
% Determine the binary to use
if ispc()
  arch = computer('arch');
  if strcmp( arch(end-1:end), '64' )
    binary_path = '/win64';
  else
    binary_path = '/win32';
  end
else
  binary_path = '/linux';
end

if isempty(env_path)
  heds_path = '';
else
  heds_path = strcat(env_path, binary_path);
end

% Check the linux install folder
if ~ispc() && (isempty(heds_path) || exist (heds_path, 'dir') ~= 7)
  heds_path = '/usr/share/holoeye-slmdisplaysdk/sdk';
end

% Check if the path exists
if isempty(heds_path) || exist (heds_path, 'dir') ~= 7
  currentdir = fileparts(mfilename('fullpath'));
  
  heds_path = sprintf('%s/bin%s', currentdir, binary_path);
end

if  isempty(heds_path) || exist (heds_path, 'dir') ~= 7
  heds_path = sprintf('%s/../../bin%s', currentdir, binary_path);
end

% Figure out if heds_path could be found and if yes, add to MATLAB path:
if (exist (heds_path, 'dir')) == 7
  addpath(heds_path);
else
  if ispc()
    fprintf(2, '\nError: Could not find HOLOEYE SLM Display SDK installation path from environment variable. \n\nPlease relogin your Windows user account and try again. \nIf that does not help, please reinstall the SDK and then relogin your user account and try again. \nA simple restart of the computer might fix the problem, too.\n');
  else
    fprintf(2, '\nError: Could not detect HOLOEYE SLM Display SDK installation path. \n\nPlease make sure it is correctly installed.\n');
  end

  return;
end

% Make sure we find the library functions
if ~ispc()
   addpath('..'); 
end
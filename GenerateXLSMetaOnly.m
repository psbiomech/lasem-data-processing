%% RUN BODY BUILDER DATA EXTRACTION
%   Prasanna Sritharan, April 2018
% 
% -------------------------------------------------------------------- 
%     Copyright (C) 2018 Prasanna Sritharan
%     Copyright (C) 2018 La Trobe University
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
% -------------------------------------------------------------------- 


clc; 

disp('C3D BODY BUILDER DATA EXTRACTION');
disp('Prasanna Sritharan, June 2017');
disp(' ');
disp([datestr(now) ': Execution commenced.']);
disp(' ');
disp(' ');
disp('===========================================================');
disp(' ');



%% ********************
% SCRIPT SETTINGS

% get user script settings
disp('Retrieving script settings...');
user = getUserScriptSettings();

% get Body Builder defaults
disp('Retrieving Body Builder C3D metadata...');
bbmeta = getBBmeta(); 



%% ********************
% CREATE DATA STRUCT

disp(' ');

% generate C3D file list
disp('Generating list of available C3D files matching file name format...');
[flist,fnames,subtri] = generateFileList(user);

% add additional information about trial (metadata)
disp('Writing subject and trial metadata and settings to XLS...');
bb = getSubjTrialMeta(flist,subtri,bbmeta,user,'writexls');



%% ********************

disp(' ');
disp([datestr(now) ': Execution complete.']);
disp('-----------------------------------------------------------');
disp(' ');
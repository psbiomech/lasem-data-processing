function user = getUserScriptSettings()


%getUserScriptSettings: User settings for script
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


% folder paths
user.DATASRCPATH = 'C:\Users\psrit\Documents\data\FORCe Running\';  % root directory of source C3D files with Body Builder data
user.SUMMARYPATH = 'C:\Users\psrit\Documents\data\FORCe Running\SUMMARY\';   % location to which all output data summary files are written
user.XLSMETAPATH = 'C:\Users\psrit\Documents\data\FORCe Running\';   % if used, read.write location of XLS file with subject/trial metadata

% data processing settings
user.SAMP = 101;    % resample data to standardised number of time steps
user.AMPG = [1 1 1 1];   % what Body Builder data to extract from C3D file: angles, moments, powers, GRFs (1=yes,0=no)
user.FILESELECTMODE = 'auto';   % 'auto': process C3D files matching file name format, 'manual': manually select which files to process
user.TASKTYPE = 'run-stance-predefined-limb';   % activity/task/motion type code
user.COHORTSUBFOLDERS = {'Symptomatics','Control'};     % format: {test folder name, control folder name}, set to empty [] if not used

% C3D file name parameters
% (form: [SUBJECTPREFIX][CTRLPREFIX][2-digit numeric][SEPARATOR][TRIALPREFIX][2-digit numeric].c3d)
user.SUBJECTPREFIX = 'FAILT';   % subject code prefix (eg. for subject code FAILT01, the subjectprefix is 'FAILT')
user.CTRLPREFIX = 'CRT';    % for Mark Scholes running data only
user.TRIALPREFIX = 'Run';  % trial code prefix (eg. for trial code WALK01, the trialprefix is 'WALK')
user.SEPARATOR = '_';   % file name separator between subject code and trial code (eg. for file FAILT01_WALK01.c3d, the separator is '_')

% default settings for automatic processing of data
user.COHORT = 'auto';    % cohort type (aff/con/auto/manual/upload), auto will set cohort based on cohort subfolder
user.AFFECTED = 'Z';    % affected limb (L/R/C/Z), z indicates that the affected leg is not set, and will need to be done later via file upload

% updating metadata via file upload
user.UPDATEMETAFROMFILE = 'update';  % update subject metadata from XLS file (update/noupdate)
user.WRITEMETATOFILE = 'write';    % write subject metadata to XLS file (write/nowrite)
user.XLSMETAUPLOADFILE = 'force_running_subject_metadata.xlsx';
user.XLSMETAWRITEFILE = 'force_running_subject_metadata_updated.xlsx';


end


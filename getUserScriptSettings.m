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


% data root
user.DATASRCPATH = 'C:\Users\psrit\Documents\data\Force Running\';  % root directory of source C3D files with Body Builder data

% subfolders
user.SUMMARYSF = 'SUMMARY';   % summary files subfolder
user.XLSMETASF = 'META';   % metadata subfolder
user.ERRORSF = 'ERROR';      % error logs subfolder

% task
user.TASKTYPE = 'run-swing-predefined-limb';   % activity/task/motion type code
user.TASKSHORT = 'run-swing';   % abbreviated name for task, used for Excel file names

% full subfolder paths based on TASKSHORT
user.SUMMARYPATH = fullfile(user.DATASRCPATH,['zz-' user.TASKSHORT],user.SUMMARYSF);   % location to which all output data summary files are written
user.XLSMETAPATH = fullfile(user.DATASRCPATH,['zz-' user.TASKSHORT],user.XLSMETASF);   % if used, write location of XLS file with subject/trial metadata
user.ERRORPATH = fullfile(user.DATASRCPATH,['zz-' user.TASKSHORT],user.ERRORSF);      % write location of error output logs

% data processing settings
user.SAMP = 101;    % resample data to standardised number of time steps
user.AMPG = [1 1 1 1];   % what Body Builder data to extract from C3D file: angles, moments, powers, GRFs (1=yes,0=no)
user.FILESELECTMODE = 'auto';   % 'auto': process C3D files matching file name format, 'manual': manually select which files to process
user.COHORTSUBFOLDERS = {'Symptomatics','Control'};     % format: {test folder name, control folder name}, set to empty [] if not used
user.CALCSPEED = 'yes';     % flag to calculate trial speed (yes/no)
user.SPEEDMARKER = 'SACR';      % trial speed marker
user.EXPORTSPEEDS = 'yes';      % flag to indicate whether to write speeds to XLS (yes/no)

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
% Note: To upload metadata from spreadsheet, place the spreadsheet
% XLSMETAUPLOADFILE in folder DATASRCPATH and set
% UPDATEMETAFROMFILE='update'. Refer to function loadXLSmeta() for the 
% spreadsheet format. If WRITEMETATOFILE='write', these processing scripts
% automatically also output a spreadsheet XLSMETAWRITEFILE which can be 
% used for future metadata upload or as a template for manually creating a 
% new one. To use this auto generated spreasheet for future upload, copy it
% from XLSMETAPATH to DATASRCPATH, rename it to be XLSMETAUPLOADFILE and
% set UPDATEMETAFROMFILE='update'.
user.UPDATEMETAFROMFILE = 'update';  % update subject metadata from XLS file (update/noupdate)
user.WRITEMETATOFILE = 'write';    % write subject metadata to XLS file (write/nowrite)
user.XLSMETAUPLOADFILE = [upper(user.SUBJECTPREFIX) '_' upper(user.TRIALPREFIX) '_subject_metadata.xlsx'];     % input file containing metadata to be read from Excel spreadsheet into struct
user.XLSMETAWRITEFILE = [upper(user.SUBJECTPREFIX) '_' upper(user.TRIALPREFIX) '_subject_metadata.xlsx'];      % output file for writing metadata from struct to Excel spreadheet


end


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
user.DATASRCPATH = 'C:\Users\psritharan\Documents\98 Data Repository\Lasem Sample Data\Baseline\';  % root directory of source C3D files with Body Builder data
user.SUMMARYPATH = 'C:\Users\psritharan\Documents\98 Data Repository\Lasem Sample Data\SUMMARY\';   % location to which all output data summary files are written
user.XLSMETAPATH = 'C:\Users\psritharan\Documents\98 Data Repository\Lasem Sample Data\XLSMETA\';   % if used, read.write location of XLS file with subject/trial metadata

% data processing settings
user.SAMP = 100;    % resample data to standardised number of time steps
user.AMPG = [1 1 1 1];   % what Body Builder data to extract from C3D file: angles, moments, powers, GRFs (1=yes,0=no)
user.FILESELECTMODE = 'auto';   % 'auto': process C3D files matching file name format, 'manual': manually select which files to process
user.TASKTYPE = 'walk-stance-both';   % activity/task/motion type code
user.UPDATEMETA = 'update';  % update subject cohort and affected limb via XLS (update/noupdate)

% C3D file name parameters
% (form: [SUBJECTPREFIX][2-digit numeric][SEPARATOR][TRIALPREFIX][2-digit numeric].c3d)
user.SUBJECTPREFIX = 'FAILT';   % subject code prefix (eg. for subject code FAILT01, the subjectprefix is 'FAILT')
user.TRIALPREFIX = 'WALK';  % trial code prefix (eg. for trial code WALK01, the trialprefix is 'WALK')
user.SEPARATOR = '_';   % file name separator between subject code and trial code (eg. for file FAILT01_WALK01.c3d, the separator is '_')

% default settings for automatic processing of data
% (use this to preset cohort and affected leg to a default value for all
% subjects, then manually update the info for each individual subject
% using XLS upload function)
user.COHORT = 'aff';    % cohort type (aff/con)
user.AFFECTED = 'r';    % affected limb (l,r or c)



end


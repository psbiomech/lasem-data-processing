function user = getUserScriptSettings()


%  getUserScriptSettings: User settings for script
%   Prasanna Sritharan, August 2017
% 
% -------------------------------------------------------------------- 
%     Copyright (C) 2017 Prasanna Sritharan
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


user.DATAPATH = 'C:\Users\psritharan\Documents\98 Data Repository\Lasem Sample Data\Baseline\';     % location of source data
user.INPUTPATH = 'C:\Users\psritharan\Documents\98 Data Repository\Lasem Sample Data\INPUT';    % location of input XLS file (if used)
user.OUTPUTPATH = 'C:\Users\psritharan\Documents\98 Data Repository\Lasem Sample Data\OUTPUT';    % location to which all output files are written
user.SAMP = 100;    % desired number of samples
user.FILESELECTMODE = 'auto';   % 'auto': keep all files matching name format, 'manual': manually select which files to keep
user.TASKTYPE = 'walk-stance';   % activity/task/motion type code
user.AMPG = [1 1 1 1];   % angle, moment, power, GRFs
user.SUBJECTPREFIX = 'FAILT';   % subject code prefix (eg. for subject code FAILT01, the subjectprefix is 'FAILT')
user.TRIALPREFIX = 'WALK';  % trial code prefix (eg. for trial code WALK01, the trialprefix is 'WALK')
user.SEPARATOR = '_';   % file name separator between subject code and trial code (eg. for file FAILT01_WALK01.c3d, the separator is '_')
user.COHORT = 'aff';    % cohort type (affected/control)
user.AFFECTED = 'r';    % affected limb (left/right, or control)
user.WRITEXLS = 'xls';  % write settings and meta to Excel spreadsheet
user.INPUTTYPE = 'struct';  % get settings/meta data from Excel or struct



end


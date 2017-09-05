function user = getUserScriptSettings()


%getScriptSettings User settings for script
%   Prasanna Sritharan, August 2017

user.DATAPATH = 'C:\Users\Prasanna\Documents\Test Data\';     % location of source data
user.INPUTPATH = 'C:\Users\Prasanna\Documents\Test Data\INPUT';    % location of input XLS file (if used)
user.OUTPUTPATH = 'C:\Users\Prasanna\Documents\Test Data\OUTPUT';    % location to which all output files are written
%user.DATAPATH = 'C:\Users\psritharan\Documents\98 Data Repository\Lasem Sample Data\Baseline';     % location of source data
%user.INPUTPATH = 'C:\Users\psritharan\Documents\98 Data Repository\Lasem Sample Data\INPUT';    % location of input XLS file (if used)
%user.OUTPUTPATH = 'C:\Users\psritharan\Documents\98 Data Repository\Lasem Sample Data\OUTPUT';    % location to which all output files are written
user.SAMP = 100;    % desired number of samples
user.FILESELECTMODE = 'auto';   % 'auto': keep all files matching name format, 'manual': manually select which files to keep
user.TASKTYPE = 'sldj';   % activity/task/motion type code
user.AMPG = [1 1 1 1];   % angle, moment, power, GRFs
user.TRIALPREFIX = 'SLDJ';  % trial code prefix (eg. for trial code WALK01, the trialprefix is 'WALK')
user.SUBJECTPREFIX = 'FAILT';   % subject code prefix (eg. for subject code FAILT01, the subjectprefix is 'FAILT')
user.SEPARATOR = '_';   % file name separator between subject code and trial code (eg. for file FAILT01_WALK01.c3d, the separator is '_')
user.COHORT = 'aff';    % cohort type (affected/control)
user.AFFECTED = 'r';    % affected limb (left/right, or control)
user.WRITEXLS = 'xls';  % write settings and meta to Excel spreadsheet
user.INPUTTYPE = 'struct';  % get settings/meta data from Excel or struct



end


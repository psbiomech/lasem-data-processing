%% RUN BODY BUILDER DATA EXTRACTION
% Prasanna Sritharan, June 2017




% ------------------------------------------------------------
% Script Settings

%FILEROOT = 'C:\Users\Prasanna\Documents\Git Repositories\lasem-data-processing\';
FILEROOT = 'C:\Users\psritharan\Documents\03 Projects\lasem-data-processing\';

SAMP = 100;     % desired samples
FILESELECTMODE = 'auto';        % 'auto': keep all files matching name format, 'manual': manually select which files to keep

TASK = 'walk-stance';   % activity/task/motion type
AMPG = [1 1 1 1];   % angle, moment, power, GRFs

C3DNAMEFORMAT = {'FAILT','_','WALK'};   % {[Subject name prefix],[Separator],[Trial name prefix]}
C3DROOT = FILEROOT;     % full path of data root folder

COHORT = 'aff';      % cohort type (affected/control)
AFFECTED = 'r';    % affected limb (left/right, or control)
WRITEXLS = 'xls';       % write settings and meta to Excel spreadsheet
SETNAME = 'SLDJ_Input'; % settings file name
SETPATH = FILEROOT;    % full path of required Excel file location

INPUTTYPE = 'struct';      % get settings/meta data from Excel or struct
BBNAME = 'bb';

XLSPREFIX = 'SLDJ';       % output Excel spreadsheet name
XLSPATH = FILEROOT;    % full path of required Excel file location

BBFILENAME = 'SLDJ.mat';     % output MAT file name
BBFILEPATH = FILEROOT;    % full path of required MAT file location
% ------------------------------------------------------------





clc; 

disp('C3D BODY BUILDER DATA EXTRACTION');
disp('Prasanna Sritharan, June 2017');
disp(' ');
disp([datestr(now) ': Execution commenced.']);
disp(' ');
disp(' ');
disp('===========================================================');
disp(' ');


% get Body Builder defaults
disp('Retrieving Body Builder C3D metadata...');
bbmeta = getBBmeta(); 

% generate C3D file list
% (assumes file names of form: [SUBJPREFIX][SUBJCODE][SEPARATOR][TRIALPREFIX][TRIALCODE].c3d)
disp('Generating list of available C3D files matching file name format...');
[flist,fnames,subtri] = generateFileList(C3DROOT,C3DNAMEFORMAT,FILESELECTMODE);

% add additional information about trial (metadata)
disp('Generating subject and trial metadata and settings...');
bb = getSubtriMeta(flist,subtri,bbmeta,TASK,COHORT,AFFECTED,WRITEXLS,SETNAME,SETPATH);
    
% pull raw Body Builder data into a struct, trim and resample
disp('Extracting Body Builder data from C3D files...');
bb = extractBBdata(INPUTTYPE,bb,bbmeta,AMPG,SAMP,SETPATH);

% run additional analyses on Body Builder data
disp('Running additional analyses on Body Builder data...');
bb = runBBanalyses(bb,bbmeta);

% calculate mean and sd for BB data
disp('Calculating means and standard deviations for Body Builder data...');
bb = calcBBmean(bb,bbmeta,AMPG);

% % write mean data to Excel spreadsheet from Body Builder struct
% disp('Writing data to Excel spreadsheet...');
% writeBBstructToXLSMean(bb,bbmeta,XLSPREFIX,XLSPATH,SAMP);
% 
% % save Body Builder struct
% disp('Saving data as Matlab struct...');
% saveBBstruct(bb,BBFILENAME,BBFILEPATH);


disp(' ');
disp([datestr(now) ': Execution complete.']);
disp('-----------------------------------------------------------');
disp(' ');
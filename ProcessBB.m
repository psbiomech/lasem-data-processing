%% RUN BODY BUILDER DATA EXTRACTION
% Prasanna Sritharan, June 2017




% ------------------------------------------------------------
% Script Settings

%FILEROOT = 'C:\Users\Prasanna\Documents\Git Repositories\lasem-data-processing\';
FILEROOT = 'C:\Users\psritharan\Documents\03 Projects\';

SAMP = 100;     % desired samples
FILESELECTMODE = 'auto';        % 'auto': keep all files matching name format, 'manual': manually select which files to keep

TASK = 'walk-stance';   % activity/task/motion type
AMPG = [1 1 1 1];   % angle, moment, power, GRFs
FM = [1 0];      % GRF, EMG

C3DNAMEFORMAT = {'FAILT','_','WALK'};   % {[Subject name prefix],[Separator],[Trial name prefix]}
C3DROOT = FILEROOT;     % full path of data root folder

COHORT = 'aff';      % cohort type (affected/control)
AFFECTED = 'r';    % affected limb (left/right, or control)
TLMODE = 'auto';   % trial limb (left/right)
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
disp('Retrieving Body Builder default parameters...');
bbmeta = getBBmeta();
    

% generate C3D file list
% (assumes file names of form:
% [SUBJPREFIX][SUBJCODE][SEPARATOR][TRIALPREFIX][TRIALCODE].c3d)
disp('Generating list of available C3D files matching file name format...');
[flist,fnames,subtri] = generateFileList(C3DROOT,C3DNAMEFORMAT,FILESELECTMODE);


% add additional information about trial (metadata)
disp('Generating subject and trial metadata and settings...');
bb = getSubtriMeta(flist,subtri,bbmeta,TASK,COHORT,AFFECTED,TLMODE,WRITEXLS,SETNAME,SETPATH);

    
% pull raw Body Builder data into a struct, trim and resample
disp('Extracting Body Builder data from C3D files...');
bb = extractBBdata(INPUTTYPE,bb,bbmeta,AMPG,FM,SAMP,SETPATH);


% % calculate mean and sd per subject from Body Builder struct
% disp('Calculating subject means and standard deviations...');
% bb = meanBBsubject(bb,bbmeta,AMPG);
% 
% 
% % write mean data to Excel spreadsheet from Body Builder struct
% disp('Writing data to Excel spreadsheet...');
% writeBBstructToXLSMean(bb,bbmeta,XLSPREFIX,XLSPATH,SAMP);
% 
% 
% % save Body Builder struct
% saveBBstruct(bb,BBFILENAME,BBFILEPATH);


disp(' ');
disp([datestr(now) ': Execution complete.']);
disp('-----------------------------------------------------------');
disp(' ');
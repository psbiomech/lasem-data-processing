%% RUN BODY BUILDER DATA EXTRACTION
% Prasanna Sritharan, June 2017



clc; 

disp('C3D BODY BUILDER DATA EXTRACTION');
disp('Prasanna Sritharan, June 2017');
disp(' ');
disp([datestr(now) ': Execution commenced.']);
disp(' ');
disp(' ');
disp('===========================================================');
disp(' ');


% get user script settings
disp('Retrieving script settings...');
user = getScriptSettings();

% get Body Builder defaults
disp('Retrieving Body Builder C3D metadata...');
bbmeta = getBBmeta(); 

% generate C3D file list
disp('Generating list of available C3D files matching file name format...');
[flist,fnames,subtri] = generateFileList(user);

% add additional information about trial (metadata)
disp('Generating subject and trial metadata and settings...');
bb = getSubtriMeta(flist,subtri,bbmeta,user);
    
% pull raw Body Builder data into a struct, trim and resample
disp('Extracting Body Builder data from C3D files...');
bb = extractBBdata(bb,bbmeta,user);

% run additional analyses on Body Builder data
disp('Running additional analyses on Body Builder data...');
bb = runBBanalyses(bb,bbmeta);

% calculate mean and sd for BB data
disp('Calculating means and standard deviations for Body Builder data...');
bb = calcBBmean(bb,bbmeta,user);

% write mean data to Excel spreadsheet from Body Builder struct
disp('Writing data to Excel spreadsheet...');
writeBBstructToXLSMean(bb,bbmeta,user);

% save Body Builder struct
disp('Saving data as Matlab struct...');
saveBBstruct(bb,user);


disp(' ');
disp([datestr(now) ': Execution complete.']);
disp('-----------------------------------------------------------');
disp(' ');
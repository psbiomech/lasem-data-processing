%% RUN BODY BUILDER DATA EXTRACTION
% Prasanna Sritharan, June 2017




% ------------------------------
% script settings
SAMP = 100;     % desired samples
C3DROOT = 'C:\Users\psritharan\Documents\03 Projects\lasem-data-processing';     % full path of data root folder
C3DNAMEFORMAT = {'FAILT','_','WALK'};   % {[Subject name prefix],[Separator],[Trial name prefix]}
SELECTMODE = 'auto';        % 'auto': keep all files matching name format, 'manual': manually select which files to keep
XLSNAME = 'SLDJ.xlsx';       % output Excel spreadsheet name
XLSPATH = 'C:\Users\psritharan\Documents\03 Projects\lasem-data-processing';    % full path of required Excel file location
BBFILENAME = 'SLDJ.mat';     % output MAT file name
BBFILEPATH = 'C:\Users\psritharan\Documents\03 Projects\lasem-data-processing';    % full path of required Excel file location
% ------------------------------





clc; 

disp('C3D BODY BUILDER DATA EXTRACTION');
disp('Prasanna Sritharan, June 2017');
disp(' ');
disp([datestr(now) ': Execution commenced.']);
disp(' ');
disp(' ');
disp('===========================================================');
disp(' ');



% get Body Builder metadata
bbmeta = getBBmeta();
    

% generate C3D file list
% (assumes file names of form:
% [SUBJPREFIX][SUBJCODE][SEPARATOR][TRIALPREFIX][TRIALCODE].c3d)
disp('Generating list of available C3D files matching file name format...');
[flist,fnames,subtri] = generateFileList(C3DROOT,C3DNAMEFORMAT,SELECTMODE);


% pull raw Body Builder data into a struct, trim and resample
disp('Extracting Body Builder data from C3D files...');
for f=1:length(flist)
    [rawdatastruct,trialfoot,~] = pullBBpoint(flist{f},bbmeta,[1 1 1],'sldj');    
    bb.(subtri{f}{1}).(subtri{f}{2}) = resampleBBdata(rawdatastruct,SAMP);    
    bb.(subtri{f}{1}).(subtri{f}{2}).trialfoot = trialfoot;    
end


% calculate mean and sd per subject from Body Builder struct
disp('Calculating subject means and standard deviations...');
subjs = fieldnames(bb);
for s=1:length(subjs)
    [bb.(subtri{f}{1}).mean, bb.(subtri{f}{1}).sd] = meanBBsubject(bb.(subtri{f}{1}),bbmeta);
end


% write mean data to Excel spreadsheet from Body Builder struct
disp('Writing data to Excel spreadsheet...');
writeBBstructToXLS(bb,bbmeta,XLSNAME,XLSPATH,SAMP);


% save Body Builder struct
saveBBstruct(bb,BBFILENAME,BBFILEPATH);


disp(' ');
disp([datestr(now) ': Execution complete.']);
disp('-----------------------------------------------------------');
disp(' ');
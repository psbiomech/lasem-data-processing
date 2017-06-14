%% RUN BODY BUILDER DATA EXTRACTION
% Prasanna Sritharan, June 2017




% ------------------------------
% output settings
SAMP = 100;     % desired samples
%c3droot = 'C:\Users\psritharan\Documents\03 Projects\lasem-data-processing\Baseline\Sample Data';
C3DROOT = 'C:\Users\Prasanna\Documents\Git Repositories\lasem-data-processing';
SUBJPREFIX = 'FAILT';
TRIALPREFIX = '_Walk';
XLSNAME = 'WalkingData.xlsx';
XLSPATH = 'C:\Users\Prasanna\Documents\Git Repositories\lasem-data-processing\Baseline\Sample Data';
% ------------------------------




% get Body Builder metadata
bbmeta = getBBmeta();
    

% generate C3D file list
% (assumes file names of form:
% [SUBJPREFIX][SUBJCODE][TRIALPREFIX][TRIALCODE].c3d)
[flist,fnames,subtri] = generateFileList(C3DROOT,SUBJPREFIX,TRIALPREFIX,'auto');


% pull raw Body Builder data into a struct and resample
for f=1:length(flist)
    rawdatastruct = pullBBpoint(flist{f},bbmeta,[1 1 1]);
    bb.(subtri{f}{1}).(subtri{f}{2}) = resampleBBdata(rawdatastruct,SAMP);    
end


% calculate mean per subject from Body Builder struct
subjs = fieldnames(bb);
for s=1:length(subjs)
    [bb.(subtri{f}{1}).mean, bb.(subtri{f}{1}).sd] = meanBBsubject(bb.(subtri{f}{1}),bbmeta);
end


% write mean data to Excel spreadsheet from Body Builder struct
writeBBstructToXLS(bb,bbmeta,XLSNAME,XLSPATH,SAMP);
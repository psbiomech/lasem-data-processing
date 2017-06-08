%% RUN BODY BUILDER DATA EXTRACTION
% Prasanna Sritharan, June 2017


c3droot = 'C:\Users\psritharan\Documents\03 Projects\lasem-data-processing\Baseline\Sample Data';
c3dfile = 'FAILT01_Walk01';




% generate C3D file list
% (assumes file names of form:
% [SUBJPREFIX][SUBJCODE][TRIALPREFIX][TRIALCODE].c3d)
[flist,fnames,subtri] = generateFileList(c3droot,'FAILT','_Walk','auto');


% pull raw Body Builder data and resample
for f=1:length(flist)
    rawdata = pullBBpoint(flist{f},[1 1 1]);
    bb.(subtri{f}{1}).(subtri{f}{2}) = resampleBBdata(rawdata,100);    
end


% calculate mean per subject
subjs = fieldnames(bb);
for s=1:length(subjs)
    bb.(subtri{f}{1}).mean = calcMeanData(bb.(subtri{f}{1}));
end
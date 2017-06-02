%% RUN BODY BUILDER DATA EXTRACTION
% Prasanna Sritharan, June 2017


c3dpath = 'C:\Users\psritharan\Documents\03 Projects\lasem-data-processing\Baseline\Sample Data';
c3dfile = 'FAILT01_Walk01';



% pull Body Builder data from C3D
bb = pullBBpoint(c3dpath,c3dfile,[1 1 1]);

% resample Body Builder data
bb = resampleBBdata(bb,100);


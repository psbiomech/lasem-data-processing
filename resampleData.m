% RESAMPLE DATA TABLES
% Prasanna Sritharan, October 2014
%
% Resamples 2D matrices. Assumes data arranged in columns.

function resampdata = resampleData(origdata,samples)

% get dimensions
[rows,cols] = size(origdata);

% pad data
padded = [repmat(origdata(1,:),rows,1); origdata; repmat(origdata(end,:),rows,1)];

% resample padded data
newpadded = resample(padded,samples,rows);

% extract desired resampled data
resampdata = newpadded(samples+1:2*samples,:);
       
end



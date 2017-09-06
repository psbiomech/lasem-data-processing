% RESAMPLE DATA TABLES
% Prasanna Sritharan, October 2017
%
% Resamples 2D matrices. Assumes data arranged in columns.
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



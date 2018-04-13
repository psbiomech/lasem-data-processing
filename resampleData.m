function resampdata = resampleData(origdata,samples)

% resampleData: Resample timeseries data
%   Prasanna Sritharan, April 2018
% 
% -------------------------------------------------------------------- 
%     Copyright (C) 2018 Prasanna Sritharan
%     Copyright (C) 2018 La Trobe University
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


% get dimensions
[rows,cols] = size(origdata);

% pad data
padded = [repmat(origdata(1,:),rows,1); origdata; repmat(origdata(end,:),rows,1)];

% resample padded data
newpadded = resample(padded,samples,rows);

% extract desired resampled data
resampdata = newpadded(samples+1:2*samples,:);
       
end



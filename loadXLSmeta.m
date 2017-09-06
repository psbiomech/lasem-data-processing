function    bb = loadXLSmeta(xlsname,xlspath)

%  loadXLSmeta: Load settings/meta data into struct
%   Prasanna Sritharan, June 2017
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

    % add XLSX extension if necessary
    if isempty(regexpi(xlsname,'.xlsx')), xlsname = [xlsname '.xlsx']; end;  

    % load Excel file into struct
    [~,~,rawdata] = xlsread([xlspath '\' xlsname]);
    
    % build struct (assume Excel header row exists)
    bb = struct;
    for r=2:size(rawdata,1)
        if ~isfield(bb,rawdata{r,1})
            bb.(rawdata{r,1}).cohort = rawdata{r,3};
            bb.(rawdata{r,1}).affected = rawdata{r,4};
        end
        bb.(rawdata{r,1}).(rawdata{r,2}).triallimb = rawdata{r,5};
        bb.(rawdata{r,1}).(rawdata{r,2}).vfrange = [rawdata{r,6} rawdata{r,7}];
        bb.(rawdata{r,1}).(rawdata{r,2}).fpsequence = str2num(rawdata{r,8});
        bb.(rawdata{r,1}).(rawdata{r,2}).filepath = rawdata{r,9};
    end   

end


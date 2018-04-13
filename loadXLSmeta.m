function    bbstruct = loadXLSmeta(bbstruct,xlsname,xlspath)

%loadXLSmeta: Load settings/meta data into struct
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


    % add XLSX extension if necessary
    if isempty(regexpi(xlsname,'.xlsx')), xlsname = [xlsname '.xlsx']; end;  

    % load Excel file into struct
    [~,~,rawdata] = xlsread([xlspath '\' xlsname]);
    
    % update subject data in struct (assume Excel header row exists)
    for r=2:size(rawdata,1)
        bbstruct.(rawdata{r,1}).cohort = rawdata{r,2};
        bbstruct.(rawdata{r,1}).affected = rawdata{r,3};
    end   

end


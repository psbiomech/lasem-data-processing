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
%
% XLS format:
%
% Row 1: Column headers
% 
% Column 1: Subject code
% Column 2: Cohort (AFF/CON)
% Column 3: Mass
% Column 4: Height
% Column 5: Affected limb (L/R)


    % add XLSX extension if necessary
    if isempty(regexpi(xlsname,'.xlsx')), xlsname = [xlsname '.xlsx']; end  

    % load Excel file into table
    rawdata = readtable(fullfile(xlspath,xlsname));
    
    % update subject data in struct (assume Excel header row exists)
    for r=1:length(rawdata.Subject)        
        if isfield(bbstruct,rawdata.Subject{r})
        
            % cohort
            if strcmpi(bbstruct.(rawdata.Subject{r}).cohort,'update')
                bbstruct.(rawdata.Subject{r}).cohort = rawdata.Cohort{r};
            end

            % mass
            bbstruct.(rawdata.Subject{r}).mass = rawdata.Mass(r);

            % height
            bbstruct.(rawdata.Subject{r}).height = rawdata.Height(r);

            % affected limb
            if upper(bbstruct.(rawdata.Subject{r}).affected)=='Z'
                bbstruct.(rawdata.Subject{r}).affected = rawdata.Affected{r};
            end
            
        end                   
    end   
    
    
    
end


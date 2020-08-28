function writeXLSSubjInfoForMod(bbstruct,xlsname,xlspath)

%writeXLSSubjInfoForMod: Write subject data for manual modification
%   Prasanna Sritharan, April 2018
%
% Last updated: August 2020
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


    % create table
    metaout = table('Size',[0 5],'VariableTypes',{'string','string','double','double','string'},'VariableNames',{'Subject','Cohort','Mass','Height','Affected'});
              
    % collate data
    subjs = fieldnames(bbstruct);    
    for s=1:length(subjs)
        datarow = {subjs{s}, ... 
                   upper(bbstruct.(subjs{s}).cohort), ...
                   bbstruct.(subjs{s}).mass, ...
                   bbstruct.(subjs{s}).height, ...
                   upper(bbstruct.(subjs{s}).affected)};                                   
        metaout = [metaout; datarow];
    end
                                                                                

    % add XLSX extension if necessary
    if isempty(regexpi(xlsname,'.xlsx')), xlsname = [xlsname '.xlsx']; end  
    
    % write Excel spreadsheet
    writetable(metaout,fullfile(xlspath,xlsname));

end


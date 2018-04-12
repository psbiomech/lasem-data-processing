function writeXLSSubjInfoForMod(bbstruct,xlsname,xlspath)

%  writeXLSSubjInfoForMod: Write subject data for manual modification
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


    warning('off');

    
    % sheet header
    xldata(1,:) = {'subj','cohort','affected'};
        
    % collate data
    x = 2;
    subjs = fieldnames(bbstruct);    
    for s=1:length(subjs)
        xldata(x,:) = {subjs{s}, ... 
                       upper(bbstruct.(subjs{s}).cohort), ...
                       upper(bbstruct.(subjs{s}).affected)};                                   
        x = x + 1;                
    end
                                                                                

    % add XLSX extension if necessary
    if isempty(regexpi(xlsname,'.xlsx')), xlsname = [xlsname '.xlsx']; end;    
    
    % write Excel spreadsheet
    xlswrite([xlspath '\' xlsname],xldata);

end


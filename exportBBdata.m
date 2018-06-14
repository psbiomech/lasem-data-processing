function exportBBdata(bbstruct,bbmeta,user)

%exportBBdata: Export Body Builder data to Excel spreadsheets
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



    % write Body Builder mean data to Excel spreadsheets
    writeXLSMeanBBstructGroups(bbstruct,bbmeta,user);
    
    % write analysis mean data to spreadsheets
    writeXLSMeanAnalysesGroups(bbstruct,bbmeta,user);


    % write Body Builder individual trial data to spreadsheets
    writeXLSAllTrialsBBstructGroups(bbstruct,bbmeta,user);    
    
    % write analysis individual trial data to spreadsheets
    writeXLSAllTrialsAnalysesGroups(bbstruct,bbmeta,user);
    
    
    % write all metadata to Excel spreadsheet
    writeXLSFullMetaData(bbstruct,user)


end


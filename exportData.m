function exportData(bbstruct,bbmeta,user)

%EXPORTDATA: Export Body Builder and analyses data to Excel spreadsheets
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


    disp(' ');
    disp('Export data to Excel spreadsheets');
    disp('------------------------------');
    disp('(this may take some time!)');


    % write Body Builder mean data to Excel spreadsheets
    disp(' ');
    disp('Writing group means and stdevs for Body Builder data...');
    writeXLSMeanBBstructGroups(bbstruct,bbmeta,user);
    
    % write analysis mean data to spreadsheets
    disp(' ');
    disp('Writing group means and stdevs for analyses data...');
    writeXLSMeanAnalysesGroups(bbstruct,bbmeta,user);


    % write Body Builder individual trial data to spreadsheets
    disp(' ');
    disp('Writing individual Body Builder data for individual trials... (this may take some time)');
    writeXLSAllTrialsBBstructGroups(bbstruct,bbmeta,user);    
    
    % write analysis individual trial data to spreadsheets
    disp(' ');
    disp('Writing individual analyses data for individual trials...');
    writeXLSAllTrialsAnalysesGroups(bbstruct,bbmeta,user);
    
    
    % write all metadata to Excel spreadsheet
    disp(' ');
    disp('Writing full subject and trial metadata...');    
    writeXLSFullMetaData(bbstruct,bbmeta,user)

    disp(' ');
    
end


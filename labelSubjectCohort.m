function cohort = labelSubjectCohort(bbmeta,cohmode,fpath,user)


%labelSubjectCohort: Label cohort affected or control
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

    switch cohmode
        
        % manual user input of trial type (default: control)
        case 'manual'
            tcode = input(['Enter cohort (a/c) [c]: '],'s');
            tind = find(strncmpi(tcode,bbmeta.cohorts,1),1);                        
            if isempty(tind)
                cohort = upper(bbmeta.cohorts{2});
            else
                cohort = upper(bbmeta.cohorts{tind});
            end
                        
        % all trials are of the same type
        case lower(bbmeta.cohorts)
            cohort = bbmeta.cohorts{find(strcmpi(cohmode,bbmeta.cohorts),1)};
            disp(['Cohort: ' upper(cohort(1))]);
            
        % determine from database folder structure
        case 'auto'
            fnexp = ['.+(' user.COHORTSUBFOLDERS{1} '|' user.COHORTSUBFOLDERS{2} ').+'];
            cohtok = regexpi(fpath,fnexp,'tokens');
            cohort = bbmeta.cohorts{strcmp(user.COHORTSUBFOLDERS,cohtok{1}{1})};  
            
                        
    end


end


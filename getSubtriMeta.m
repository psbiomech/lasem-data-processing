function meta = getSubtriMeta(flist,subtri,bbmeta,user)


%  getSubtriMeta: Build struct of subject and trial metadata
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
    
    % assign struct fields
    task = user.TASKTYPE;
    cohmode = user.COHORT;
    affmode = user.AFFECTED;
    writexls = user.WRITEXLS;
    xlsname = [user.TRIALPREFIX '_Input'];
    xlspath = user.XLSMETAPATH;   


    % label affected limb
    disp(' ');
    meta = struct;
    for f=1:length(subtri)
        if ~isfield(meta,subtri{f}{1})
            
            % subject cohort and affected limb
            disp(['Subject: ' subtri{f}{1}]);
            disp(['==============================']);
            meta.(subtri{f}{1}).cohort = labelSubjectCohort(bbmeta,cohmode);
            meta.(subtri{f}{1}).affected = labelAffectedLimb(meta.(subtri{f}{1}).cohort,bbmeta,affmode);
                        
            % store file path, label trial limb and time window
            for g=1:length(subtri)
                if strcmpi(subtri{f}{1},subtri{g}{1})
                    disp(' ');
                    disp(['Trial: ' subtri{g}{2}]);
                    disp(['------------------------------']);
                    meta.(subtri{g}{1}).(subtri{g}{2}) = getC3Dwindow(flist{g},task,bbmeta,subtri{g}{1},subtri{g}{2});
                    meta.(subtri{f}{1}).(subtri{g}{2}).filepath = flist{g};
                end                
            end                                        
            
        else
            continue
        end       
        
        disp(' ');
        
    end
    
    % write to Excel spreadsheet
    mkdir(xlspath);
    if strcmpi(writexls,'xls')
        writeSettingsToXLS(meta,xlsname,xlspath);
    end
        
end




function meta = getSubjTrialMeta(flist,subtri,bbmeta,user,writeflag)


%getSubjTrialMeta: Build struct of subject and trial metadata
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


    warning('off');
    
    % assign struct fields
    structpath = user.DATASRCPATH;
    task = user.TASKTYPE;
    cohmode = user.COHORT;
    affmode = user.AFFECTED;
    xlspath = user.XLSMETAPATH; 
    updatemeta = user.UPDATEMETAFROMFILE;
    writemeta = user.WRITEMETATOFILE;
    xlsuploadfile = user.XLSMETAUPLOADFILE;
    xlswritefile = user.XLSMETAWRITEFILE;

    % failed
    en = 0;
    errlist = cell(0);
    
    % label affected limb
    disp(' ');
    meta = struct;
    for f=1:length(subtri)
        if ~isfield(meta,subtri{f}{1})
            
            % subject cohort and affected limb
            disp(['Subject: ' subtri{f}{1}]);
            disp(['==============================']);
            meta.(subtri{f}{1}).cohort = labelSubjectCohort(bbmeta,cohmode,flist{f},user);
            meta.(subtri{f}{1}).affected = labelAffectedLimb(meta.(subtri{f}{1}).cohort,bbmeta,affmode);
                        
            % store file path, label trial limb and time window            
            for g=1:length(subtri)
                if strcmpi(subtri{f}{1},subtri{g}{1})
                    
                    disp(' ');
                    disp(['Trial: ' subtri{g}{2}]);
                    disp(['------------------------------']);
                    
                    try
                        meta.(subtri{g}{1}).(subtri{g}{2}) = getC3Dwindow(flist{g},task,bbmeta,subtri{g}{1},subtri{g}{2});
                        meta.(subtri{f}{1}).(subtri{g}{2}).filepath = flist{g};
                        meta.(subtri{f}{1}).(subtri{g}{2}).ignore = 0;
                    catch err
                        en = en + 1;
                        disp('ERROR: Skipping C3D file.');
                        errlist{en} = [subtri{g}{1} '_' subtri{g}{2}]; 
                        meta.(subtri{f}{1}).(subtri{g}{2}).ignore = 1;
                    end                    
                    
                end                
            end                                        
            
        else
            continue
        end       
        
        disp(' ');
        
    end
    

    % update subject metadata from XLS
    if strcmpi(updatemeta,'update')
        disp('Updating subject metadata from Excel spreadsheet...');
        meta = loadXLSmeta(meta,xlsuploadfile,xlspath);
    end    
    
    % write subject metadata only to XLS
    if strcmpi(writemeta,'write')
        disp('Writing subject metadata to Excel spreadsheet...');
        if ~exist(xlspath,'dir'), mkdir(xlspath); end
        writeXLSSubjInfoForMod(meta,xlswritefile,xlspath);
    end
    
    % write errors if any
    if en>0
        fid = fopen([xlspath '\metadata_failed_' datestr(now,'yyyymmdd_HHMMSS') '.txt'],'at');
        for e=1:en
            fprintf(fid,'%s\n',errlist{e}); 
        end
        fclose(fid);
        fprintf(1,'\n\nERRORS: There are %d files that failed metadata processing.\n\n',en);
    end
       
    
    % save struct
    disp('Saving metadata struct...');
    save(fullfile(structpath,'bb.mat'),'-struct','meta');
        
end




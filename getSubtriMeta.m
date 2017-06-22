function meta = getSubtriMeta(flist,subtri,bbmeta,task,cohmode,affmode,tlmode,writexls,xlsname,xlspath)


%getSubtriMeta Build struct of subject and trial metadata
%   Prasanna Sritharan, June 2017

    % label affected limb
    disp(' ');
    meta = struct;
    for f=1:length(subtri)
        if ~isfield(meta,subtri{f}{1})
            
            % subject cohort and affected limb
            disp(['Subject: ' subtri{f}{1}]);
            disp(['------------------------------']);
            meta.(subtri{f}{1}).cohort = labelSubjectCohort(bbmeta,cohmode);
            meta.(subtri{f}{1}).affected = labelAffectedLimb(meta.(subtri{f}{1}).cohort,bbmeta,affmode);
                        
            % store file path, label trial limb and time window
            for g=1:length(subtri)
                if strcmpi(subtri{f}{1},subtri{g}{1})
                    [meta.(subtri{g}{1}).(subtri{g}{2}).vfrange,~,meta.(subtri{g}{1}).(subtri{g}{2}).triallimb] = getC3Dwindow(flist{g},task,tlmode,bbmeta,subtri{g}{1},subtri{g}{2});
                    meta.(subtri{f}{1}).(subtri{g}{2}).filepath = flist{g};
                end                
            end                                        
            
        else
            continue
        end       
        
        disp(' ');
        
    end
    
    % write to Excel spreadsheet
    if strcmpi(writexls,'xls')
        writeSettingsToXLS(meta,xlsname,xlspath);
    end
        
end




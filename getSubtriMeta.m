function meta = getSubtriMeta(subtri,bbmeta,cohmode,affmode,ttmode)


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
            
            % label trial type: symptomatic limb, asymptomatic limb, control
            for g=1:length(subtri)
                if strcmpi(subtri{f}{1},subtri{g}{1})
                    meta.(subtri{g}{1}).(subtri{g}{2}).triallimb = labelTrialLimb(subtri{g}{1},subtri{g}{2},bbmeta,ttmode);
                end                
            end
                        
        else
            continue
        end            
    end
    
end




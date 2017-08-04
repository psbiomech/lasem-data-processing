function affected = labelAffectedLimb(cohort,bbmeta,affmode)

%labelAffectedLimb Label the affected limb in patient cohort
%   Prasanna Sritharan, June 2017


    % return limb type as control if cohort is control
    if strcmpi(cohort,bbmeta.cohorts{2})
        affected = bbmeta.limbs{3};
    else
        switch affmode
            
            % manual user input of trial type (default: control)
            case 'manual'
                tcode = input(['Enter affected limb: (r/l) [r]: '],'s');
                tind = find(strcmpi(tcode,bbmeta.limbs),1);                        
                if isempty(tind)
                    affected = bbmeta.limbs{1};
                else
                    affected = bbmeta.limbs{tind};
                end

            % all trials are of the same type
            case lower(bbmeta.limbs)
                affected = bbmeta.limbs{find(strcmpi(affmode,bbmeta.limbs),1)};
                disp(['Affected limb: ' lower(affected)]);

        end

    end


end


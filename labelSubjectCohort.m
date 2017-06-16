function cohort = labelSubjectCohort(bbmeta,cohmode)


%labelSubjectCohort Label cohort affected or control
%   Prasanna Sritharan, June 2017

    switch cohmode
        
        % manual user input of trial type (default: control)
        case 'manual'
            tcode = input(['Enter cohort (a/c) [c]: '],'s');
            tind = find(strncmpi(tcode,bbmeta.cohorts,1),1);                        
            if isempty(tind)
                cohort = bbmeta.cohorts{2};
            else
                cohort = bbmeta.cohorts{tind};
            end
                        
        % all trials are of the same type
        case lower(bbmeta.cohorts)
            cohort = bbmeta.cohorts{find(strcmpi(cohmode,bbmeta.cohorts),1)};
            disp(['Enter cohort (a/c) [c]: ' lower(cohort(1))]);
                        
    end


end


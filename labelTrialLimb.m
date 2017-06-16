function trialtype = labelTrialLimb(subj,trial,bbmeta,ttmode)


%labelTrialType Label trial as left or right limb
%   Prasanna Sritharan, June 2017

    switch ttmode
        
        % manual user input of trial type (default: control)
        case 'manual'
            tcode = input(['Enter trial limb: ' subj ' ' trial ' (r/l) [r]: '],'s');
            tind = find(strcmpi(tcode,bbmeta.limbs),1);                        
            if isempty(tind)
                trialtype = bbmeta.limbs{1};
            else
                trialtype = bbmeta.limbs{tind};
            end
                        
        % all trials are of the same type
        case lower(bbmeta.limbs)
            trialtype = bbmeta.limbs{find(strcmpi(ttmode,bbmeta.limbs),1)};
            disp(['Enter trial limb: ' subj ' ' trial ' (r/l) [r]: ' lower(trialtype)]);
                        
    end
    
    
    


end


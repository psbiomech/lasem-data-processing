function triallimb = labelTrialLimb(subj,trial,bbmeta,tlmode,triallimbguess)


%labelTrialType Label trial as left or right limb
%   Prasanna Sritharan, June 2017

    % determine trial limb
    switch tlmode

        % auto: use guess computed earlier
        case 'manual'
            tcode = input(['Enter trial limb: ' subj ' ' trial ' (r/l) [r]: '],'s');
            tind = find(strcmpi(tcode,bbmeta.limbs),1);                        
            if isempty(tind)
                triallimb = bbmeta.limbs{1};
            else
                triallimb = bbmeta.limbs{tind};
            end
        
        % auto: use guess computed earlier
        case 'auto'
            triallimb = triallimbguess;
            disp(['Enter trial limb: ' subj ' ' trial ' (r/l) [r]: ' lower(triallimb)]);
        
        % all trials on the same foot
        case lower(bbmeta.limbs)
            triallimb = bbmeta.limbs{find(strcmpi(tlmode,bbmeta.limbs),1)};
            disp(['Enter trial limb: ' subj ' ' trial ' (r/l) [r]: ' lower(triallimb)]);
        
    end
    
    
    


end


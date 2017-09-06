function triallimb = labelTrialLimb(subj,trial,bbmeta,tlmode,triallimbguess)


%  labelTrialType: Label trial as left or right limb
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


    % determine trial limb
    switch tlmode

        % auto: use guess computed earlier
        case 'manual'
            tcode = input(['Enter trial limb: ' subj ' ' trial ' (r/l) [r]: '],'s');
            tind = find(strcmpi(tcode,bbmeta.limbs),1);                        
            if isempty(tind)
                triallimb = upper(bbmeta.limbs{1});
            else
                triallimb = upper(bbmeta.limbs{tind});
            end
        
        % auto: use guess computed earlier
        case 'auto'
            triallimb = triallimbguess;
            disp(['Enter trial limb: ' subj ' ' trial ' (r/l) [r]: ' upper(triallimb)]);
        
        % all trials on the same foot
        case lower(bbmeta.limbs)
            triallimb = bbmeta.limbs{find(strcmpi(tlmode,bbmeta.limbs),1)};
            disp(['Enter trial limb: ' subj ' ' trial ' (r/l) [r]: ' upper(triallimb)]);
        
    end
    
    
    


end


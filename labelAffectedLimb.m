function affected = labelAffectedLimb(cohort,bbmeta,affmode)

%labelAffectedLimb: Label the affected limb in patient cohort
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


    % set affected limb, or control
    if strcmpi(cohort,bbmeta.cohorts{2})
        
        % set as control if cohort is control
        affected = bbmeta.limbs{3};
        disp(['Affected limb: ' upper(affected)]);
        
    else
        switch lower(affmode)
            
            % manual user input of trial type (default: control)
            case 'manual'
                tcode = input(['Enter affected limb: (r/l) [r]: '],'s');
                tind = find(strcmpi(tcode,bbmeta.limbs),1);                        
                if isempty(tind)
                    affected = upper(bbmeta.limbs{1});
                else
                    affected = upper(bbmeta.limbs{tind});
                end

            % all trials are of the same type
            case lower(bbmeta.limbs(1:2))
                affected = bbmeta.limbs{find(strcmpi(affmode,bbmeta.limbs),1)};
                disp(['Affected limb: ' upper(affected)]);
                
            % do not set, indicate that this will be set manually later
            case 'z'
                affected = affmode;
                disp(['Affected limb: ' upper(affected) ', not set at this time']);                

        end

    end


end


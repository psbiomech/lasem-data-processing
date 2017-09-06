function bbstruct = runAnalyses(bbstruct,bbmeta,user)

%  runAnalyses: Run additional analyses on Body Builder data
%   Prasanna Sritharan, August 2017
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


    % add search path for tasks
    addpath('./analyses/'); 

    % get Body Builder point data from C3D files
    subjs = fieldnames(bbstruct);
    for s=1:length(subjs)
        trials = fieldnames(bbstruct.(subjs{s}));
        for t=1:length(trials)            
            if isempty(find(strcmpi(trials{t},{'cohort','affected','mean','sd'}),1))

                % joint rotational work (angular work)
                bbstruct = analysis_work_rotational(bbstruct,bbmeta,subjs{s},trials{t});     

                % joint rotational impulse
                bbstruct = analysis_impulse_rotational(bbstruct,bbmeta,subjs{s},trials{t});                

                % GRF impulse
                bbstruct = analysis_impulse_grf(bbstruct,bbmeta,subjs{s},trials{t});   
                
                % Body Builder data values at events
                bbstruct = analysis_eventval_angle(bbstruct,bbmeta,user,subjs{s},trials{t});
                bbstruct = analysis_eventval_moment(bbstruct,bbmeta,user,subjs{s},trials{t});
                bbstruct = analysis_eventval_power(bbstruct,bbmeta,user,subjs{s},trials{t});
                bbstruct = analysis_eventval_grf(bbstruct,bbmeta,user,subjs{s},trials{t});
                
                
                
            else
                continue;
            end
        end
    end   


end


function bbstruct = analysis_eventval_grf(bbstruct,bbmeta,user,subj,trial)


%  analysis_eventval_grf: Get GRF values at events
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


    % input data group name
    GRPIN = bbmeta.BBGROUPS{4};
    GRPOUT = upper(bbmeta.BBANALYSES{7});   

    % midstring
    INMIDSTR = GRPIN(1:end-1);
    OUTMIDSTR = bbmeta.BBANALYSES{7};     

    % get values
    qnames = fieldnames(bbstruct.(subj).(trial).(GRPIN));        
    timemap = linspace(bbstruct.(subj).(trial).vfrange(1),bbstruct.(subj).(trial).vfrange(2),user.SAMP);
    sampmap = 1:user.SAMP;
    for q=1:length(qnames)
        for e=1:length(bbstruct.(subj).(trial).ecodes)
            tstep = round(interp1(timemap,sampmap,bbstruct.(subj).(trial).eframes(e)));
            bbstruct.(subj).(trial).(GRPOUT).(qnames{q})(e,:) = bbstruct.(subj).(trial).(GRPIN).(qnames{q})(tstep,:);
        end
    end
        
end


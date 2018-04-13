function datastruct = analysis_eventval_power(datastruct,bbmeta,user,vfrange,ecodes,eframes)


%analysis_eventval_power: Get power values at events
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


    % input data group name
    GRPIN = bbmeta.BBGROUPS{3};
    GRPOUT = upper(bbmeta.BBANALYSES{6});   

    % midstring
    INMIDSTR = GRPIN(1:end-1);
    OUTMIDSTR = bbmeta.BBANALYSES{6};     

    % get values
    qnames = fieldnames(datastruct.(GRPIN));        
    timemap = linspace(vfrange(1),vfrange(2),user.SAMP);
    sampmap = 1:user.SAMP;
    for q=1:length(qnames)
        for e=1:length(ecodes)
            tstep = round(interp1(timemap,sampmap,eframes(e)));
            datastruct.(GRPOUT).(qnames{q})(e,:) = datastruct.(GRPIN).(qnames{q})(tstep,:);
        end
    end
        
end


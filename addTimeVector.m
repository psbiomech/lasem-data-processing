function bbstruct = addTimeVector(bbstruct,subj,trial,samp)

%  addTimeVector: Add time vector to trial data
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


    % absolute time vector    
    bbstruct.(subj).(trial).TIMES.absolute = linspace(bbstruct.(subj).(trial).trange(1),bbstruct.(subj).(trial).trange(2),samp);
    
    % relative time vector
    bbstruct.(subj).(trial).TIMES.relative = bbstruct.(subj).(trial).TIMES.absolute - bbstruct.(subj).(trial).TIMES.absolute(1);
    
end


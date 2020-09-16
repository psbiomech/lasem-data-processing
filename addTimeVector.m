function structin = addTimeVector(structin,p,samp)

%  addTimeVector: Add time vector to trial data
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


    % create time vectors, absolute and relative to first step
    if p<0
        structin.data.TIMES.absolute = linspace(structin.trange(1),structin.trange(2),samp);
        structin.data.TIMES.relative = structin.data.TIMES.absolute-structin.data.TIMES.absolute(1);        
    else
        structin.data{p}.TIMES.absolute = linspace(structin.trange{p}(1),structin.trange{p}(2),samp);
        structin.data{p}.TIMES.relative = structin.data{p}.TIMES.absolute-structin.data{p}.TIMES.absolute(1);
    end
    
end


function resampled = resampleBBdata(rawdata,newsamp)

%  resampleBBdata: Resample Body Builder data extracted from C3D
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


    % parse Body Builder data groups
    grps = fieldnames(rawdata);
    for g=1:length(grps)

        % parse quantitative parameters within group
        qnames = fieldnames(rawdata.(grps{g}));
        for q=1:length(qnames)

            % resample data
            resampled.(grps{g}).(qnames{q}) = resampleData(rawdata.(grps{g}).(qnames{q}),newsamp);

        end
    end

end


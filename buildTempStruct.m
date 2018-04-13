function temp = buildTempStruct(tstruct,p)


%buildTempStruct: Build temporary struct for multiple analysed legs
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

    % build struct
    temp.vfirst = tstruct.vfirst;
    temp.vfrange = tstruct.vfrange{p};
    temp.nvframes = tstruct.nvframes{p};
    temp.afrange = tstruct.afrange{p};
    temp.naframes = tstruct.naframes{p};
    temp.trange = tstruct.trange{p};
    temp.fpseq = tstruct.fpseq{p};
    temp.triallimb = tstruct.triallimb{p};
    temp.analysedlegs = 1;
    temp.filepath = tstruct.filepath;
    
end


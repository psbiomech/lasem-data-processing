function saveBBstruct(bb,user)

%saveBBstruct: Save Body Builder struct to MAT file
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


    % assign struct fields
    bbfilename = user.TRIALPREFIX;
    bbfilepath = user.SUMMARYPATH;

    % add MAT extension if necessary
    if isempty(regexpi(bbfilename,'.mat')), bbfilename = [bbfilename '.mat']; end; 

    % save Body Builder struct
    mkdir(bbfilepath);
    save([bbfilepath '\' bbfilename],'bb');
    
end


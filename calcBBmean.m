function bbstruct = calcBBmean(bbstruct,bbmeta,user)


%calcBBmean: Mean and standard deviation of BB data
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
    structpath = user.DATASRCPATH;
    ampg = user.AMPG;
    samp = user.SAMP;

    % calculate subject means
    disp(' ');
    disp('Calculating subject means...');
    bbstruct = meanBBsubject(bbstruct,bbmeta,ampg,samp);
    
    % calculate total means (requires subject means already calculated)
    disp(' ');
    disp('Calculating group means...');
    bbstruct = meanBBall(bbstruct,bbmeta,ampg,samp);

    % save struct
    save(fullfile(structpath,'bb.mat'),'-struct','bbstruct');    
    
    disp(' ');
    
end


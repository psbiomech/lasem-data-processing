function [flist,fnames,subtri] = generateFileList(user)

%generateFileList: Parse file structure and extract files with names matching pattern
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
    c3droot = user.DATASRCPATH;
    c3dnameformat = {user.SUBJECTPREFIX,user.CTRLPREFIX,user.SEPARATOR,user.TRIALPREFIX};
    selectmode = user.FILESELECTMODE;

    % string subsections
    subjprefix = c3dnameformat{1};
    ctrlprefix = c3dnameformat{2};
    separator = c3dnameformat{3};
    trialprefix = c3dnameformat{4};

    % generate expression for pattern matching
    c3dexpr = ['(' subjprefix '(?:' ctrlprefix ')?\d+' separator trialprefix '\d+)\.c3d'];

    % parse all subdirectories and get list of all C3D files starting from
    % c3droot that match c3dexpr
    fstruct = subdir([c3droot '\*.c3d']);
    flist = cell(size(fstruct));
    for f=1:length(flist)
        flist{f} = fstruct(f).name;
    end

    % test if file of interest
    fflag = zeros(size(flist));
    tokens = cell(size(flist));
    for f=1:length(flist)
        [toks,match] = regexpi(fstruct(f).name,['.*\\' c3dexpr '$'],'tokens');
        fflag(f) = ~isempty(match);
        if (fflag(f)==1), tokens{f} = toks{1}{1}; end
    end
    
    % cut down list to only files of interest
    ftemp = flist(logical(fflag));
    toktemp = tokens(logical(fflag));
    
    % manually cut down list even more if select mode is manual
    switch selectmode
        
        % keep all files in list
        case 'auto'
            flist = ftemp;
            fnames = toktemp;
        
        % select files to keep and discard
        fflag2 = zeros(size(ftemp));
        case 'manual'
            disp(' ');
            disp('Keep these files?');
            disp('------------------------------');
            for f=1:length(ftemp)
                keep = input([toktemp{f} ': y/n [y]: '],'s');  % default: yes
                if (isempty(keep))||~strcmpi(keep,'Y')||~strcmpi(keep,'N'), keep = 'y'; end
                switch upper(keep)
                    case 'Y'
                        fflag2(f) = 1;
                    case 'N'
                        fflag2(f) = 0;
                end
            end
            flist = ftemp(logical(fflag2));
            fnames = toktemp(logical(fflag2));
            disp(' ');
    end
    
    % further split tokens into subjects and trials, trim results
    splitexp = ['(' subjprefix '(?:' ctrlprefix ')?\d+)' separator '(' trialprefix '\d+)'];
    subtri = cell(size(fnames));
    for t=1:length(fnames)
       [toks2,~] = regexpi(fnames{t},splitexp,'tokens');
       sbtemp = regexpi(toks2{1},'[-_.]*(\w*)[-_.]*','tokens');
       subtri{t} = [sbtemp{1}{1},sbtemp{2}{1}];
    end
    

end


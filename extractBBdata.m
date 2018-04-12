function bbstruct = extractBBdata(inp,bbmeta,user)


%  extractBBdata: Get BB data from C3D file, trim and resample
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


    % assign struct fields
    inputtype = user.INPUTTYPE;
    ampg = user.AMPG;
    samp = user.SAMP;
    xlspath = user.XLSMETAPATH;


    % check inputs
    if (nargin==5)
        xlspath = [];
    end
        

    % get settings/meta data, determine action based on input type
    switch inputtype
        
        % as struct
        case 'struct'
            bbstruct = inp;

        % as Excel file
        case 'xls'
            bbstruct = loadXLSmeta(inp,xlspath);

    end

    % get Body Builder point data from C3D files
    subjs = fieldnames(bbstruct);
    for s=1:length(subjs)
        trials = fieldnames(bbstruct.(subjs{s}));
        for t=1:length(trials)            
            if isempty(find(strcmpi(trials{t},{'cohort','affected'}),1))
                [rawdatastruct,~] = pullBBpoint(bbstruct.(subjs{s}).(trials{t}),bbmeta,ampg);    
                bbstruct = resampleBBdata(bbstruct,subjs{s},trials{t},rawdatastruct,samp);     
                bbstruct = addTimeVector(bbstruct,subjs{s},trials{t},samp);
            else
                continue;
            end
        end
    end                   

end


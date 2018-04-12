function bbstruct = extractBBdata(bbstruct,bbmeta,user)


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
    updatemeta = user.UPDATEMETA;
    ampg = user.AMPG;
    samp = user.SAMP;
    xlsname = [user.TRIALPREFIX '_SubjInfoOnly'];
    xlspath = user.XLSMETAPATH;
        

    % update meta data from XLS if required
    if strcmpi(updatemeta,'update'), bbstruct = loadXLSmeta(bbstruct,xlsname,xlspath); end;
            
    % get Body Builder point data from C3D files
    subjs = fieldnames(bbstruct);
    for s=1:length(subjs)
        subj = subjs{s};
        trials = fieldnames(bbstruct.(subjs{s}));
        for t=1:length(trials)                        
            trial = trials{t};
            if isempty(find(strcmpi(trials{t},{'cohort','affected'}),1))

                switch bbstruct.(subjs{s}).(trials{t}).analysedlegs
                    
                    case 1  % one leg
                        rawdatastruct = pullBBpoint(bbstruct.(subjs{s}).(trials{t}),bbmeta,ampg);    
                        bbstruct.(subj).(trial).data = resampleBBdata(rawdatastruct,samp);     
                        bbstruct.(subj).(trial) = addTimeVector(bbstruct.(subj).(trial),-1,samp);
            
                    case 2  % two legs
                        for p=1:2                           
                            tempstruct = buildTempStruct(bbstruct.(subjs{s}).(trials{t}),p);
                            rawdatastruct = pullBBpoint(tempstruct,bbmeta,ampg);
                            bbstruct.(subj).(trial).data{p} = resampleBBdata(rawdatastruct,samp);  
                            bbstruct.(subj).(trial) = addTimeVector(bbstruct.(subj).(trial),p,samp);  
                        end
                end
            
            else
                continue;
            end
            
            
        end
    end                   

end


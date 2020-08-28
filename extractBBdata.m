function bbstruct = extractBBdata(bbstruct,bbmeta,user)


%extractBBdata: Get BB data from C3D file, trim and resample
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
    ampg = user.AMPG;
    samp = user.SAMP;
    structpath = user.DATASRCPATH;
        
            
    % pull Body Builder point data from C3D files
    subjs = fieldnames(bbstruct);
    for s=1:length(subjs)
        
        subj = subjs{s};
        trials = fieldnames(bbstruct.(subjs{s}));
        
        disp(' ');
        disp(['Subject: ' subjs{s}]);
        disp(['==============================']);        
        
        for t=1:length(trials)                                    
            trial = trials{t};           
            if isempty(find(strcmpi(trials{t},bbmeta.SUBJECTFIELDS),1))

                % skip ignored trials
                if bbstruct.(subjs{s}).(trials{t}).ignore==1
                    disp(['--Ignoring trial: ' trials{t}]); 
                    continue
                end
                
                disp(['Loading trial data: ' trials{t}]);                
                
                % pull data
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

    
    % save struct
    save(fullfile(structpath,'bb.mat'),'-struct','bbstruct');    
    
    disp(' ');
    
end


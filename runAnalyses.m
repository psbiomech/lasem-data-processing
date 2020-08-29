function bbstruct = runAnalyses(bbstruct,bbmeta,user)

%runAnalyses: Run additional analyses on Body Builder data
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


    % add search path for tasks
    addpath('./analyses/'); 
    
    % user parameters
    structpath = user.DATASRCPATH;

    % get Body Builder point data from C3D files
    subjs = fieldnames(bbstruct);
    for s=1:length(subjs)
        trials = fieldnames(bbstruct.(subjs{s}));
        for t=1:length(trials)            
            if isempty(find(strcmpi(trials{t},bbmeta.SUBJECTFIELDS),1))
                
                % skip ignored trials
                if bbstruct.(subjs{s}).(trials{t}).ignore==1
                    disp(['--Ignoring trial: ' subjs{s} '_' trials{t}]); 
                    continue
                end                 
                
                disp(['Running analysis for: ' subjs{s} ' ' trials{t}]);
                switch bbstruct.(subjs{s}).(trials{t}).analysedlegs
                    
                    case 1  % one leg
                                                
                        % parameters
                        datastruct = bbstruct.(subjs{s}).(trials{t}).data;
                        vfrange = bbstruct.(subjs{s}).(trials{t}).vfrange;
                        ecodes = bbstruct.(subjs{s}).(trials{t}).ecodes;
                        eframes = bbstruct.(subjs{s}).(trials{t}).eframes;
                        
                        % analyses
                        datastruct = analysis_work_rotational(datastruct,bbmeta);     
                        datastruct = analysis_impulse_rotational(datastruct,bbmeta);                
                        datastruct = analysis_impulse_grf(datastruct,bbmeta);   
                        datastruct = analysis_eventval_angle(datastruct,bbmeta,user,vfrange,ecodes,eframes);
                        datastruct = analysis_eventval_moment(datastruct,bbmeta,user,vfrange,ecodes,eframes);
                        datastruct = analysis_eventval_power(datastruct,bbmeta,user,vfrange,ecodes,eframes);
                        datastruct = analysis_eventval_grf(datastruct,bbmeta,user,vfrange,ecodes,eframes);
                
                        % re-assign to BB struct
                        bbstruct.(subjs{s}).(trials{t}).data = datastruct;
                        
                    case 2  % two legs
                        
                        for p=1:2
                        
                            % parameters
                            datastruct = bbstruct.(subjs{s}).(trials{t}).data{p};
                            vfrange = bbstruct.(subjs{s}).(trials{t}).vfrange{p};
                            ecodes = bbstruct.(subjs{s}).(trials{t}).ecodes{p};
                            eframes = bbstruct.(subjs{s}).(trials{t}).eframes{p};

                            % analyses
                            datastruct = analysis_work_rotational(datastruct,bbmeta);     
                            datastruct = analysis_impulse_rotational(datastruct,bbmeta);                
                            datastruct = analysis_impulse_grf(datastruct,bbmeta);   
                            datastruct = analysis_eventval_angle(datastruct,bbmeta,user,vfrange,ecodes,eframes);
                            datastruct = analysis_eventval_moment(datastruct,bbmeta,user,vfrange,ecodes,eframes);
                            datastruct = analysis_eventval_power(datastruct,bbmeta,user,vfrange,ecodes,eframes);
                            datastruct = analysis_eventval_grf(datastruct,bbmeta,user,vfrange,ecodes,eframes);

                            % re-assign to BB struct
                            bbstruct.(subjs{s}).(trials{t}).data{p} = datastruct;
                            
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


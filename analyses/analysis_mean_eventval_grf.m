function bbstruct = analysis_mean_eventval_grf(bbstruct,bbmeta)


%analysis_eventval_grf: Subject and total means for GRF values at events
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

    disp(' ');
    disp('Analysis: Mean values at events - GRFs...');

    % input data group name
    DATAGRP = upper(bbmeta.BBANALYSES{7}); 
    SRCGRP = bbmeta.BBGROUPS{4};      

    
    % ********************
    % SUBJECT MEANS    
    
    % collate trials
    subjs = fieldnames(bbstruct);
    for s=1:length(subjs)

        % skip if MEAN field
        if strcmpi(subjs{s},'MEAN'), continue; end          
        
        % skip if kinematics only
        if bbstruct.(subjs{s}).kinematicsonly, continue; end       
        
        % get list of trials        
        trials = fieldnames(bbstruct.(subjs{s}));
        ntrials = length(trials);        
        
        % collate point data
        alldata = struct;       
        for q=1:length(bbmeta.(SRCGRP))
            for f=1:2                
                quantlabel = bbmeta.(SRCGRP){q};                               
                quantname = [bbmeta.limbs{f} quantlabel];
                t1 = 1;
                t2 = 1;
                t3 = 1;
                for n = 1:ntrials
                    try
                        if isempty(find(strcmpi(trials{n},bbmeta.SUBJECTFIELDS),1))
 
                            % skip ignored trials
                            if bbstruct.(subjs{s}).(trials{n}).ignore==1
                                disp(['--Ignoring variable: ' SRCGRP '@events ' quantname ' for foot ' bbmeta.limbs{f} ' and trial ' subjs{s} '_' trials{n}]); 
                                continue
                            end                               
                            
                            switch bbstruct.(subjs{s}).(trials{n}).analysedlegs
                            
                                case 1  % one leg                            
                            
                                    if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbmeta.limbs{f})
                                        if strcmpi(bbstruct.(subjs{s}).affected,'C')
                                            cond3 = bbmeta.conditions{3};
                                            alldata.(cond3).(DATAGRP).(quantlabel)(:,:,t3) = bbstruct.(subjs{s}).(trials{n}).data.(DATAGRP).(quantname);
                                            t3 = t3 + 1;                                           
                                        elseif strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbstruct.(subjs{s}).affected)
                                            cond1 = bbmeta.conditions{1};
                                            alldata.(cond1).(DATAGRP).(quantlabel)(:,:,t1) = bbstruct.(subjs{s}).(trials{n}).data.(DATAGRP).(quantname);
                                            t1 = t1 + 1;
                                        else
                                            cond2 = bbmeta.conditions{2};
                                            alldata.(cond2).(DATAGRP).(quantlabel)(:,:,t2) = bbstruct.(subjs{s}).(trials{n}).data.(DATAGRP).(quantname);
                                            t2 = t2 + 1;
                                        end
                                    end
                                    
                                case 2  % two legs

                                    for p=1:2
                                        if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb{p},bbmeta.limbs{f})
                                            if strcmpi(bbstruct.(subjs{s}).affected,'C')
                                                cond3 = bbmeta.conditions{3};
                                                alldata.(cond3).(DATAGRP).(quantlabel)(:,:,t3) = bbstruct.(subjs{s}).(trials{n}).data{p}.(DATAGRP).(quantname);
                                                t3 = t3 + 1;                                             
                                            elseif strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb{p},bbstruct.(subjs{s}).affected)
                                                cond1 = bbmeta.conditions{1};
                                                alldata.(cond1).(DATAGRP).(quantlabel)(:,:,t1) = bbstruct.(subjs{s}).(trials{n}).data{p}.(DATAGRP).(quantname);
                                                t1 = t1 + 1;
                                            else
                                                cond2 = bbmeta.conditions{2};
                                                alldata.(cond2).(DATAGRP).(quantlabel)(:,:,t2) = bbstruct.(subjs{s}).(trials{n}).data{p}.(DATAGRP).(quantname);
                                                t2 = t2 + 1;
                                            end
                                        end  
                                    end
                                    
                            end
                            
                        else
                            continue;
                        end
                    catch                            
                        disp(['--Error processing: ' SRCGRP '@events ' quantname ' for foot ' bbmeta.limbs{f} ' and trial ' subjs{s} ' ' trials{n}]);
                    end                           
                end
            end                                        
        end
    
        % calculate mean and sd for point data
        for q=1:length(bbmeta.(SRCGRP))
            quantlabel = bbmeta.(SRCGRP){q};                
            for c=1:3
                cond = bbmeta.conditions{c};
                if isfield(alldata,bbmeta.conditions{c})
                    bbstruct.(subjs{s}).mean.(cond).(DATAGRP).(quantlabel) = mean(alldata.(cond).(DATAGRP).(quantlabel),3);
                    bbstruct.(subjs{s}).sd.(cond).(DATAGRP).(quantlabel) = std(alldata.(cond).(DATAGRP).(quantlabel),0,3);                                 
                end
            end
        end    
        
    end
    
   
    
    % ********************
    % TOTAL MEANS      
    
    % collate individual means and sds
    subjs = fieldnames(bbstruct);
    alldata = struct;
    for q=1:length(bbmeta.(SRCGRP))
        quantlabel = bbmeta.(SRCGRP){q}; 
        for f=1:3
            cond = bbmeta.conditions{f};
            n = 1;
             for s=1:length(subjs) 
                if ~strcmpi(subjs{s},'MEAN')
                    if bbstruct.(subjs{s}).kinematicsonly, continue; end                                       
                    if isfield(bbstruct.(subjs{s}),'mean')
                        if isfield(bbstruct.(subjs{s}).mean,cond)
                            try                            
                                alldata.means.(cond).(DATAGRP).(quantlabel)(:,:,n) = bbstruct.(subjs{s}).mean.(cond).(DATAGRP).(quantlabel);
                                alldata.sds.(cond).(DATAGRP).(quantlabel)(:,:,n) = bbstruct.(subjs{s}).sd.(cond).(DATAGRP).(quantlabel);
                                n = n + 1;
                            catch
                                disp(['--ERROR: Unable to process quantity ' quantlabel ' for condition ' cond ' for subject ' subjs{s}]);
                            end
                        end
                    end
                else
                    continue
                end
             end
        end
    end
            
    
    % calculate mean and sd for all data
    % mean: mean of individual subject means
    % sd: sqrt of sum of squares of individual subject sds
    for q=1:length(bbmeta.(SRCGRP))
        quantlabel = bbmeta.(SRCGRP){q}; 
        for c=1:3
            cond = bbmeta.conditions{c};
            if isfield(alldata.means,cond)
                bbstruct.MEAN.mean.(cond).(DATAGRP).(quantlabel) = mean(alldata.means.(cond).(DATAGRP).(quantlabel),3);
                bbstruct.MEAN.sd.(cond).(DATAGRP).(quantlabel) = std(alldata.means.(cond).(DATAGRP).(quantlabel),0,3);                                
            end
        end
    end   
        
end


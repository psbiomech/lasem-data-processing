function writeXLSAllTrialsBBstructGroups(bbstruct,bbmeta,user)


%writeXLSAllTrialsBBstructGroups: write individual trial data to XLS
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


    warning('off');

    % assign struct fields
    xlsprefix = user.TRIALPREFIX;
    xlspath = user.SUMMARYPATH;
    samp = user.SAMP;

    
    % collate data
    for b=1:length(bbmeta.BBGROUPS)
        for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
            quantlabel = bbmeta.(bbmeta.BBGROUPS{b}){q};
            for c=1:length(bbmeta.dirs)

                % sheet header row (means)
                xldata.(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c})(1,:) = ['Subject', ...
                                                                                  'Trial', ...
                                                                                  'TrialLimb', ...
                                                                                  'Affected', ...
                                                                                  num2cell(1:samp)];                                       

                % get trial data
                r = 2;
                subjs = fieldnames(bbstruct);    
                for s=1:length(subjs)                        
                    subj = subjs{s};
                    if ~strcmpi(subj,'MEAN')
                        if (bbstruct.(subj).kinematicsonly)&&(~strcmpi(bbmeta.BBGROUPS{b},'ANGLES')), continue; end 
                        affected = bbstruct.(subj).affected;
                        trials = fieldnames(bbstruct.(subj));
                        for t=1:length(trials)                        
                            trial = trials{t};
                            if isempty(find(strcmpi(trials{t},bbmeta.SUBJECTFIELDS),1))
                                
                                % skip ignored trials
                                if bbstruct.(subjs{s}).(trials{t}).ignore==1
                                    disp(['--Ignoring trial: ' subjs{s} '_' trials{t}]); 
                                    continue
                                end                                
                                
                                analysedlegs = bbstruct.(subj).(trial).analysedlegs;
                                for z=1:analysedlegs

                                    % trial limbs
                                    if analysedlegs==1
                                        tlimb = bbstruct.(subj).(trial).triallimb;                                      
                                    else
                                        tlimb = bbstruct.(subj).(trial).triallimb{z};
                                    end
                                    tlabel = [tlimb quantlabel];

                                    % get data
                                    if analysedlegs==1
                                        xldata.(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c})(r,:) = [subj, ...
                                                                                                          trial, ...
                                                                                                          tlimb, ...
                                                                                                          affected, ...
                                                                                                          num2cell(bbstruct.(subj).(trial).data.(bbmeta.BBGROUPS{b}).(tlabel)(:,c))'];                        
                                    else
                                        xldata.(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c})(r,:) = [subj, ...
                                                                                                          trial, ...
                                                                                                          tlimb, ...
                                                                                                          affected, ...
                                                                                                          num2cell(bbstruct.(subj).(trial).data{z}.(bbmeta.BBGROUPS{b}).(tlabel)(:,c))'];                                                                
                                    end

                                    % increment row
                                    r = r + 1;

                                end

                            else
                                continue;
                            end
                        end
                    end       
                end      

            end
        end
    end
                                                                                
    
    % write Excel spreadsheet
    mkdir(xlspath);
    mkdir([xlspath '\XLS\']);
    for b=1:length(bbmeta.BBGROUPS)
        s = 1;
        xlsname = [xlsprefix '_ALLTRIALS_' bbmeta.BBGROUPS{b} '.xlsx'];                
        for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
            quantlabel = bbmeta.(bbmeta.BBGROUPS{b}){q};
            for c=1:length(bbmeta.dirs)
                sheetname = [quantlabel '_' bbmeta.dirs{c} '_' bbmeta.units.(bbmeta.BBGROUPS{b})];
                writecell(xldata.(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c}),[xlspath '\XLS\' xlsname],'FileType','spreadsheet','Sheet',sheetname);                 
                s = s + 1;
            end
        end
    end
    
    
end



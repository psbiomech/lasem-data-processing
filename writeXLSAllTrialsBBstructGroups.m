function writeXLSMeanBBstructGroups(bbstruct,bbmeta,user)


%writeXLSMeanBBstructGroups: write BB data to Excel multiple workbooks
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
    
    
    % data for write
    DTYPE = {'MEAN','SD'};
    
    % collate data
    for b=1:length(bbmeta.BBGROUPS)
        for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
            quantlabel = bbmeta.(bbmeta.BBGROUPS{b}){q};
            for c=1:length(bbmeta.dirs)

                % sheet header row (means)
                xldata.(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c})(1,:) = ['Subject', ...
                                                                                  'TrialLimb', ...
                                                                                  'Affected', ...
                                                                                  cellfun(@(z)num2str(z,'%i'),num2cell(1:samp),'UniformOutput',false)];                                       

                % get trial data
                r = 2;
                subjs = fieldnames(bbstruct);    
                for s=1:length(subjs)                        
                    subj = subjs{s};
                    if isempty(find(strcmpi(subj,'MEAN'),1))
                        affected = bbstruct.(subj).affected;
                        trials = fieldnames(bbstruct.(subj));
                        for t=1:length(trials)                        
                            trial = trials{t};
                            for z=1:2
                                if isempty(find(strcmpi(trials{t},bbmeta.SUBJECTFIELDS),1))

                                    % trial limbs
                                    tlimb = bbstruct.(subj).(trial).triallimb{z};
                                    tlabel = [tlimb quantlabel];

                                    % get data
                                    xldata.(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c})(r,:) = [subj, ...
                                                                                                      tlimb, ...
                                                                                                      affected, ...
                                                                                                      cellfun(@(z)num2str(z,'%12.8f'),num2cell(bbstruct.(subj).(trial).data{z}.(bbmeta.BBGROUPS{b}).(tlabel)(:,c))','UniformOutput',false)];                        

                                    % increment row
                                    r = r + 1;

                                else
                                    continue;
                                end
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
    for f=1:2
        for b=1:length(bbmeta.BBGROUPS)
            s = 1;
            xlsname = [xlsprefix '_ALLTRIALS_' bbmeta.BBGROUPS{b} '.xlsx'];                
            for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
                quantlabel = bbmeta.(bbmeta.BBGROUPS{b}){q};
                for c=1:length(bbmeta.dirs)
                    xlswrite([xlspath '\XLS\' xlsname],xldata.(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c}),s);
                    s = s + 1;
                end
            end
        end
    end
    
    % rename sheets using actxserver
    for f=1:2    
        for b=1:length(bbmeta.BBGROUPS)
            s = 1;
            xlsname = [xlsprefix '_ALLTRIALS_' bbmeta.BBGROUPS{b} '.xlsx'];
            xl = actxserver('Excel.Application'); 
            wb = xl.Workbooks.Open([xlspath '\XLS\' xlsname]);                
            for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
                quantlabel = bbmeta.(bbmeta.BBGROUPS{b}){q};
                for c=1:length(bbmeta.dirs)
                    wb.Worksheets.Item(s).Name = [quantlabel '_' bbmeta.dirs{c} '_' bbmeta.units.(bbmeta.BBGROUPS{b})];
                    s = s + 1;
                end            
            end
            wb.Save;
            wb.Close(false);        
            xl.Quit; 
        end   
    end    
   
    
    
end



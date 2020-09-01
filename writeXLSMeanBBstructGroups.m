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
    subjprefix = user.SUBJECTPREFIX;
    trialprefix = user.TRIALPREFIX;
    xlspath = user.SUMMARYPATH;
    samp = user.SAMP;

    
    % collate data
    subjs = fieldnames(bbstruct);    
    for b=1:length(bbmeta.BBGROUPS)        
        for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
            quantlabel = bbmeta.(bbmeta.BBGROUPS{b}){q};
            for f=1:3
                cond = bbmeta.conditions{f};
                for c=1:length(bbmeta.dirs)

                    % sheet header row (means)
                    xldata.(cond).(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c})(1,:) = ['Type', ...
                                                                                             'Time', ...
                                                                                             num2cell(1:samp)];                                       

                    % get means
                    r = 2;
                    for s=1:length(subjs)
                        if isfield(bbstruct.(subjs{s}),'mean')
                            if isfield(bbstruct.(subjs{s}).mean,cond)

                                % skip kinetics if kinematics only
                                if (~strcmpi(subjs{s},'MEAN'))&&(bbstruct.(subjs{s}).kinematicsonly)&&(~strcmpi(bbmeta.BBGROUPS{b},'ANGLES')), continue; end                                
                                
                                % get data
                                xldata.(cond).(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c})(r,:) = ['Mean', ...
                                                                                                         subjs{s}, ...
                                                                                                         num2cell(bbstruct.(subjs{s}).mean.(cond).(bbmeta.BBGROUPS{b}).(quantlabel)(:,c))'];                        

                                % increment row
                                r = r + 1;

                            end
                        end
                    end                    
                    
                    % sheet header row (sds)
                    r = r + 1;
                    xldata.(cond).(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c})(r,:) = ['Type', ...
                                                                                             'Time', ...
                                                                                             num2cell(1:samp)];                          
                                        
                    % get sds
                    r = r + 1;
                    for s=1:length(subjs)
                        if isfield(bbstruct.(subjs{s}),'mean')
                            if isfield(bbstruct.(subjs{s}).sd,cond)

                                % skip kinetics if kinematics only
                                if (~strcmpi(subjs{s},'MEAN'))&&(bbstruct.(subjs{s}).kinematicsonly)&&(~strcmpi(bbmeta.BBGROUPS{b},'ANGLES')), continue; end                                 
                                
                                % get data
                                xldata.(cond).(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c})(r,:) = ['Stdev', ...
                                                                                                         subjs{s}, ...
                                                                                                         num2cell(bbstruct.(subjs{s}).sd.(cond).(bbmeta.BBGROUPS{b}).(quantlabel)(:,c))'];                        

                                % increment row
                                r = r + 1;

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
    for f=1:3
        cond = bbmeta.conditions{f};
        if isfield(xldata,cond)
            for b=1:length(bbmeta.BBGROUPS)
                s = 1;
                xlsname = [upper(subjprefix) '_' upper(trialprefix) '_' cond '_' bbmeta.BBGROUPS{b} '.xlsx'];                
                for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
                    quantlabel = bbmeta.(bbmeta.BBGROUPS{b}){q};
                    for c=1:length(bbmeta.dirs)
                        sheetname = [quantlabel '_' bbmeta.dirs{c} '_' bbmeta.units.(bbmeta.BBGROUPS{b})];
                        writecell(xldata.(cond).(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c}),[xlspath '\XLS\' xlsname],'FileType','spreadsheet','Sheet',sheetname);                        
                        s = s + 1; 
                    end
                end
            end
        end
    end
       
   
    
    
end



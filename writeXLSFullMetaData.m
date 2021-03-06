function writeXLSFullMetaData(bbstruct,bbmeta,user)

%writeXLSFullMetaData: Write all available metadata to XLS
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
    xlspath = user.XLSMETAPATH;
    samp = user.SAMP;
    
    
    % sheet header
    xldata(1,:) = {'subj','mass','height','trial','cohort','affected','kinematicsonly','speed.trial','speed.stance','vfirst','vfrange','nvframes','afrange','naframes','trange','fpseq','triallimb','analysedlegs','ecodes','eframes','filepath'};
        
    % collate data
    x = 2;
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
            
                % different actions required depending on whether one or two legs were analysed per trial
                switch bbstruct.(subjs{s}).(trials{t}).analysedlegs                    
                    
                    case 1  % one leg
                        xldata(x,:) = {subjs{s}, ... 
                                       bbstruct.(subjs{s}).mass, ...
                                       bbstruct.(subjs{s}).height, ...
                                       trials{t}, ... 
                                       upper(bbstruct.(subjs{s}).cohort), ...
                                       upper(bbstruct.(subjs{s}).affected), ...
                                       bbstruct.(subjs{s}).kinematicsonly, ...
                                       bbstruct.(subjs{s}).(trials{t}).speed.trial, ...
                                       bbstruct.(subjs{s}).(trials{t}).speed.stance, ...
                                       bbstruct.(subjs{s}).(trials{t}).vfirst, ...
                                       mat2str(bbstruct.(subjs{s}).(trials{t}).vfrange), ...
                                       bbstruct.(subjs{s}).(trials{t}).nvframes, ...
                                       mat2str(bbstruct.(subjs{s}).(trials{t}).afrange), ...
                                       bbstruct.(subjs{s}).(trials{t}).naframes, ...
                                       mat2str(bbstruct.(subjs{s}).(trials{t}).trange,3), ...
                                       mat2str(bbstruct.(subjs{s}).(trials{t}).fpseq), ...
                                       upper(bbstruct.(subjs{s}).(trials{t}).triallimb), ...
                                       bbstruct.(subjs{s}).(trials{t}).analysedlegs, ...
                                       strjoin(bbstruct.(subjs{s}).(trials{t}).ecodes,';'), ...
                                       mat2str(bbstruct.(subjs{s}).(trials{t}).eframes), ...                                       
                                       bbstruct.(subjs{s}).(trials{t}).filepath};                                   
                        x = x + 1;
                    
                    case 2  % two legs
                        for p=1:2
                            xldata(x+p-1,:) = {subjs{s}, ...
                                               trials{t}, ...
                                               bbstruct.(subjs{s}).mass, ...
                                               bbstruct.(subjs{s}).height, ...                                               
                                               upper(bbstruct.(subjs{s}).cohort), ...
                                               upper(bbstruct.(subjs{s}).affected), ...
                                               bbstruct.(subjs{s}).kinematicsonly, ...
                                               bbstruct.(subjs{s}).(trials{t}).speed{p}.trial, ...
                                               bbstruct.(subjs{s}).(trials{t}).speed{p}.stance, ...
                                               bbstruct.(subjs{s}).(trials{t}).vfirst, ...
                                               mat2str(bbstruct.(subjs{s}).(trials{t}).vfrange{p}), ...
                                               bbstruct.(subjs{s}).(trials{t}).nvframes{p}, ...
                                               mat2str(bbstruct.(subjs{s}).(trials{t}).afrange{p}), ...
                                               bbstruct.(subjs{s}).(trials{t}).naframes{p}, ...
                                               mat2str(bbstruct.(subjs{s}).(trials{t}).trange{p},3), ...
                                               mat2str(bbstruct.(subjs{s}).(trials{t}).fpseq{p}), ...
                                               upper(bbstruct.(subjs{s}).(trials{t}).triallimb{p}), ...
                                               bbstruct.(subjs{s}).(trials{t}).analysedlegs, ...
                                               strjoin(bbstruct.(subjs{s}).(trials{t}).ecodes{p},';'), ...
                                               mat2str(bbstruct.(subjs{s}).(trials{t}).eframes{p}), ...
                                               bbstruct.(subjs{s}).(trials{t}).filepath};                                                       
                        end                                               
                        x = x + 2;
                
                end    
                
            end
        end
    end
                                                                                
  
    % write Excel spreadsheet
    xlsname = [upper(subjprefix) '_' upper(trialprefix) '_trial_metadata.xlsx']; 
    writecell(xldata,fullfile(xlspath,xlsname),'FileType','spreadsheet');        
    

end


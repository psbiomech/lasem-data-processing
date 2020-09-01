function writeXLSMeanAnalysesGroups(bbstruct,bbmeta,user)


%writeXLSMeanAnalysesGroups: write analyses data to Excel in long form
%   Prasanna Sritharan, April 2018
%
% Currently only implemented for joint rotational impulse
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
    
    % summary data types
    SDATA = {'mean','sd'};
    SNAME = {'Mean','Stdev'};
    
    
    % prepare output cell array
    subjs = fieldnames(bbstruct);    
    for b=1:length(bbmeta.BBANALYSES)        
        bbanalysis = upper(bbmeta.BBANALYSES{b});
        
        % skip if not RotImpulse or RotWork
        % (note: only RotImpulse and RotWork required at this time, will
        % add others as required)
        if all(~strcmpi(bbanalysis,{'ROTIMPULSE','ROTWORK'})), continue; end;            
        
                               
        % extract data
        for f=1:3            
            cond = bbmeta.conditions{f};            
            for q=1:length(bbmeta.(bbanalysis))
                quantlabel = bbmeta.(bbanalysis){q};                       
                                
                % determine number of columns
                dcols = 1;                            
                for c=1:3
                    for s=1:length(subjs)
                        if isfield(bbstruct.(subjs{s}),'mean')
                            if isfield(bbstruct.(subjs{s}).mean,cond)
                                if (~strcmpi(subjs{s},'MEAN'))&&(bbstruct.(subjs{s}).kinematicsonly)&&(~strcmpi(bbanalysis,'ANGLEEVENTVALS')), continue; end 
                                dlen = length(bbstruct.(subjs{s}).mean.(cond).(bbanalysis).(quantlabel).segments.(bbmeta.dirs{c}));
                                if dlen>dcols, dcols=dlen; end
                            end
                        end
                    end
                end

                % sheet header row (means)
                xldata.(cond).(bbanalysis).(quantlabel)(1,:) = ['Type','Subject','Quantity','Direction','Values',num2cell(NaN(1,dcols-1))];                                                       
                
                % write data to long form table, padding columns where necessary
                x = 2;
                for m=1:2
                    sdtype = SDATA{m};
                    sdname = SNAME{m};
                    for s=1:length(subjs)
                        if isfield(bbstruct.(subjs{s}),sdtype)                            
                            if isfield(bbstruct.(subjs{s}).(sdtype),cond)                                       

                                % skip kinetics if kinematics only
                                if (~strcmpi(subjs{s},'MEAN'))&&(bbstruct.(subjs{s}).kinematicsonly)&&(~strcmpi(bbanalysis,'ANGLEEVENTVALS')), continue; end                                 
                                
                                % allocate
                                dcellvec = cell(15,4+dcols);

                                % net
                                r = 1;
                                for c=1:3
                                    dval = [bbstruct.(subjs{s}).(sdtype).(cond).(bbanalysis).(quantlabel).net(c), NaN(1,dcols-1)];
                                    dcellvec(r,:) = [sdname,subjs{s},'net',bbmeta.dirs{c},num2cell(dval)];
                                    r = r + 1;
                                end                            

                                % positive
                                for c=1:3
                                    dval = [bbstruct.(subjs{s}).(sdtype).(cond).(bbanalysis).(quantlabel).positive(c), NaN(1,dcols-1)];
                                    dcellvec(r,:) = [sdname,subjs{s},'positive',bbmeta.dirs{c},num2cell(dval)];
                                    r = r + 1;
                                end

                                % negative
                                for c=1:3
                                    dval = [bbstruct.(subjs{s}).(sdtype).(cond).(bbanalysis).(quantlabel).negative(c), NaN(1,dcols-1)];
                                    dcellvec(r,:) = [sdname,subjs{s},'negative',bbmeta.dirs{c},num2cell(dval)];
                                    r = r + 1;
                                end                            

                                % half
                                for c=1:3
                                    dval = [bbstruct.(subjs{s}).(sdtype).(cond).(bbanalysis).(quantlabel).half(:,c)', NaN(1,dcols-2)];
                                    dcellvec(r,:) = [sdname,subjs{s},'half',bbmeta.dirs{c},num2cell(dval)];
                                    r = r + 1;
                                end                              

                                % segments
                                for c=1:3
                                    dval = bbstruct.(subjs{s}).(sdtype).(cond).(bbanalysis).(quantlabel).segments.(bbmeta.dirs{c});
                                    if isempty(dval), dval = 0; end;
                                    dlen = length(dval);
                                    dval = [dval, NaN(1,dcols-dlen)];
                                    dcellvec(r,:) = [sdname,subjs{s},'segments',bbmeta.dirs{c},num2cell(dval)];
                                    r = r + 1;
                                end     
                                
                                % append table to sheet
                                xldata.(cond).(bbanalysis).(quantlabel)(x:x+14,:) = dcellvec;
                                x = x + 15;

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
            for b=1:length(bbmeta.BBANALYSES)        
                bbanalysis = upper(bbmeta.BBANALYSES{b});
                if all(~strcmpi(bbanalysis,{'ROTIMPULSE','ROTWORK'})), continue; end       % skip if not RotImpulse or RotWork                        
                s = 1;
                xlsname = [upper(subjprefix) '_' upper(trialprefix) '_' cond '_' bbanalysis '.xlsx'];                
                for q=1:length(bbmeta.(bbanalysis))
                    quantlabel = bbmeta.(bbanalysis){q};                    
                    sheetname = [quantlabel '_' bbmeta.units.(bbanalysis)];
                    writecell(xldata.(cond).(bbanalysis).(quantlabel),[xlspath '\XLS\' xlsname],'FileType','spreadsheet','Sheet',sheetname);                        
                    s = s + 1;
                end
            end
        end
    end    
                                                                                    
 
end



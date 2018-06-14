function writeXLSAllTrialsAnalysesGroups(bbstruct,bbmeta,user)


%writeXLSAllTrialsAnalysesGroups: write individual trial data to XLS
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
    subjs = fieldnames(bbstruct);    
    for b=1:length(bbmeta.BBANALYSES)
        bbanalysis = upper(bbmeta.BBANALYSES{b});
        
        % skip if not RotImpulse
        if ~strcmpi(bbanalysis,'ROTIMPULSE'), continue; end;        
        
        for q=1:length(bbmeta.(bbanalysis))
            quantlabel = bbmeta.(bbanalysis){q};

            % determine number of columns
            dcols = 1;                            
            for d=1:3
                for s=1:length(subjs)
                    subj = subjs{s};
                    if isempty(find(strcmpi(subj,'MEAN'),1))
                        affected = bbstruct.(subj).affected;
                        trials = fieldnames(bbstruct.(subj));
                        for t=1:length(trials)                        
                            trial = trials{t};
                            if isempty(find(strcmpi(trials{t},bbmeta.SUBJECTFIELDS),1))
                                analysedlegs = bbstruct.(subj).(trial).analysedlegs;
                                for z=1:analysedlegs

                                    % trial limbs
                                    if analysedlegs==1
                                        tlimb = bbstruct.(subj).(trial).triallimb;                                      
                                    else
                                        tlimb = bbstruct.(subj).(trial).triallimb{z};
                                    end
                                    tlabel = [tlimb quantlabel];

                                    % get vector length
                                    if analysedlegs==1
                                        dlen = length(bbstruct.(subjs{s}).(trials{t}).data.(bbanalysis).(tlabel).segments.(bbmeta.dirs{d}));
                                    else
                                        dlen = length(bbstruct.(subjs{s}).(trials{t}).data{z}.(bbanalysis).(tlabel).segments.(bbmeta.dirs{d}));
                                    end
                                    if dlen>dcols, dcols=dlen; end; 

                                end
                            end
                        end
                    end
                end
            end                


            % sheet header row (means)
            xldata.(bbanalysis).(quantlabel)(1,:) = ['Subject','Trial','TrialLimb','Affected','Quantity','Direction','Values',num2cell(NaN(1,dcols-1))];                                       

            % get trial data
            x = 2;
            subjs = fieldnames(bbstruct);    
            for s=1:length(subjs)                        
                subj = subjs{s};
                if isempty(find(strcmpi(subj,'MEAN'),1))
                    affected = bbstruct.(subj).affected;
                    trials = fieldnames(bbstruct.(subj));
                    for t=1:length(trials)                        
                        trial = trials{t};
                        if isempty(find(strcmpi(trials{t},bbmeta.SUBJECTFIELDS),1))
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
                                    substrct = bbstruct.(subjs{s}).(trials{t}).data;
                                else
                                    substrct = bbstruct.(subjs{s}).(trials{t}).data{z};
                                end


                                % allocate
                                dcellvec = cell(15,6+dcols);

                                % net
                                r = 1;
                                for c=1:3
                                    dval = [substrct.(bbanalysis).(tlabel).net(c), NaN(1,dcols-1)];
                                    dcellvec(r,:) = [subjs{s},trials{t},tlimb,affected,'net',bbmeta.dirs{c},num2cell(dval)];
                                    r = r + 1;
                                end                            

                                % positive
                                for c=1:3
                                    dval = [substrct.(bbanalysis).(tlabel).positive(c), NaN(1,dcols-1)];
                                    dcellvec(r,:) = [subjs{s},trials{t},tlimb,affected,'positive',bbmeta.dirs{c},num2cell(dval)];
                                    r = r + 1;
                                end

                                % negative
                                for c=1:3
                                    dval = [substrct.(bbanalysis).(tlabel).negative(c), NaN(1,dcols-1)];
                                    dcellvec(r,:) = [subjs{s},trials{t},tlimb,affected,'negative',bbmeta.dirs{c},num2cell(dval)];
                                    r = r + 1;
                                end                            

                                % half
                                for c=1:3
                                    dval = [substrct.(bbanalysis).(tlabel).half(c), NaN(1,dcols-1)];
                                    dcellvec(r,:) = [subjs{s},trials{t},tlimb,affected,'half',bbmeta.dirs{c},num2cell(dval)];
                                    r = r + 1;
                                end                              

                                % segments
                                for c=1:3
                                    dval = substrct.(bbanalysis).(tlabel).segments.(bbmeta.dirs{c});
                                    dlen = length(dval);
                                    dval = [dval, NaN(1,dcols-dlen)];
                                    dcellvec(r,:) = [subjs{s},trials{t},tlimb,affected,'segments',bbmeta.dirs{c},num2cell(dval)];
                                    r = r + 1;
                                end           

                                % append table to sheet
                                xldata.(bbanalysis).(quantlabel)(x:x+14,:) = dcellvec;
                                x = x + 15;

                            end

                        else
                            continue;
                        end
                    end
                end       
            end      
        end
    end
                                                                                

    % write Excel spreadsheet
    mkdir(xlspath);
    mkdir([xlspath '\XLS\']);
    for b=1:length(bbmeta.BBANALYSES)
        bbanalysis = upper(bbmeta.BBANALYSES{b});
        if ~strcmpi(bbanalysis,'ROTIMPULSE'), continue; end; 
        s = 1;
        xlsname = [xlsprefix '_ALLTRIALS_' bbanalysis '.xlsx'];                
        for q=1:length(bbmeta.(bbanalysis))
            quantlabel = bbmeta.(bbanalysis){q};
            xlswrite([xlspath '\XLS\' xlsname],xldata.(bbanalysis).(quantlabel),s);
            s = s + 1;
        end
    end
    
    % rename sheets using actxserver
    for b=1:length(bbmeta.BBANALYSES)
        bbanalysis = upper(bbmeta.BBANALYSES{b});
        if ~strcmpi(bbanalysis,'ROTIMPULSE'), continue; end;                   
        s = 1;
        xlsname = [xlsprefix '_ALLTRIALS_' bbanalysis '.xlsx'];
        xl = actxserver('Excel.Application'); 
        wb = xl.Workbooks.Open([xlspath '\XLS\' xlsname]);                
        for q=1:length(bbmeta.(bbanalysis))
            quantlabel = bbmeta.(bbanalysis){q};
            wb.Worksheets.Item(s).Name = [quantlabel '_' bbmeta.units.(bbanalysis)];
            s = s + 1;
        end
        wb.Save;
        wb.Close(false);        
        xl.Quit; 
    end   
    
    
end



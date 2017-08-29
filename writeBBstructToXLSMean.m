function writeBBstructToXLSMean(bbstruct,bbmeta,user)


%writeBBstructToXLS write BodyBuilder data to Excel workbook
%   Prasanna Sritharan, June 2017
    
    warning('off');

    % assign struct fields
    xlsprefix = user.TRIALPREFIX;
    xlspath = user.OUTPUTPATH;
    samp = user.SAMP;
    
    
    
    % data for write
    DTYPE = {'MEAN','SD'};
    
    % collate data
    subjs = fieldnames(bbstruct);    
    for b=1:length(bbmeta.BBGROUPS)
        for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
            quantlabel = bbmeta.(bbmeta.BBGROUPS{b}){q};
            for f=1:2
                cond = bbmeta.conditions{f};
                for c=1:length(bbmeta.dirs)

                    % sheet header row (means)
                    xldata.(cond).(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c})(1,:) = ['Type', ...
                                                                                             'Time', ...
                                                                                             cellfun(@(z)num2str(z,'%i'),num2cell(1:samp),'UniformOutput',false)];                                       

                    % get means
                    r = 2;
                    for s=1:length(subjs)
                        if isfield(bbstruct.(subjs{s}).mean,cond)

                            % get data
                            xldata.(cond).(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c})(r,:) = ['Mean', ...
                                                                                                     subjs{s}, ...
                                                                                                     cellfun(@(z)num2str(z,'%12.8f'),num2cell(bbstruct.(subjs{s}).mean.(cond).(bbmeta.BBGROUPS{b}).(quantlabel)(:,c))','UniformOutput',false)];                        

                            % increment row
                            r = r + 1;

                        end
                    end                    
                    
                    % sheet header row (sds)
                    r = r + 1;
                    xldata.(cond).(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c})(r,:) = ['Type', ...
                                                                                             'Time', ...
                                                                                             cellfun(@(z)num2str(z,'%i'),num2cell(1:samp),'UniformOutput',false)];                          
                                        
                    % get sds
                    r = r + 1;
                    for s=1:length(subjs)
                        if isfield(bbstruct.(subjs{s}).sd,cond)

                            % get data
                            xldata.(cond).(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c})(r,:) = ['Stdev', ...
                                                                                                     subjs{s}, ...
                                                                                                     cellfun(@(z)num2str(z,'%12.8f'),num2cell(bbstruct.(subjs{s}).sd.(cond).(bbmeta.BBGROUPS{b}).(quantlabel)(:,c))','UniformOutput',false)];                        

                            % increment row
                            r = r + 1;

                        end
                    end
                    
                end
            end
        end
    end
                                                                                
    
    % write Excel spreadsheet
    mkdir(xlspath);
    for f=1:2
        cond = bbmeta.conditions{f};
        if isfield(xldata,cond)
            s = 1;
            xlsname = [xlsprefix '_' cond '.xlsx'];
            for b=1:length(bbmeta.BBGROUPS)
                for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
                    quantlabel = bbmeta.(bbmeta.BBGROUPS{b}){q};
                    for c=1:length(bbmeta.dirs)
                        xlswrite([xlspath '\' xlsname],xldata.(cond).(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c}),s);
                        s = s + 1;
                    end
                end
            end
        end
    end
    
    % rename sheets using actxserver
    for f=1:2
        cond = bbmeta.conditions{f};
        if isfield(xldata,cond)        
            s = 1;
            xlsname = [xlsprefix '_' cond '.xlsx'];
            xl = actxserver('Excel.Application'); 
            wb = xl.Workbooks.Open([xlspath '\' xlsname]);
            for b=1:length(bbmeta.BBGROUPS)
                for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
                    quantlabel = bbmeta.(bbmeta.BBGROUPS{b}){q};
                    for c=1:length(bbmeta.dirs)
                        wb.Worksheets.Item(s).Name = [quantlabel '_' bbmeta.dirs{c} '_' bbmeta.units.(bbmeta.BBGROUPS{b})];
                        s = s + 1;
                    end            
                end
            end
            wb.Save;
            wb.Close(false);        
            xl.Quit;    
        end
    end    
   
    
    
end



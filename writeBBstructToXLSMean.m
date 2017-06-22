function writeBBstructToXLSMean(bbstruct,bbmeta,xlsprefix,xlspath,samp)


%writeBBstructToXLS write BodyBuilder data to Excel workbook
%   Prasanna Sritharan, June 2017
    
    warning('off');

    % collate data
    subjs = fieldnames(bbstruct);    
    for b=1:length(bbmeta.BBGROUPS)
        for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
            quantlabel = bbmeta.(bbmeta.BBGROUPS{b}){q};
            for f=1:2                
                for c=1:length(bbmeta.dirs)

                    % sheet header row
                    xldata.(bbmeta.conditions{f}).(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c})(1,:) = ['Time', ...
                                                                                                             cellfun(@(z)num2str(z,'%i'),num2cell(1:samp),'UniformOutput',false)];                                       

                    % get subj means
                    r = 2;
                    for s=1:length(subjs)

                        % get data
                        xldata.(bbmeta.conditions{f}).(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c})(r,:) = [subjs{s}, ...
                                                                                                                 cellfun(@(z)num2str(z,'%12.8f'),num2cell(bbstruct.(subjs{s}).mean.(bbmeta.conditions{f}).(bbmeta.BBGROUPS{b}).(quantlabel)(:,c))','UniformOutput',false)];                        
                                                                                     
                        % increment row
                        r = r + 1;

                    end
                end
            end
        end
    end
                                                                                
    
    % write Excel spreadsheet
    for f=1:2
        s = 1;
        xlsname = [xlsprefix '_' bbmeta.conditions{f} '.xlsx'];
        for b=1:length(bbmeta.BBGROUPS)
            for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
                quantlabel = bbmeta.(bbmeta.BBGROUPS{b}){q};
                for c=1:length(bbmeta.dirs)
                    xlswrite([xlspath '\' xlsname],xldata.(bbmeta.conditions{f}).(bbmeta.BBGROUPS{b}).(quantlabel).(bbmeta.dirs{c}),s);
                    s = s + 1;
                end
            end
        end
    end
    
    % rename sheets using actxserver
    for f=1:2
        s = 1;
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



function writeBBstructToXLSMean(bbstruct,bbmeta,xlsname,xlspath,samp)


%writeBBstructToXLS write BodyBuilder data to Excel workbook
%   Prasanna Sritharan, June 2017
    
    warning('off');

    % collate data
    subjs = fieldnames(bbstruct);    
    for b=1:length(bbmeta.BBGROUPS)
        for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
            for f=1:2
                quantname = [bbmeta.limbs{f} bbmeta.(bbmeta.BBGROUPS{b}){q}];
                for c=1:length(bbmeta.dirs)

                    % sheet header row
                    xldata.(bbmeta.BBGROUPS{b}).(quantname).(bbmeta.dirs{c})(1,:) = ['Time', ...
                                                                                     cellfun(@(z)num2str(z,'%i'),num2cell(1:samp),'UniformOutput',false)];                                       

                    % get subj means
                    r = 2;
                    for s=1:length(subjs)

                        % get data
                        xldata.(bbmeta.BBGROUPS{b}).(quantname).(bbmeta.dirs{c})(r,:) = [subjs{s}, ...
                                                                                         cellfun(@(z)num2str(z,'%12.8f'),num2cell(bbstruct.(subjs{s}).mean.(bbmeta.BBGROUPS{b}).(quantname)(:,c))','UniformOutput',false)];                        

                        % increment row
                        r = r + 1;

                    end
                end
            end
        end
    end
                                                                                

    % add XLSX extension if necessary
    if isempty(regexpi(xlsname,'.xlsx')), xlsname = [xlsname '.xlsx']; end;    
    
    % write Excel spreadsheet
    s = 1;
    subjs = fieldnames(bbstruct);    
    for b=1:length(bbmeta.BBGROUPS)
        for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
            for f=1:2
                quantname = [bbmeta.limbs{f} bbmeta.(bbmeta.BBGROUPS{b}){q}];
                for c=1:length(bbmeta.dirs)
                    xlswrite([xlspath '\' xlsname],xldata.(bbmeta.BBGROUPS{b}).(quantname).(bbmeta.dirs{c}),s);
                    s = s + 1;
                end
            end
        end
    end

    
    % rename sheets using actxserver
    s = 1;
    xl = actxserver('Excel.Application');
    wb = xl.Workbooks.Open([xlspath '\' xlsname]);
    subjs = fieldnames(bbstruct);    
    for b=1:length(bbmeta.BBGROUPS)
        for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
            for f=1:2
                quantname = [bbmeta.limbs{f} bbmeta.(bbmeta.BBGROUPS{b}){q}];
                for c=1:length(bbmeta.dirs)
                    wb.Worksheets.Item(s).Name = [quantname '_' bbmeta.dirs{c} '_' bbmeta.units.(bbmeta.BBGROUPS{b})];
                    s = s + 1;
                end
            end
        end
    end    
    wb.Save;
    wb.Close(false);
    xl.Quit;    
    
    
end



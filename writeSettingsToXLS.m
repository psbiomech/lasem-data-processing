function writeSettingsToXLS(bbstruct,xlsname,xlspath)

%writeSettingsToXLS Create input spreadsheet from struct
%   Prasanna Sritharan, June 2017


    warning('off');

    
    % sheet header
    xldata(1,:) = {'Subject','Trial','Cohort','Affected','Trial Limb','First VFrame','Last VFrame','File Path'};
        
    % collate data
    x = 2;
    subjs = fieldnames(bbstruct);    
    for s=1:length(subjs)
        trials = fieldnames(bbstruct.(subjs{s}));
        for t=1:length(trials)
            if isempty(find(strcmpi(trials{t},{'cohort','affected'}),1))
                xldata(x,:) = {subjs{s}, trials{t}, bbstruct.(subjs{s}).cohort, bbstruct.(subjs{s}).affected, bbstruct.(subjs{s}).(trials{t}).triallimb, num2str(bbstruct.(subjs{s}).(trials{t}).vfrange(1)), num2str(bbstruct.(subjs{s}).(trials{t}).vfrange(2)), bbstruct.(subjs{s}).(trials{t}).filepath};
                x = x + 1;
            end
        end
    end
                                                                                

    % add XLSX extension if necessary
    if isempty(regexpi(xlsname,'.xlsx')), xlsname = [xlsname '.xlsx']; end;    
    
    % write Excel spreadsheet
    xlswrite([xlspath '\' xlsname],xldata);

end


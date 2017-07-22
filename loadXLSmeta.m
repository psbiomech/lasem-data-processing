function    bb = loadXLSmeta(xlsname,xlspath)

%loadXLSmeta Load settings/meta data into struct
%   Prasanna Sritharan, June 2017

    % add XLSX extension if necessary
    if isempty(regexpi(xlsname,'.xlsx')), xlsname = [xlsname '.xlsx']; end;  

    % load Excel file into struct
    [~,~,rawdata] = xlsread([xlspath '\' xlsname]);
    
    % build struct (assume Excel header row exists)
    bb = struct;
    for r=2:size(rawdata,1)
        if ~isfield(bb,rawdata{r,1})
            bb.(rawdata{r,1}).cohort = rawdata{r,3};
            bb.(rawdata{r,1}).affected = rawdata{r,4};
        end
        bb.(rawdata{r,1}).(rawdata{r,2}).triallimb = rawdata{r,5};
        bb.(rawdata{r,1}).(rawdata{r,2}).vfrange = [rawdata{r,6} rawdata{r,7}];
        bb.(rawdata{r,1}).(rawdata{r,2}).fpsequence = rawdata{r,8};
        bb.(rawdata{r,1}).(rawdata{r,2}).filepath = rawdata{r,9};
    end   

end


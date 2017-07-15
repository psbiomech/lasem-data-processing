function bbstruct = extractBBdata(inputtype,inp,bbmeta,amp,fm,samp,xlspath)


%extractBBdata Get BB data from C3D file, trim and resample
%   Prasanna Sritharan, June 2017

    % check inputs
    if (nargin==5)
        xlspath = [];
    end
        

    % get settings/meta data, determine action based on input type
    switch inputtype
        
        % as struct
        case 'struct'
            bbstruct = inp;

        % as Excel file
        case 'xls'
            bbstruct = loadXLSmeta(inp,xlspath);

    end

    % get Body Builder point from C3D files
    subjs = fieldnames(bbstruct);
    for s=1:length(subjs)
        trials = fieldnames(bbstruct.(subjs{s}));
        for t=1:length(trials)
            if isempty(find(strcmpi(trials{t},{'cohort','affected'}),1))
                [rawdatastruct,~] = pullBBpoint(bbstruct.(subjs{s}).(trials{t}).filepath,bbstruct.(subjs{s}).(trials{t}).vfrange,bbmeta,amp);    
                bbstruct = resampleBBdata(bbstruct,subjs{s},trials{t},rawdatastruct,samp);     
            else
                continue;
            end
        end
    end

    % get Body Builder point from C3D files
    subjs = fieldnames(bbstruct);
    for s=1:length(subjs)
        trials = fieldnames(bbstruct.(subjs{s}));
        for t=1:length(trials)
            if isempty(find(strcmpi(trials{t},{'cohort','affected'}),1))
                [rawdatastruct,~] = pullBBpoint(bbstruct.(subjs{s}).(trials{t}).filepath,bbstruct.(subjs{s}).(trials{t}).vfrange,bbmeta,amp);    
                bbstruct = resampleBBdata(bbstruct,subjs{s},trials{t},rawdatastruct,samp);     
            else
                continue;
            end
        end
    end    
    
    
    % get Body Builder analog from C3D files
    %subjs = fieldnames(bbstruct);
    %for s=1:length(subjs)
    %    trials = fieldnames(bbstruct.(subjs{s}));
    %    for t=1:length(trials)
    %        if isempty(find(strcmpi(trials{t},{'cohort','affected'}),1))
    %            [rawdatastruct,~] = pullBBanalog(bbstruct.(subjs{s}).(trials{t}).filepath,bbstruct.(subjs{s}).(trials{t}).vfrange,bbmeta,fm);    
    %            bbstruct = resampleBBdata(bbstruct,subjs{s},trials{t},rawdatastruct,samp);     
    %        else
    %            continue;
    %        end
    %    end
    %end    
    

end


function bbstruct = extractBBdata(inputtype,inp,bbmeta,amp,samp,actflag,xlspath)


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

    % get Body Builder data from C3D files
    subjs = fieldnames(bbstruct);
    for s=1:length(subjs)
        trials = fieldnames(bbstruct.(subjs{s}));
        for t=1:length(trials)
            if isempty(find(strcmpi(trials{t},{'cohort','affected'}),1))
                [rawdatastruct,triallimb,~] = pullBBpoint(subjs{s},trials{t},bbstruct.(subjs{s}).(trials{t}).filepath,bbmeta,amp,actflag);    
                bbstruct.(subjs{s}).(trials{t}) = resampleBBdata(rawdatastruct,samp);    
                bbstruct.(subjs{s}).(trials{t}).triallimb = triallimb;    
            else
                continue;
            end
        end
    end


end


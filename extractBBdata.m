function bbstruct = extractBBdata(inp,bbmeta,user)


%extractBBdata Get BB data from C3D file, trim and resample
%   Prasanna Sritharan, June 2017
    
    % assign struct fields
    inputtype = user.INPUTTYPE;
    ampg = user.AMPG;
    samp = user.SAMP;
    xlspath = user.DATAPATH;


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

    % get Body Builder point data from C3D files
    subjs = fieldnames(bbstruct);
    for s=1:length(subjs)
        trials = fieldnames(bbstruct.(subjs{s}));
        for t=1:length(trials)            
            if isempty(find(strcmpi(trials{t},{'cohort','affected'}),1))
                [rawdatastruct,~] = pullBBpoint(bbstruct.(subjs{s}).(trials{t}),bbmeta,ampg);    
                bbstruct = resampleBBdata(bbstruct,subjs{s},trials{t},rawdatastruct,samp);     
                bbstruct = addTimeVector(bbstruct,subjs{s},trials{t},samp);
            else
                continue;
            end
        end
    end                   

end


function bbstruct = extractBBdata(bbstruct,bbmeta,amp,samp)


%extractBBdata Get BB data from C3D file, trim and resample
%   Prasanna Sritharan, June 2017

    subjs = fieldnames(bbstruct);
    for s=1:length(subjs)
        trials = fieldnames(bbstruct.(subjs{s}));
        for t=1:length(trials)
            if ~strcmpi(trials{t},'triallimb')
                [rawdatastruct,triallimb,~] = pullBBpoint(bbstruct.(subjs{s}).(trials{t}).filepath,bbmeta,amp,samp);    
                bbstruct.(subjs{s}).(trials{t}) = resampleBBdata(rawdatastruct,samp);    
                bbstruct.(subjs{s}).(trials{t}).triallimb = triallimb;    
            else
                continue;
            end
        end
    end


end


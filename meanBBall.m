function bbstruct = meanBBall(bbstruct,bbmeta,ampg)

%meanBBsubject Calculates mean of all trials for all subjects
%   Prasanna Sritharan, June 2017

    % get desired output data groups
    outgrps = bbmeta.BBGROUPS(logical(ampg));        

    % collate individual means and sds
    subjs = fieldnames(bbstruct);
    alldata = struct;
    for s=1:length(subjs)    
        for b=1:length(outgrps)
            for q=1:length(bbmeta.(outgrps{b}))
                quantlabel = bbmeta.(outgrps{b}){q};
                for f=1:2
                    cond = bbmeta.conditions{f};
                    if isfield(bbstruct.(subjs{s}).mean,cond)
                        try
                            alldata.means.(cond).(outgrps{b}).(quantlabel)(:,:,s) = bbstruct.(subjs{s}).mean.(cond).(outgrps{b}).(quantlabel);
                            alldata.sds.(cond).(outgrps{b}).(quantlabel)(:,:,s) = bbstruct.(subjs{s}).sd.(cond).(outgrps{b}).(quantlabel);
                        catch                            
                            disp(['ERROR: Unable to process quantity ' quantname ' for ' subjs{s} '.'])  ;
                        end
                    end
                end
            end
        end
    end

    
    % calculate mean and sd for all data
    % mean: mean of individual subject means
    % sd: sqrt of sum of squares of individual subject sds
    for b=1:length(outgrps)
        for q=1:length(bbmeta.(outgrps{b}))
            quantlabel = bbmeta.(outgrps{b}){q};
            for c=1:2
                cond = bbmeta.conditions{c};
                if isfield(alldata.means,cond)
                    bbstruct.MEAN.mean.(cond).(outgrps{b}).(quantlabel) = mean(alldata.means.(cond).(outgrps{b}).(quantlabel),3);
                    bbstruct.MEAN.sd.(cond).(outgrps{b}).(quantlabel) = sqrt(sum((alldata.sds.(cond).(outgrps{b}).(quantlabel)).^2,3));
                end
            end
        end
    end            
        

    
end


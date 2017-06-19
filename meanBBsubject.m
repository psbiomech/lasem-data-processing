function bbstruct = meanBBsubject(bbstruct,bbmeta)

%meanBBsubject Calculates mean of all trials per subject
%   Prasanna Sritharan, June 2017

    subjs = fieldnames(bbstruct);
    for s=1:length(subjs)
    
        % get list of trials
        trials = fieldnames(bbstruct.(subjs{s}));
        ntrials = length(trials);

        % collate data
        alldata = struct;
        for b=1:length(bbmeta.BBGROUPS)
            for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
                for f=1:2
                    quantname = [bbmeta.limbs{f} bbmeta.(bbmeta.BBGROUPS{b}){q}];
                    t = 1;
                    for n = 1:ntrials
                        try
                            if isempty(find(strcmpi(trials{n},{'cohort','affected'}),1))
                                alldata.(bbmeta.BBGROUPS{b}).(quantname)(:,:,t) = bbstruct.(subjs{s}).(trials{n}).(bbmeta.BBGROUPS{b}).(quantname);
                                t = t + 1;
                            else
                                continue;
                            end
                        catch
                            disp(['ERROR: Unable to process quantity ' quantname ' for ' subjs{s} ' ' trials{n} '.'])  ;
                        end                           
                    end
                end
            end
        end

        % calculate mean and sd
        for b=1:length(bbmeta.BBGROUPS)
            for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
                for f=1:2
                    quantname = [bbmeta.limbs{f} bbmeta.(bbmeta.BBGROUPS{b}){q}];
                    bbstruct.(subjs{s}).mean.(bbmeta.BBGROUPS{b}).(quantname) = mean(alldata.(bbmeta.BBGROUPS{b}).(quantname),3);
                    bbstruct.(subjs{s}).sd.(bbmeta.BBGROUPS{b}).(quantname) = std(alldata.(bbmeta.BBGROUPS{b}).(quantname),0,3);
            
                end
            end
        end    
    end
    
end


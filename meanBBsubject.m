function bbstruct = meanBBsubject(bbstruct,bbmeta)

%meanBBsubject Calculates mean of all trials per subject
%   Prasanna Sritharan, June 2017

    subjs = fieldnames(bbstruct);
    for s=1:length(subjs)
    
        % get list of trials
        trials = fieldnames(bbstruct.(subjs{s}));
        ntrials = length(trials);

        % collate video data
        alldata = struct;
        for b=1:length(bbmeta.BBGROUPS)
            for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
                for f=1:2
                    quantlabel = bbmeta.(bbmeta.BBGROUPS{b}){q};
                    quantname = [bbmeta.limbs{f} quantlabel];
                    t1 = 1;
                    t2 = 1;
                    for n = 1:ntrials
                        try
                            if isempty(find(strcmpi(trials{n},{'cohort','affected'}),1))
                                if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbmeta.limbs{f})
                                    if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbstruct.(subjs{s}).affected)
                                        alldata.(bbmeta.conditions{1}).(bbmeta.BBGROUPS{b}).(quantlabel)(:,:,t1) = bbstruct.(subjs{s}).(trials{n}).(bbmeta.BBGROUPS{b}).(quantname);
                                        t1 = t1 + 1;
                                    else
                                        alldata.(bbmeta.conditions{2}).(bbmeta.BBGROUPS{b}).(quantlabel)(:,:,t2) = bbstruct.(subjs{s}).(trials{n}).(bbmeta.BBGROUPS{b}).(quantname);
                                        t2 = t2 + 1;
                                    end
                                end
                            else
                                continue;
                            end
                        catch exception
                            rethrow(exception);
                            disp(['ERROR: Unable to process quantity ' quantname ' for ' subjs{s} ' ' trials{n} '.'])  ;
                        end                           
                    end
                end
            end
        end

        % calculate mean and sd for video data
        for b=1:length(bbmeta.BBGROUPS)
            for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
                for c=1:2
                    quantlabel = bbmeta.(bbmeta.BBGROUPS{b}){q};
                    bbstruct.(subjs{s}).mean.(bbmeta.conditions{c}).(bbmeta.BBGROUPS{b}).(quantlabel) = mean(alldata.(bbmeta.conditions{c}).(bbmeta.BBGROUPS{b}).(quantlabel),3);
                    bbstruct.(subjs{s}).sd.(bbmeta.conditions{c}).(bbmeta.BBGROUPS{b}).(quantlabel) = std(alldata.(bbmeta.conditions{c}).(bbmeta.BBGROUPS{b}).(quantlabel),0,3);            
                end
            end
        end    
        
        
        
        % collate analog data
        for b=1:length(bbmeta.BBANALOGS)
            for q=1:length(bbmeta.(bbmeta.BBANALOGS{b}))
                for f=1:2
                    quantlabel = bbmeta.(bbmeta.BBGROUPS{b}){q};
                    quantname = [bbmeta.limbs{f} quantlabel];
                    t1 = 1;
                    t2 = 1;
                    for n = 1:ntrials
                        try
                            if isempty(find(strcmpi(trials{n},{'cohort','affected'}),1))
                                if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbmeta.limbs{f})
                                    if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbstruct.(subjs{s}).affected)
                                        alldata.(bbmeta.conditions{1}).(bbmeta.BBGROUPS{b}).(quantlabel)(:,:,t1) = bbstruct.(subjs{s}).(trials{n}).(bbmeta.BBGROUPS{b}).(quantname);
                                        t1 = t1 + 1;
                                    else
                                        alldata.(bbmeta.conditions{2}).(bbmeta.BBGROUPS{b}).(quantlabel)(:,:,t2) = bbstruct.(subjs{s}).(trials{n}).(bbmeta.BBGROUPS{b}).(quantname);
                                        t2 = t2 + 1;
                                    end
                                end
                            else
                                continue;
                            end
                        catch exception
                            rethrow(exception);
                            disp(['ERROR: Unable to process quantity ' quantname ' for ' subjs{s} ' ' trials{n} '.'])  ;
                        end                           
                    end
                end
            end
        end        
        
        
    end
    
end


function bbstruct = meanBBsubject(bbstruct,bbmeta,ampg)

%meanBBsubject Calculates mean of all trials per subject
%   Prasanna Sritharan, June 2017

    % get desired output data groups
    outgrps = bbmeta.BBGROUPS(logical(ampg));        

    % collate data
    subjs = fieldnames(bbstruct);
    for s=1:length(subjs)
    
        % get list of trials
        trials = fieldnames(bbstruct.(subjs{s}));
        ntrials = length(trials);
        
        % collate point data
        alldata = struct;
        for b=1:length(outgrps)
            for q=1:length(bbmeta.(outgrps{b}))
                
                % collate data based on point data type
                switch outgrps{b}
                    
                    % Body Builder GRF point data
                    case 'GRFS'
                        fpnums = regexp(vlist,[bbmeta.fpvectors{1} '(\d+)'],'tokens');
                        fpnums = fpnums(~cellfun('isempty',fpnums)); 
                        %point.activefp = zeros(length(fpnums));
                        for f = 1:length(fpnums)                    
                            quantlabel = [bbmeta.(outgrps{b}){q} num2str(f)];
                            t1 = 1;
                            t2 = 1;
                            for n = 1:ntrials
                                try
                                    if isempty(find(strcmpi(trials{n},{'cohort','affected'}),1))
                                        if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbmeta.limbs{f})
                                            if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbstruct.(subjs{s}).affected)
                                                alldata.(bbmeta.conditions{1}).(outgrps{b}).(quantlabel)(:,:,t1) = bbstruct.(subjs{s}).(trials{n}).(outgrps{b}).(quantname);
                                                t1 = t1 + 1;
                                            else
                                                alldata.(bbmeta.conditions{2}).(outgrps{b}).(quantlabel)(:,:,t2) = bbstruct.(subjs{s}).(trials{n}).(outgrps{b}).(quantname);
                                                t2 = t2 + 1;
                                            end
                                        end
                                    else
                                        continue;
                                    end
                                   
                                catch
                                end
                                
                            end
                        end
                            
                        
                    % all other Body Builder data
                    otherwise
                        for f=1:2
                            quantlabel = bbmeta.(outgrps{b}){q};
                            quantname = [bbmeta.limbs{f} quantlabel];
                            t1 = 1;
                            t2 = 1;
                            for n = 1:ntrials
                                try
                                    if isempty(find(strcmpi(trials{n},{'cohort','affected'}),1))
                                        if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbmeta.limbs{f})
                                            if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbstruct.(subjs{s}).affected)
                                                alldata.(bbmeta.conditions{1}).(outgrps{b}).(quantlabel)(:,:,t1) = bbstruct.(subjs{s}).(trials{n}).(outgrps{b}).(quantname);
                                                t1 = t1 + 1;
                                            else
                                                alldata.(bbmeta.conditions{2}).(outgrps{b}).(quantlabel)(:,:,t2) = bbstruct.(subjs{s}).(trials{n}).(outgrps{b}).(quantname);
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

        % calculate mean and sd for point data
        for b=1:length(outgrps)
            for q=1:length(bbmeta.(outgrps{b}))
                for c=1:2
                    quantlabel = bbmeta.(outgrps{b}){q};
                    bbstruct.(subjs{s}).mean.(bbmeta.conditions{c}).(outgrps{b}).(quantlabel) = mean(alldata.(bbmeta.conditions{c}).(outgrps{b}).(quantlabel),3);
                    bbstruct.(subjs{s}).sd.(bbmeta.conditions{c}).(outgrps{b}).(quantlabel) = std(alldata.(bbmeta.conditions{c}).(outgrps{b}).(quantlabel),0,3);            
                end
            end
        end            
        
    end
    
end


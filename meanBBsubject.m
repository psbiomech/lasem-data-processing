function [meandata,sddata] = meanBBsubject(subjstruct,bbmeta)

%meanBBsubject Calculates mean of all trials per subject
%   Prasanna Sritharan, June 2017


    % get list of trials
    trials = fieldnames(subjstruct);
    ntrials = length(trials);

    % collate data
    for b=1:length(bbmeta.BBGROUPS)
        for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
            quantname = bbmeta.(bbmeta.BBGROUPS{b}){q};
            for n = 1:ntrials
                try
                    alldata.(bbmeta.BBGROUPS{b}).(quantname)(:,:,n) = subjstruct.(trials{n}).(bbmeta.BBGROUPS{b}).(quantname);
                catch
                    disp(['ERROR: Unable to process quantity ' quantname ' for trial ' trials{n} '.'])  ;
                end                           
            end
        end
    end

    % calculate mean and sd
    for b=1:length(bbmeta.BBGROUPS)
        for q=1:length(bbmeta.(bbmeta.BBGROUPS{b}))
            quantname = bbmeta.(bbmeta.BBGROUPS{b}){q};
            meandata.(bbmeta.BBGROUPS{b}).(quantname) = mean(alldata.(bbmeta.BBGROUPS{b}).(quantname),3);
            sddata.(bbmeta.BBGROUPS{b}).(quantname) = std(alldata.(bbmeta.BBGROUPS{b}).(quantname),0,3);
        end
    end    
    
    
end


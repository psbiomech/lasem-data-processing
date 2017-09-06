function bbstruct = analysis_mean_eventval_angle(bbstruct,bbmeta)


%analysis_eventval_grf Subject and total means for GRF values at events
%   Prasanna Sritharan, August 2017

    % input data group name
    DATAGRP = upper(bbmeta.BBANALYSES{4}); 
    SRCGRP = bbmeta.BBGROUPS{1};      

    
    % ********************
    % SUBJECT MEANS    
    
    % collate trials
    subjs = fieldnames(bbstruct);
    for s=1:length(subjs)

        % get list of trials        
        trials = fieldnames(bbstruct.(subjs{s}));
        ntrials = length(trials);        
        
        % collate point data
        alldata = struct;       
        for q=1:length(bbmeta.(SRCGRP))
            for f=1:2                
                quantlabel = bbmeta.(SRCGRP){q};                               
                quantname = [bbmeta.limbs{f} quantlabel];
                t1 = 1;
                t2 = 1;
                for n = 1:ntrials
                    try
                        if isempty(find(strcmpi(trials{n},{'cohort','affected','mean','sd'}),1))
                            if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbmeta.limbs{f})
                                if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbstruct.(subjs{s}).affected)
                                    cond1 = bbmeta.conditions{1};
                                    alldata.(cond1).(DATAGRP).(quantlabel)(:,:,t1) = bbstruct.(subjs{s}).(trials{n}).(DATAGRP).(quantname);
                                    t1 = t1 + 1;
                                else
                                    cond2 = bbmeta.conditions{2};
                                    alldata.(cond2).(DATAGRP).(quantlabel)(:,:,t2) = bbstruct.(subjs{s}).(trials{n}).(DATAGRP).(quantname);
                                    t2 = t2 + 1;
                                end
                            end
                        else
                            continue;
                        end
                    catch                            
                        disp(['ERROR: Unable to process quantity ' quantname ' for ' subjs{s} ' ' trials{n} '.'])  ;
                    end                           
                end
            end                                        
        end
    
        % calculate mean and sd for point data
        for q=1:length(bbmeta.(SRCGRP))
            quantlabel = bbmeta.(SRCGRP){q};                
            for c=1:2
                cond = bbmeta.conditions{c};
                if isfield(alldata,bbmeta.conditions{c})
                    bbstruct.(subjs{s}).mean.(cond).(DATAGRP).(quantlabel) = mean(alldata.(cond).(DATAGRP).(quantlabel),3);
                    bbstruct.(subjs{s}).sd.(cond).(DATAGRP).(quantlabel) = std(alldata.(cond).(DATAGRP).(quantlabel),0,3);                                 
                end
            end
        end    
        
    end
    
   
    
    % ********************
    % TOTAL MEANS      
    
    % collate individual means and sds
    subjs = fieldnames(bbstruct);
    alldata = struct;
    for s=1:length(subjs)   
        if isempty(find(strcmpi(subjs{s},{'MEAN'}),1))
            for q=1:length(bbmeta.(SRCGRP))
                quantlabel = bbmeta.(SRCGRP){q}; 
                for f=1:2
                    cond = bbmeta.conditions{f};
                    if isfield(bbstruct.(subjs{s}).mean,cond)
                        try                            
                            alldata.means.(cond).(DATAGRP).(quantlabel)(:,:,s) = bbstruct.(subjs{s}).mean.(cond).(DATAGRP).(quantlabel);
                            alldata.sds.(cond).(DATAGRP).(quantlabel)(:,:,s) = bbstruct.(subjs{s}).sd.(cond).(DATAGRP).(quantlabel);
                        catch
                            disp(['ERROR: Unable to process quantity ' quantlabel ' for condition ' cond ' for subject ' subjs{s} '.'])  ;
                        end
                    end
                end
            end
        else    
            continue;
        end
    end        
    
    % calculate mean and sd for all data
    % mean: mean of individual subject means
    % sd: sqrt of sum of squares of individual subject sds
    for q=1:length(bbmeta.(SRCGRP))
        quantlabel = bbmeta.(SRCGRP){q}; 
        for c=1:2
            cond = bbmeta.conditions{c};
            if isfield(alldata.means,cond)
                bbstruct.MEAN.mean.(cond).(DATAGRP).(quantlabel) = mean(alldata.means.(cond).(DATAGRP).(quantlabel),3);
                bbstruct.MEAN.sd.(cond).(DATAGRP).(quantlabel) = sqrt(sum((alldata.sds.(cond).(DATAGRP).(quantlabel)).^2,3));                                
            end
        end
    end   
        
end

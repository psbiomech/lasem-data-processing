function bbstruct = analysis_mean_work_rotational(bbstruct,bbmeta)


%analysis_mean_work_rotational Means for joint rotational work
%   Prasanna Sritharan, August 2017
     
    % input data group name
    DATAGRP = upper(bbmeta.BBANALYSES{1});
    SRCGRP = bbmeta.BBGROUPS{3};
    
    % midstring
    DATAMIDSTR = bbmeta.BBANALYSES{1};    
    SRCMIDSTR = SRCGRP(1:end-1);
    
    
    % collate data
    subjs = fieldnames(bbstruct);
    for s=1:length(subjs)

        % get list of trials        
        trials = fieldnames(bbstruct.(subjs{s}));
        ntrials = length(trials);        
        
        % collate point data
        alldata = struct;       
        for q=1:length(bbmeta.(SRCGRP))
            for f=1:2                
                qpresuf = regexpi(bbmeta.(SRCGRP){q},['(\w*)' SRCMIDSTR '(\w*)'],'tokens');
                quantlabel = [qpresuf{1}{1} DATAMIDSTR qpresuf{1}{2}];                               
                quantname = [bbmeta.limbs{f} quantlabel];
                t1 = 1;
                t2 = 1;
                for n = 1:ntrials
                    try
                        if isempty(find(strcmpi(trials{n},{'cohort','affected','mean','sd'}),1))
                            if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbmeta.limbs{f})
                                if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbstruct.(subjs{s}).affected)
                                    alldata.(bbmeta.conditions{1}).(DATAGRP).(quantlabel).net(:,t1) = bbstruct.(subjs{s}).(trials{n}).(DATAGRP).(quantname).net;
                                    alldata.(bbmeta.conditions{1}).(DATAGRP).(quantlabel).positive(:,t1) = bbstruct.(subjs{s}).(trials{n}).(DATAGRP).(quantname).positive;
                                    alldata.(bbmeta.conditions{1}).(DATAGRP).(quantlabel).negative(:,t1) = bbstruct.(subjs{s}).(trials{n}).(DATAGRP).(quantname).negative;
                                    alldata.(bbmeta.conditions{1}).(DATAGRP).(quantlabel).half(:,:,t1) = bbstruct.(subjs{s}).(trials{n}).(DATAGRP).(quantname).half;
                                    t1 = t1 + 1;
                                else
                                    alldata.(bbmeta.conditions{2}).(DATAGRP).(quantlabel).net(:,t2) = bbstruct.(subjs{s}).(trials{n}).(DATAGRP).(quantname).net;
                                    alldata.(bbmeta.conditions{2}).(DATAGRP).(quantlabel).positive(:,t2) = bbstruct.(subjs{s}).(trials{n}).(DATAGRP).(quantname).positive;
                                    alldata.(bbmeta.conditions{2}).(DATAGRP).(quantlabel).negative(:,t2) = bbstruct.(subjs{s}).(trials{n}).(DATAGRP).(quantname).negative;
                                    alldata.(bbmeta.conditions{2}).(DATAGRP).(quantlabel).half(:,:,t2) = bbstruct.(subjs{s}).(trials{n}).(DATAGRP).(quantname).half;
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
            qpresuf = regexpi(bbmeta.(SRCGRP){q},['(\w*)' SRCMIDSTR '(\w*)'],'tokens');
            quantlabel = [qpresuf{1}{1} DATAMIDSTR qpresuf{1}{2}];                               
            for c=1:2
                if isfield(alldata,bbmeta.conditions{c})
                    
                    % net
                    bbstruct.(subjs{s}).mean.(bbmeta.conditions{c}).(DATAGRP).(quantlabel).net = mean(alldata.(bbmeta.conditions{c}).(DATAGRP).(quantlabel).net,2)';
                    bbstruct.(subjs{s}).sd.(bbmeta.conditions{c}).(DATAGRP).(quantlabel).net = std(alldata.(bbmeta.conditions{c}).(DATAGRP).(quantlabel).net,0,2)';            
                    
                    % positive
                    bbstruct.(subjs{s}).mean.(bbmeta.conditions{c}).(DATAGRP).(quantlabel).positive = mean(alldata.(bbmeta.conditions{c}).(DATAGRP).(quantlabel).positive,2)';
                    bbstruct.(subjs{s}).sd.(bbmeta.conditions{c}).(DATAGRP).(quantlabel).positive = std(alldata.(bbmeta.conditions{c}).(DATAGRP).(quantlabel).positive,0,2)';                                
                    
                    % negative
                    bbstruct.(subjs{s}).mean.(bbmeta.conditions{c}).(DATAGRP).(quantlabel).negative = mean(alldata.(bbmeta.conditions{c}).(DATAGRP).(quantlabel).negative,2)';
                    bbstruct.(subjs{s}).sd.(bbmeta.conditions{c}).(DATAGRP).(quantlabel).negative = std(alldata.(bbmeta.conditions{c}).(DATAGRP).(quantlabel).negative,0,2)';                                
                    
                    % half
                    bbstruct.(subjs{s}).mean.(bbmeta.conditions{c}).(DATAGRP).(quantlabel).half = mean(alldata.(bbmeta.conditions{c}).(DATAGRP).(quantlabel).half,3);
                    bbstruct.(subjs{s}).sd.(bbmeta.conditions{c}).(DATAGRP).(quantlabel).half = std(alldata.(bbmeta.conditions{c}).(DATAGRP).(quantlabel).half,0,3);                                
                    
                    
                end
            end
        end
        
        
        
    end
    
    
    



end


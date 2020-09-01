function bbstruct = calcExportGroundSpeedMeans(bbstruct,bbmeta,user)


%CALCEXPORTGROUNDSPEEDMEANS Calculate mean ground speeds and export to XLS
%   Prasanna Sritharan, August 2020


    % assign struct fields
    subjprefix = user.SUBJECTPREFIX;
    trialprefix = user.TRIALPREFIX;
    xlspath = user.XLSMETAPATH;  
    structpath = user.DATASRCPATH;
    

    
    % ********************
    % SUBJECT MEANS     
    
    % pull speeds from metadata struct
    subjs = fieldnames(bbstruct);
    for s=1:length(subjs)
        
        trials = fieldnames(bbstruct.(subjs{s}));
        
        disp(['Subject: ' subjs{s}]);
        
        % collate trial data
        subjdata = struct;
        for f=1:2
            t1 = 1;
            t2 = 1;
            t3 = 1;
            for n=1:length(trials)                                             
                if isempty(find(strcmpi(trials{n},bbmeta.SUBJECTFIELDS),1))
                    if isfield(bbstruct.(subjs{s}).(trials{n}),'speed')

                        % skip ignored trials
                        if bbstruct.(subjs{s}).(trials{n}).ignore==1
                            disp(['--Ignoring trial: ' trials{n}]); 
                            continue
                        end

                        % process depends on how many legs were analysed
                        switch bbstruct.(subjs{s}).(trials{n}).analysedlegs

                            case 1  % one leg

                                if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbmeta.limbs{f})                                                                                       
                                    if strcmpi(bbstruct.(subjs{s}).affected,'C')
                                        subjdata.(bbmeta.conditions{3}).trial(t3) = bbstruct.(subjs{s}).(trials{n}).speed.trial;
                                        subjdata.(bbmeta.conditions{3}).stance(t3) = bbstruct.(subjs{s}).(trials{n}).speed.stance;
                                        t3 = t3 + 1;                                            
                                    elseif strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbstruct.(subjs{s}).affected)
                                        subjdata.(bbmeta.conditions{1}).trial(t1) = bbstruct.(subjs{s}).(trials{n}).speed.trial;
                                        subjdata.(bbmeta.conditions{1}).stance(t1) = bbstruct.(subjs{s}).(trials{n}).speed.stance;
                                        t1 = t1 + 1;
                                    else
                                        subjdata.(bbmeta.conditions{2}).trial(t2) = bbstruct.(subjs{s}).(trials{n}).speed.trial;
                                        subjdata.(bbmeta.conditions{2}).stance(t2) = bbstruct.(subjs{s}).(trials{n}).speed.stance;
                                        t2 = t2 + 1;
                                    end
                                end

                            case 2  % two legs

                                for p=1:2
                                    if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb{p},bbmeta.limbs{f})                                                                                                
                                        if strcmpi(bbstruct.(subjs{s}).affected,'C')
                                            subjdata.(bbmeta.conditions{3}).trial(t3) = bbstruct.(subjs{s}).(trials{n}).speed{n}.trial;
                                            subjdata.(bbmeta.conditions{3}).stance(t3) = bbstruct.(subjs{s}).(trials{n}).speed{n}.stance;
                                            t3 = t3 + 1;                                                
                                        elseif strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb{p},bbstruct.(subjs{s}).affected)
                                            subjdata.(bbmeta.conditions{1}).trial(t1) = bbstruct.(subjs{s}).(trials{n}).speed{n}.trial;
                                            subjdata.(bbmeta.conditions{1}).stance(t1) = bbstruct.(subjs{s}).(trials{n}).speed{n}.stance;
                                            t1 = t1 + 1;
                                        else
                                            subjdata.(bbmeta.conditions{2}).trial(t2) = bbstruct.(subjs{s}).(trials{n}).speed{n}.trial;
                                            subjdata.(bbmeta.conditions{2}).stance(t2) = bbstruct.(subjs{s}).(trials{n}).speed{n}.stance;
                                            t2 = t2 + 1;
                                        end
                                    end
                                end

                        end
                    end

                end
            end
            
        end
        
        % calculate subject means and stdevs
        for c=1:3
            if isfield(subjdata,bbmeta.conditions{c})
                
                % trial speed
                bbstruct.(subjs{s}).speed.(bbmeta.conditions{c}).trial.mean = mean(subjdata.(bbmeta.conditions{c}).trial);
                bbstruct.(subjs{s}).speed.(bbmeta.conditions{c}).trial.sd = std(subjdata.(bbmeta.conditions{c}).trial);  
                
                % stance speed
                bbstruct.(subjs{s}).speed.(bbmeta.conditions{c}).stance.mean = mean(subjdata.(bbmeta.conditions{c}).stance);
                bbstruct.(subjs{s}).speed.(bbmeta.conditions{c}).stance.sd = std(subjdata.(bbmeta.conditions{c}).stance);                
                
            end
        end
     
    end
    

    
    
    
    % ********************
    % TOTAL MEANS 
    
    % collate subject means
    alldata = struct;
    for c=1:3
        n = 1;
        for s=1:length(subjs)    
            if strcmp(subjs{s},'MEAN'), continue; end
            if isfield(bbstruct.(subjs{s}),'speed')
                if isfield(bbstruct.(subjs{s}).speed,bbmeta.conditions{c})
                    
                    % trial speed
                    alldata.means.(bbmeta.conditions{c}).trial(n) = bbstruct.(subjs{s}).speed.(bbmeta.conditions{c}).trial.mean;
                    alldata.sds.(bbmeta.conditions{c}).trial(n) = bbstruct.(subjs{s}).speed.(bbmeta.conditions{c}).trial.sd;

                    % stance speed
                    alldata.means.(bbmeta.conditions{c}).stance(n) = bbstruct.(subjs{s}).speed.(bbmeta.conditions{c}).stance.mean;
                    alldata.sds.(bbmeta.conditions{c}).stance(n) = bbstruct.(subjs{s}).speed.(bbmeta.conditions{c}).stance.sd;   
                
                    n = n + 1;
                    
                end
            end
        end
    end
        
        
    % calculate group means
    % mean: mean of individual subject means
    % sd: sd of subject means
    for c=1:3
       if isfield(alldata.means,bbmeta.conditions{c}) 
           
           % trial speed
           bbstruct.MEAN.speed.(bbmeta.conditions{c}).trial.mean = mean(alldata.means.(bbmeta.conditions{c}).trial);
           bbstruct.MEAN.speed.(bbmeta.conditions{c}).trial.sd = std(alldata.means.(bbmeta.conditions{c}).trial);
           
           % stance speed
           bbstruct.MEAN.speed.(bbmeta.conditions{c}).stance.mean = mean(alldata.means.(bbmeta.conditions{c}).stance);
           bbstruct.MEAN.speed.(bbmeta.conditions{c}).stance.sd = std(alldata.means.(bbmeta.conditions{c}).stance);           
           
       end        
    end

    
    % save struct
    save(fullfile(structpath,'bb.mat'),'-struct','bbstruct');    
    
    
    
    
    % ********************
    % EXPORT TO XLS   
    
    % table header row
    xldata = {'subject','condition','trial_mean','trial_sd','stance_mean','stance_sd'};
    
    % build table
    x = 2;
    for c=1:3
        for s=1:length(subjs)
            if isfield(bbstruct.(subjs{s}),'speed')
                if isfield(bbstruct.(subjs{s}).speed,bbmeta.conditions{c})
                    xldata(x,:) = {subjs{s}, ...
                                    bbmeta.conditions{c}, ...
                                    bbstruct.(subjs{s}).speed.(bbmeta.conditions{c}).trial.mean, ...
                                    bbstruct.(subjs{s}).speed.(bbmeta.conditions{c}).trial.sd, ...
                                    bbstruct.(subjs{s}).speed.(bbmeta.conditions{c}).stance.mean, ...
                                    bbstruct.(subjs{s}).speed.(bbmeta.conditions{c}).stance.sd};
                    x = x + 1;                                    
                end
            end
        end
    end
    
    % write to Excel spreadsheet
    xlsname = [upper(subjprefix) '_' upper(trialprefix) '_speeds.xlsx']; 
    writecell(xldata,fullfile(xlspath,xlsname),'FileType','spreadsheet');

end


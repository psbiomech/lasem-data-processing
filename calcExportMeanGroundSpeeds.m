function bbstruct = calcExportMeanGroundSpeeds(bbstruct,bbmeta,user)


%CALCEXPORTMEANGROUNDSPEEDS Calculate mean ground speeds and export to XLS
%   Prasanna Sritharan, August 2020


    % assign struct fields
    summarypath = user.XLSMETAPATH;  
    
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
    
    
    
    
    % collate subject means
    alldata = struct;
    for c=1:3
        n = 1;
        for s=1:length(subjs)    
            if strcmp(subjs{s},'MEAN'), continue; end
        end
    end
        
        
        
    end
    


end


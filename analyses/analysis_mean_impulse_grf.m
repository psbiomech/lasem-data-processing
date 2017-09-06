function bbstruct = analysis_mean_impulse_grf(bbstruct,bbmeta)


%  analysis_mean_impulse_grf: Subject and total means for ground impulse
%   Prasanna Sritharan, August 2017
% 
% -------------------------------------------------------------------- 
%     Copyright (C) 2017 Prasanna Sritharan
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
% -------------------------------------------------------------------- 

     
    % input data group name
    DATAGRP = upper(bbmeta.BBANALYSES{3});
    SRCGRP = bbmeta.BBGROUPS{4};
    
    % midstring
    DATAMIDSTR = bbmeta.BBANALYSES{3};    
    SRCMIDSTR = SRCGRP(1:end-1);
    
    
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
                                    cond1 = bbmeta.conditions{1};
                                    alldata.(cond1).(DATAGRP).(quantlabel).net(:,t1) = bbstruct.(subjs{s}).(trials{n}).(DATAGRP).(quantname).net;
                                    alldata.(cond1).(DATAGRP).(quantlabel).positive(:,t1) = bbstruct.(subjs{s}).(trials{n}).(DATAGRP).(quantname).positive;
                                    alldata.(cond1).(DATAGRP).(quantlabel).negative(:,t1) = bbstruct.(subjs{s}).(trials{n}).(DATAGRP).(quantname).negative;
                                    alldata.(cond1).(DATAGRP).(quantlabel).half(:,:,t1) = bbstruct.(subjs{s}).(trials{n}).(DATAGRP).(quantname).half;
                                    t1 = t1 + 1;
                                else
                                    cond2 = bbmeta.conditions{2};
                                    alldata.(cond2).(DATAGRP).(quantlabel).net(:,t2) = bbstruct.(subjs{s}).(trials{n}).(DATAGRP).(quantname).net;
                                    alldata.(cond2).(DATAGRP).(quantlabel).positive(:,t2) = bbstruct.(subjs{s}).(trials{n}).(DATAGRP).(quantname).positive;
                                    alldata.(cond2).(DATAGRP).(quantlabel).negative(:,t2) = bbstruct.(subjs{s}).(trials{n}).(DATAGRP).(quantname).negative;
                                    alldata.(cond2).(DATAGRP).(quantlabel).half(:,:,t2) = bbstruct.(subjs{s}).(trials{n}).(DATAGRP).(quantname).half;
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
                cond = bbmeta.conditions{c};
                if isfield(alldata,bbmeta.conditions{c})
                    
                    % net
                    bbstruct.(subjs{s}).mean.(cond).(DATAGRP).(quantlabel).net = mean(alldata.(cond).(DATAGRP).(quantlabel).net,2)';
                    bbstruct.(subjs{s}).sd.(cond).(DATAGRP).(quantlabel).net = std(alldata.(cond).(DATAGRP).(quantlabel).net,0,2)';            
                    
                    % positive
                    bbstruct.(subjs{s}).mean.(cond).(DATAGRP).(quantlabel).positive = mean(alldata.(cond).(DATAGRP).(quantlabel).positive,2)';
                    bbstruct.(subjs{s}).sd.(cond).(DATAGRP).(quantlabel).positive = std(alldata.(cond).(DATAGRP).(quantlabel).positive,0,2)';                                
                    
                    % negative
                    bbstruct.(subjs{s}).mean.(cond).(DATAGRP).(quantlabel).negative = mean(alldata.(cond).(DATAGRP).(quantlabel).negative,2)';
                    bbstruct.(subjs{s}).sd.(cond).(DATAGRP).(quantlabel).negative = std(alldata.(cond).(DATAGRP).(quantlabel).negative,0,2)';                                
                    
                    % half
                    bbstruct.(subjs{s}).mean.(cond).(DATAGRP).(quantlabel).half = mean(alldata.(cond).(DATAGRP).(quantlabel).half,3);
                    bbstruct.(subjs{s}).sd.(cond).(DATAGRP).(quantlabel).half = std(alldata.(cond).(DATAGRP).(quantlabel).half,0,3);                                
                    
                    
                end
            end
        end    
        
        % segments
        % Note: due to the varying shapes of the individual trial data curves,
        % this can only be calculated using the mean source data curve, we
        % cannot calculate a stdev for this     
        for q=1:length(bbmeta.(SRCGRP))     
            quantlabel = bbmeta.(SRCGRP){q};  
            qpresuf = regexpi(bbmeta.(SRCGRP){q},['(\w*)' SRCMIDSTR '(\w*)'],'tokens');
            qoutname = [qpresuf{1}{1} DATAMIDSTR qpresuf{1}{2}];
            for c=1:2
                cond = bbmeta.conditions{c};  
                if isfield(bbstruct.(subjs{s}).mean,cond)
                    for x=1:3

                        % time vector
                        time = bbstruct.(subjs{s}).mean.(cond).TIMES.relative';

                        % net integral (source data)
                        data = bbstruct.(subjs{s}).mean.(cond).(SRCGRP).(quantlabel)(:,x);

                        % define segments
                        posbnds = [find(diff([0 (data>0)'])==1);find(diff([(data>0)' 0])==-1)];            
                        negbnds = [find(diff([0 (data<0)'])==1);find(diff([(data<0)' 0])==-1)];
                        possign = ones(1,size(posbnds,2));
                        negsign = -ones(1,size(negbnds,2));
                        bounds = zeros(2,size(posbnds,2)+size(negbnds,2));
                        ssign = zeros(1,size(posbnds,2)+size(negbnds,2));
                        p = 1;
                        n = 1;
                        for b=1:2:size(bounds,2)
                            if (p>size(posbnds,2))
                                bounds(:,b:end) = negbnds(:,n:end);
                                ssign(:,b:end) = negsign(n:end);
                                break;
                            elseif (n>size(negbnds,2))
                                bounds(:,b:end) = posbnds(:,p:end);
                                ssign(:,b:end) = possign(p:end);
                                break;
                            else
                                bounds(:,b:b+1) = [posbnds(:,p), negbnds(:,n)];
                                ssign(b:b+1) = [possign(p), negsign(n)];
                            end
                            p = p + 1;
                            n = n + 1;
                        end       

                        % segment integral
                        segint = zeros(1,size(bounds,2));
                        for ss=1:size(segint,2)
                            trange = [bounds(1,ss):bounds(2,ss)];
                            if (length(trange)==1)
                                segint(ss) = 0;
                            else
                                segint(ss) = trapz(time(trange),data(trange));
                            end
                        end
                        bbstruct.(subjs{s}).mean.(cond).(DATAGRP).(qoutname).segments.(bbmeta.dirs{x}) = segint;
                        bbstruct.(subjs{s}).sd.(cond).(DATAGRP).(qoutname).segments.(bbmeta.dirs{x}) = [];

                    end
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
                qpresuf = regexpi(bbmeta.(SRCGRP){q},['(\w*)' SRCMIDSTR '(\w*)'],'tokens');
                quantlabel = [qpresuf{1}{1} DATAMIDSTR qpresuf{1}{2}]; 
                for f=1:2
                    cond = bbmeta.conditions{f};
                    if isfield(bbstruct.(subjs{s}).mean,cond)
                        try

                            % net
                            alldata.means.(cond).(DATAGRP).(quantlabel).net(:,s) = bbstruct.(subjs{s}).mean.(cond).(DATAGRP).(quantlabel).net;
                            alldata.sds.(cond).(DATAGRP).(quantlabel).net(:,s) = bbstruct.(subjs{s}).sd.(cond).(DATAGRP).(quantlabel).net;

                            % positive
                            alldata.means.(cond).(DATAGRP).(quantlabel).positive(:,s) = bbstruct.(subjs{s}).mean.(cond).(DATAGRP).(quantlabel).positive;
                            alldata.sds.(cond).(DATAGRP).(quantlabel).positive(:,s) = bbstruct.(subjs{s}).sd.(cond).(DATAGRP).(quantlabel).positive;

                            % negative
                            alldata.means.(cond).(DATAGRP).(quantlabel).negative(:,s) = bbstruct.(subjs{s}).mean.(cond).(DATAGRP).(quantlabel).negative;
                            alldata.sds.(cond).(DATAGRP).(quantlabel).negative(:,s) = bbstruct.(subjs{s}).sd.(cond).(DATAGRP).(quantlabel).negative;                        

                            % half
                            alldata.means.(cond).(DATAGRP).(quantlabel).half(:,:,s) = bbstruct.(subjs{s}).mean.(cond).(DATAGRP).(quantlabel).half;
                            alldata.sds.(cond).(DATAGRP).(quantlabel).half(:,:,s) = bbstruct.(subjs{s}).sd.(cond).(DATAGRP).(quantlabel).half;                                  

                        catch excp
                            rethrow(excp);
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
        qpresuf = regexpi(bbmeta.(SRCGRP){q},['(\w*)' SRCMIDSTR '(\w*)'],'tokens');
        quantlabel = [qpresuf{1}{1} DATAMIDSTR qpresuf{1}{2}];   
        for c=1:2
            cond = bbmeta.conditions{c};
            if isfield(alldata.means,cond)
                
                % net
                bbstruct.MEAN.mean.(cond).(DATAGRP).(quantlabel).net = mean(alldata.means.(cond).(DATAGRP).(quantlabel).net,2)';
                bbstruct.MEAN.sd.(cond).(DATAGRP).(quantlabel).net = sqrt(sum((alldata.sds.(cond).(DATAGRP).(quantlabel).net).^2,2))';
                
                % positive
                bbstruct.MEAN.mean.(cond).(DATAGRP).(quantlabel).positive = mean(alldata.means.(cond).(DATAGRP).(quantlabel).positive,2)';
                bbstruct.MEAN.sd.(cond).(DATAGRP).(quantlabel).positive = sqrt(sum((alldata.sds.(cond).(DATAGRP).(quantlabel).positive).^2,2))';
                
                % negative
                bbstruct.MEAN.mean.(cond).(DATAGRP).(quantlabel).negative = mean(alldata.means.(cond).(DATAGRP).(quantlabel).negative,2)';
                bbstruct.MEAN.sd.(cond).(DATAGRP).(quantlabel).negative = sqrt(sum((alldata.sds.(cond).(DATAGRP).(quantlabel).negative).^2,2))';                
                
                % half
                bbstruct.MEAN.mean.(cond).(DATAGRP).(quantlabel).half = mean(alldata.means.(cond).(DATAGRP).(quantlabel).half,3);
                bbstruct.MEAN.sd.(cond).(DATAGRP).(quantlabel).half = sqrt(sum((alldata.sds.(cond).(DATAGRP).(quantlabel).half).^2,3));                   
                                
            end
        end
    end

    
    % segments
    % Note: due to the varying shapes of the individual trial data curves,
    % this can only be calculated using the mean source data curve, we
    % cannot calculate a stdev for this     
    for q=1:length(bbmeta.(SRCGRP))     
        quantlabel = bbmeta.(SRCGRP){q};  
        qpresuf = regexpi(bbmeta.(SRCGRP){q},['(\w*)' SRCMIDSTR '(\w*)'],'tokens');
        qoutname = [qpresuf{1}{1} DATAMIDSTR qpresuf{1}{2}];
        for c=1:2
            cond = bbmeta.conditions{c};  
            if isfield(bbstruct.MEAN.mean,cond)
                for x=1:3

                    % time vector
                    time = bbstruct.MEAN.mean.(cond).TIMES.relative';

                    % net integral (source data)
                    data = bbstruct.MEAN.mean.(cond).(SRCGRP).(quantlabel)(:,x);

                    % define segments
                    posbnds = [find(diff([0 (data>0)'])==1);find(diff([(data>0)' 0])==-1)];            
                    negbnds = [find(diff([0 (data<0)'])==1);find(diff([(data<0)' 0])==-1)];
                    possign = ones(1,size(posbnds,2));
                    negsign = -ones(1,size(negbnds,2));
                    bounds = zeros(2,size(posbnds,2)+size(negbnds,2));
                    ssign = zeros(1,size(posbnds,2)+size(negbnds,2));
                    p = 1;
                    n = 1;
                    for b=1:2:size(bounds,2)
                        if (p>size(posbnds,2))
                            bounds(:,b:end) = negbnds(:,n:end);
                            ssign(:,b:end) = negsign(n:end);
                            break;
                        elseif (n>size(negbnds,2))
                            bounds(:,b:end) = posbnds(:,p:end);
                            ssign(:,b:end) = possign(p:end);
                            break;
                        else
                            bounds(:,b:b+1) = [posbnds(:,p), negbnds(:,n)];
                            ssign(b:b+1) = [possign(p), negsign(n)];
                        end
                        p = p + 1;
                        n = n + 1;
                    end       

                    % segment integral
                    segint = zeros(1,size(bounds,2));
                    for ss=1:size(segint,2)
                        trange = [bounds(1,ss):bounds(2,ss)];
                        if (length(trange)==1)
                            segint(ss) = 0;
                        else
                            segint(ss) = trapz(time(trange),data(trange));
                        end
                    end
                    bbstruct.MEAN.mean.(cond).(DATAGRP).(qoutname).segments.(bbmeta.dirs{x}) = segint;
                    bbstruct.MEAN.sd.(cond).(DATAGRP).(qoutname).segments.(bbmeta.dirs{x}) = [];

                end
                bbstruct.MEAN.mean.(cond).(DATAGRP).(qoutname) = orderfields(bbstruct.MEAN.mean.(cond).(DATAGRP).(qoutname),[2:5 1]);
                bbstruct.MEAN.sd.(cond).(DATAGRP).(qoutname) = orderfields(bbstruct.MEAN.sd.(cond).(DATAGRP).(qoutname),[2:5 1]);
            end            
        end                        
    end     
    
    
    

end


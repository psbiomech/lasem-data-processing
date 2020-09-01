function bbstruct = meanBBsubject(bbstruct,bbmeta,ampg,samp)

%meanBBsubject: Calculates mean of all trials per subject
%   Prasanna Sritharan, April 2018
% 
% -------------------------------------------------------------------- 
%     Copyright (C) 2018 Prasanna Sritharan
%     Copyright (C) 2018 La Trobe University
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


    % get desired output data groups
    outgrps = bbmeta.BBGROUPS(logical(ampg));        

    % delete group MEAN field if it already exists
    if isfield(bbstruct,'MEAN'), bbstruct = rmfield(bbstruct,'MEAN'); end    
    
    % collate point data
    subjs = fieldnames(bbstruct);    
    for s=1:length(subjs)            
        
        % delete subject mean and sd fields if they already exist
        if isfield(bbstruct.(subjs{s}),'mean')
            bbstruct.(subjs{s}) = rmfield(bbstruct.(subjs{s}),'mean'); 
            bbstruct.(subjs{s}) = rmfield(bbstruct.(subjs{s}),'sd'); 
        end         
        
        % get list of trials
        trials = fieldnames(bbstruct.(subjs{s}));
        ntrials = length(trials);
        
        % get point data
        alldata = struct;
        for b=1:length(outgrps)
            if (bbstruct.(subjs{s}).kinematicsonly)&&(~strcmpi(outgrps{b},'ANGLES')), continue; end
            for q=1:length(bbmeta.(outgrps{b}))                                                
                for f=1:2
                    quantlabel = bbmeta.(outgrps{b}){q};
                    quantname = [bbmeta.limbs{f} quantlabel];
                    t1 = 1;
                    t2 = 1;
                    t3 = 1;
                    for n = 1:ntrials
                        try                                       
                            
                            if isempty(find(strcmpi(trials{n},bbmeta.SUBJECTFIELDS),1))                                 
                                
                                % skip ignored trials
                                if bbstruct.(subjs{s}).(trials{n}).ignore==1
                                    disp(['--Ignoring variable: ' outgrps{b} ' ' quantname ' for foot ' bbmeta.limbs{f} ' and trial ' subjs{s} '_' trials{n}]); 
                                    continue
                                end                                
                                
                                % process depends on how many legs were analysed
                                switch bbstruct.(subjs{s}).(trials{n}).analysedlegs
                                    
                                    case 1  % one leg
                                
                                        if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbmeta.limbs{f})                                                                                       
                                            if strcmpi(bbstruct.(subjs{s}).affected,'C')
                                                alldata.(bbmeta.conditions{3}).(outgrps{b}).(quantlabel)(:,:,t3) = bbstruct.(subjs{s}).(trials{n}).data.(outgrps{b}).(quantname);
                                                t3 = t3 + 1;                                            
                                            elseif strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbstruct.(subjs{s}).affected)
                                                alldata.(bbmeta.conditions{1}).(outgrps{b}).(quantlabel)(:,:,t1) = bbstruct.(subjs{s}).(trials{n}).data.(outgrps{b}).(quantname);
                                                t1 = t1 + 1;
                                            else
                                                alldata.(bbmeta.conditions{2}).(outgrps{b}).(quantlabel)(:,:,t2) = bbstruct.(subjs{s}).(trials{n}).data.(outgrps{b}).(quantname);
                                                t2 = t2 + 1;
                                            end
                                        end
                                
                                    case 2  % two legs

                                        for p=1:2
                                            if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb{p},bbmeta.limbs{f})                                                                                                
                                                if strcmpi(bbstruct.(subjs{s}).affected,'C')
                                                    alldata.(bbmeta.conditions{3}).(outgrps{b}).(quantlabel)(:,:,t3) = bbstruct.(subjs{s}).(trials{n}).data{p}.(outgrps{b}).(quantname);
                                                    t3 = t3 + 1;                                                
                                                elseif strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb{p},bbstruct.(subjs{s}).affected)
                                                    alldata.(bbmeta.conditions{1}).(outgrps{b}).(quantlabel)(:,:,t1) = bbstruct.(subjs{s}).(trials{n}).data{p}.(outgrps{b}).(quantname);
                                                    t1 = t1 + 1;
                                                else
                                                    alldata.(bbmeta.conditions{2}).(outgrps{b}).(quantlabel)(:,:,t2) = bbstruct.(subjs{s}).(trials{n}).data{p}.(outgrps{b}).(quantname);
                                                    t2 = t2 + 1;
                                                end
                                            end
                                        end
                                        
                                end
                                
                                
                            else
                                continue;
                            end
                        catch                            
                            disp(['--Error processing: ' outgrps{b} ' ' quantname ' for foot ' bbmeta.limbs{f} ' and trial ' subjs{s} ' ' trials{n}]); 
                        end                           
                    end
                end                                        
            end
        end

        % subject means and sd for point data
        for b=1:length(outgrps)
            if (bbstruct.(subjs{s}).kinematicsonly)&&(~strcmpi(outgrps{b},'ANGLES')), continue; end
            for q=1:length(bbmeta.(outgrps{b}))
                quantlabel = bbmeta.(outgrps{b}){q};
                for c=1:3
                    if isfield(alldata,bbmeta.conditions{c})
                        bbstruct.(subjs{s}).mean.(bbmeta.conditions{c}).(outgrps{b}).(quantlabel) = mean(alldata.(bbmeta.conditions{c}).(outgrps{b}).(quantlabel),3);
                        bbstruct.(subjs{s}).sd.(bbmeta.conditions{c}).(outgrps{b}).(quantlabel) = std(alldata.(bbmeta.conditions{c}).(outgrps{b}).(quantlabel),0,3);            
                    end
                end
            end
        end            
        
        
        
        % collate relative time
        for f=1:2
            t1 = 1;
            t2 = 1;
            t3 = 1;
            for n = 1:ntrials
                try
                    if isempty(find(strcmpi(trials{n},bbmeta.SUBJECTFIELDS),1))

                            % skip ignored trials
                            if bbstruct.(subjs{s}).(trials{n}).ignore==1
                                disp(['--Ignoring variable: TIMES for foot ' bbmeta.limbs{f} ' and trial ' subjs{s} '_' trials{n}]); 
                                continue
                            end                         
                        
                        
                            % process depends on how many legs were analysed
                            switch bbstruct.(subjs{s}).(trials{n}).analysedlegs

                                case 1  % one leg
                                    
                                    if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbmeta.limbs{f})                                    
                                        
                                        if strcmpi(bbstruct.(subjs{s}).affected,'C')
                                            alldata.(bbmeta.conditions{3}).TIMES.elapsed(t3) = bbstruct.(subjs{s}).(trials{n}).data.TIMES.relative(end);
                                            t3 = t3 + 1;                                        
                                        elseif strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb,bbstruct.(subjs{s}).affected)
                                            alldata.(bbmeta.conditions{1}).TIMES.elapsed(t1) = bbstruct.(subjs{s}).(trials{n}).data.TIMES.relative(end);
                                            t1 = t1 + 1;
                                        else
                                            alldata.(bbmeta.conditions{2}).TIMES.elapsed(t2) = bbstruct.(subjs{s}).(trials{n}).data.TIMES.relative(end);
                                            t2 = t2 + 1;
                                        end
                                    end
                                
                                case 2  % two legs

                                    for p=1:2
                                        if strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb{p},bbmeta.limbs{f}) 
                                            if strcmpi(bbstruct.(subjs{s}).affected,'C')
                                                alldata.(bbmeta.conditions{1}).TIMES.elapsed(t3) = bbstruct.(subjs{s}).(trials{n}).data{p}.TIMES.relative(end);
                                                t3 = t3 + 1;                                            
                                            elseif strcmpi(bbstruct.(subjs{s}).(trials{n}).triallimb{p},bbstruct.(subjs{s}).affected)
                                                alldata.(bbmeta.conditions{1}).TIMES.elapsed(t1) = bbstruct.(subjs{s}).(trials{n}).data{p}.TIMES.relative(end);
                                                t1 = t1 + 1;
                                            else
                                                alldata.(bbmeta.conditions{2}).TIMES.elapsed(t2) = bbstruct.(subjs{s}).(trials{n}).data{p}.TIMES.relative(end);
                                                t2 = t2 + 1;
                                            end
                                        end
                                    end
                                    
                            end
                                                                                        
                    else
                        continue;
                    end
                catch                            
                    disp(['--Error processing: TIMES for foot ' bbmeta.limbs{f} ' and trial ' subjs{s} ' ' trials{n}]); 
                end                           
            end
        end
        
        % subject means and sd for time
        for c=1:3
            if isfield(alldata,bbmeta.conditions{c})
                
                % total elapsed time
                bbstruct.(subjs{s}).mean.(bbmeta.conditions{c}).TIMES.elapsed = mean(alldata.(bbmeta.conditions{c}).TIMES.elapsed);
                bbstruct.(subjs{s}).sd.(bbmeta.conditions{c}).TIMES.elapsed = std(alldata.(bbmeta.conditions{c}).TIMES.elapsed);
                
                % construct relative time vector (applies to mean only)
                bbstruct.(subjs{s}).mean.(bbmeta.conditions{c}).TIMES.relative = linspace(0,bbstruct.(subjs{s}).mean.(bbmeta.conditions{c}).TIMES.elapsed,samp);
                bbstruct.(subjs{s}).sd.(bbmeta.conditions{c}).TIMES.relative = [];
                
            end
        end
 
    end
  
end


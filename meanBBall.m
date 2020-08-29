function bbstruct = meanBBall(bbstruct,bbmeta,ampg)

%meanBBall: Calculates mean of all trials for all subjects
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
    if isfield(bbstruct,'MEAN'), rmfield(bbstruct,'MEAN'); end      
    
    % collate individual means and sds
    subjs = fieldnames(bbstruct);
    alldata = struct;
    for s=1:length(subjs)    
        for b=1:length(outgrps)
            for q=1:length(bbmeta.(outgrps{b}))
                quantlabel = bbmeta.(outgrps{b}){q};
                for f=1:3
                    cond = bbmeta.conditions{f};
                    if isfield(bbstruct.(subjs{s}),'mean')
                        if isfield(bbstruct.(subjs{s}).mean,cond)
                            try
                                alldata.means.(cond).(outgrps{b}).(quantlabel)(:,:,s) = bbstruct.(subjs{s}).mean.(cond).(outgrps{b}).(quantlabel);
                                alldata.sds.(cond).(outgrps{b}).(quantlabel)(:,:,s) = bbstruct.(subjs{s}).sd.(cond).(outgrps{b}).(quantlabel);
                            catch                            
                                disp(['--Error processing: ' outgrps{b} ' ' quantname ' for foot ' bbmeta.limbs{f} ' and subject ' subjs{s}]); 
                            end
                        end
                    end
                end
            end
        end
    end

    
    % calculate mean and sd for all data
    % mean: mean of individual subject means
    % sd: sqrt of sum of squares of individual subject sds
    for b=1:length(outgrps)
        for q=1:length(bbmeta.(outgrps{b}))
            quantlabel = bbmeta.(outgrps{b}){q};
            for c=1:3
                cond = bbmeta.conditions{c};
                if isfield(alldata.means,cond)
                    bbstruct.MEAN.mean.(cond).(outgrps{b}).(quantlabel) = mean(alldata.means.(cond).(outgrps{b}).(quantlabel),3);
                    bbstruct.MEAN.sd.(cond).(outgrps{b}).(quantlabel) = sqrt(sum((alldata.sds.(cond).(outgrps{b}).(quantlabel)).^2,3));
                end
            end
        end
    end            
        

    
    % relative time: collate means and sds
    for s=1:length(subjs)    
        if strcmp(subjs{s},'MEAN'), continue; end           
        for f=1:3
            cond = bbmeta.conditions{f};
            if isfield(bbstruct.(subjs{s}),'mean')
                if isfield(bbstruct.(subjs{s}).mean,cond)
                    try
                        alldata.means.(cond).TIMES.elapsed(s) = bbstruct.(subjs{s}).mean.(cond).TIMES.elapsed;
                        alldata.sds.(cond).TIMES.elapsed(s) = bbstruct.(subjs{s}).sd.(cond).TIMES.elapsed;
                    catch                            
                        disp(['--Error processing: TIMES for foot ' bbmeta.limbs{f} ' and subject ' subjs{s}]); 
                    end
                end
            end
        end
    end    
    
    % calculate mean and sd for time
    % mean: mean of individual subject means
    % sd: sqrt of sum of squares of individual subject sds
    for c=1:3
        cond = bbmeta.conditions{c};
        if isfield(alldata.means,cond)
            
            % total elapsed time
            bbstruct.MEAN.mean.(cond).TIMES.elapsed = mean(alldata.means.(cond).TIMES.elapsed);
            bbstruct.MEAN.sd.(cond).TIMES.elapsed = sqrt(sum((alldata.sds.(cond).TIMES.elapsed).^2,3));
            
            % construct relative time vector (applies to mean only)
            bbstruct.MEAN.mean.(cond).TIMES.relative = linspace(0,bbstruct.MEAN.mean.(cond).TIMES.elapsed);
            bbstruct.MEAN.sd.(cond).TIMES.relative = [];
            
        end
    end
    
end


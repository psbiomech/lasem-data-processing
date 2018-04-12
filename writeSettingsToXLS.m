function writeSettingsToXLS(bbstruct,xlsname,xlspath)

%  writeSettingsToXLS: Create input spreadsheet from BB struct
%   Prasanna Sritharan, June 2017
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


    warning('off');

    
    % sheet header
    xldata(1,:) = {'Subject','Trial','Cohort','Affected','Trial Limb','First VFrame','Last VFrame','FP Sequence','File Path'};
        
    % collate data
    x = 2;
    subjs = fieldnames(bbstruct);    
    for s=1:length(subjs)
        trials = fieldnames(bbstruct.(subjs{s}));
        for t=1:length(trials)
            if isempty(find(strcmpi(trials{t},{'cohort','affected'}),1))
            
                % different actions required depending on whether one or two legs were analysed per trial
                switch bbstruct.(subjs{s}).(trials{t}).analysedlegs                    
                    
                    case 1  % one leg
                        xldata(x,:) = {subjs{s}, trials{t}, upper(bbstruct.(subjs{s}).cohort), upper(bbstruct.(subjs{s}).affected), upper(bbstruct.(subjs{s}).(trials{t}).triallimb), num2str(bbstruct.(subjs{s}).(trials{t}).vfrange(1)), num2str(bbstruct.(subjs{s}).(trials{t}).vfrange(2)),mat2str(bbstruct.(subjs{s}).(trials{t}).fpseq), bbstruct.(subjs{s}).(trials{t}).filepath};
                        x = x + 1;
                    
                    case 2  % two legs
                        for p=1:2, xldata(x+p-1,:) = {subjs{s}, trials{t}, upper(bbstruct.(subjs{s}).cohort), upper(bbstruct.(subjs{s}).affected), upper(bbstruct.(subjs{s}).(trials{t}).triallimb{p}), num2str(bbstruct.(subjs{s}).(trials{t}).vfrange{p}(1)), num2str(bbstruct.(subjs{s}).(trials{t}).vfrange{p}(2)),mat2str(bbstruct.(subjs{s}).(trials{t}).fpseq{p}), bbstruct.(subjs{s}).(trials{t}).filepath}; end;
                        x = x + 2;
                
                end    
                
            end
        end
    end
                                                                                

    % add XLSX extension if necessary
    if isempty(regexpi(xlsname,'.xlsx')), xlsname = [xlsname '.xlsx']; end;    
    
    % write Excel spreadsheet
    xlswrite([xlspath '\' xlsname],xldata);

end


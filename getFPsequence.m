function fpseq = getFPsequence(itf,bbmeta,task,triallimb)


%getFPsequence: Determine force plate stepping sequence from C3D data
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

    % get number of video channels used
    idx = itf.GetParameterIndex('POINT','USED');
    nused = itf.GetParameterValue(idx,0);               

    % list all point parameters
    vlist = cell(1,nused);
    idx = itf.GetParameterIndex('POINT','LABELS');
    for n=1:nused
        vlist{n} = itf.GetParameterValue(idx,n-1);
    end    

    % get force plate numbers
    fpnums = regexp(vlist,[bbmeta.fpvectors{1} '(\d+)'],'tokens');
    fpnums = fpnums(~cellfun('isempty',fpnums)); 
    nfps = size(fpnums,2);
    fps = zeros(1,nfps);
    for f=1:nfps, fps(f) = str2double(fpnums{f}{1}{1}); end;
    
    % determine sequence based on task
    switch task

        % manually enter sequence
        case 'manual'
            fpseq = input('Enter force plate sequence: ');
            fpsize = size(fpseq);
            if (~ismatrix(fpseq))||(fpsize(2)~=2)
                fpseq = [0 0];
            end

        % walk stance: 
        % determine force plates active before and after FS event
        case 'walk-stance'
            disp('TBA');
            
        % run stance: 
        % assume only 1 force plate active, assign to trial foot
        case 'run-stance'
            fpidx = strcmpi(bbmeta.limbs,triallimb);
            fpseq = zeros(1,2);
            fpseq(fpidx) = fps;            
            
        % single-leg drop and jump: 
        % assume only 1 force plate active, assign to trial foot
        case 'sldj'
            fpidx = strcmpi(bbmeta.limbs,triallimb);
            fpseq = zeros(1,2);
            fpseq(fpidx) = fps;            
            
        otherwise
            error(['Unknown task code "' task '". Exiting.']);
            
    end
    
    
end


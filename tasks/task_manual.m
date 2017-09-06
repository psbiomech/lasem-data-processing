function tstruct = task_manual(itf,tinfo,bbmeta)

%  task_manual: Manually enter all trial data
%   Prasanna Sritharan, July 2017
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

    
    % assign input struct variables
    subj = tinfo.subj;
    trial = tinfo.trial;
    eused = tinfo.eused;
    etime = tinfo.etime;
    econtext = tinfo.econtext;
    elabel = tinfo.elabel;

    
    % display trial info
    disp(' ');
    disp([subj ' ' trial]);
    fprintf(1,'SeqNo\tTime\t\tContext\t\tLabel\n');
    for n=1:eused
        fprintf(1,'%i\t\t%5.2f\t\t%s\t\t%s\n',n,etime(n),econtext{n},elabel{n});
    end
    disp(' ');          

   
    % manually enter trial limb
    tcode = input(['Enter trial limb: ' subj ' ' trial ' (r/l) [r]: '],'s');
    tind = find(strcmpi(tcode,bbmeta.limbs),1);                        
    if isempty(tind)
        triallimb = upper(bbmeta.limbs{1});
    else
        triallimb = upper(bbmeta.limbs{tind});
    end        
    
    
       
    % manually enter first and last event sequence numbers
    seq1 = input('Enter sequence no. of first event: ');
    seq2 = input('Enter sequence no. of last event: ');
    if (~isenum(seq1))||(~isenum(seq2))||(seq1<=seq2)
        seq1 = 1;
        seq2 = eused(end);
    end
    
    % time range is time between first and last events
    trange = [etime(seq1) etime(seq2)];
        
        
    % manually enter force plate sequence matrix
    fpseq = input('Enter force plate sequence betw first and last event: ');
    fpsize = size(fpseq);
    if (~ismatrix(fpseq))||(fpsize(2)~=2)
        fpseq = [0 0];
    end    
    
    
    % assign output struct variables
    tstruct.triallimb = triallimb;
    tstruct.trange = trange;
    tstruct.fpseq = fpseq;


end


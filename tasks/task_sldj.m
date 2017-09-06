function tstruct = task_sldj(itf,tinfo,bbmeta)

%  task_sldj: Auto generate trial info: single-leg drop and jump
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
    eused = tinfo.eused;
    etime = tinfo.etime;
    econtext = tinfo.econtext;
    elabel = tinfo.elabel;
    eframe = tinfo.eframe;
    ecode = tinfo.ecode;
    fps = tinfo.fps;
    LAB = tinfo.LAB;
       
    % find consective FS and FO on same leg
    for n=1:eused-1
       if strcmpi(econtext{n},econtext{n+1})&&(strcmpi(elabel{n},LAB.FS))&&(strcmpi(elabel{n+1},LAB.FO))
            trange = [etime(n) etime(n+1)];
            triallimb = upper(econtext{n}(1));
            elabel = elabel(n:n+1);
            econtext = econtext(n:n+1);
            eframe = eframe(n:n+1);
            ecode = ecode(n:n+1);           
            break;
       end
    end 

    % compute force plate sequence
    fpidx = strcmpi(bbmeta.limbs,triallimb);
    fpseq = zeros(1,2);
    fpseq(fpidx) = fps;      
    
    % assign output struct variables
    tstruct.triallimb = triallimb;
    tstruct.trange = trange;
    tstruct.fpseq = fpseq;
    tstruct.elabels = elabel;
    tstruct.econtexts = econtext;
    tstruct.ecodes = ecode;
    tstruct.eframes = eframe;

end


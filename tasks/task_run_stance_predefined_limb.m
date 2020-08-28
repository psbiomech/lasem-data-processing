function tstruct = task_run_stance_predefined_limb(itf,tinfo,bbmeta)

%task_run_stance_predefined_limb: Auto generate trial info: run - stance
%   Prasanna Sritharan, April 2018
%
% Last updated: August 2020
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

    
    % assign input struct variables
    eused = tinfo.eused;
    etime = tinfo.etime;
    econtext = tinfo.econtext;
    elabel = tinfo.elabel;
    eframe = tinfo.eframe;
    ecode = tinfo.ecode;
    fps = tinfo.fps;
    LAB = tinfo.LAB;
    c3dfile = tinfo.c3dfile;
    
    % get trial foot from subfolder, if this is not available, then just
    % assume trial foot is first stance phase found as per run-stance
    tlimb = [];
    if contains(c3dfile,'\Left\','IgnoreCase',true)
        tlimb = 'Left';
    elseif contains(c3dfile,'\Right\','IgnoreCase',true)
        tlimb = 'Right';
    end
               
    % find consective FS and FO on same leg   
    for n=1:eused-1
        
        % if no predefined trial limb found from subfolder, then just
        % assume trial foot is the first stance phase found, as per
        % run-stance
        if isempty(tlimb)&&strcmpi(econtext{n},econtext{n+1})&&(strcmpi(elabel{n},LAB.FS))&&(strcmpi(elabel{n+1},LAB.FO))
            trange = [etime(n) etime(n+1)];
            triallimb = upper(econtext{n}(1));
            elabels = elabel(n:n+1);
            econtexts = econtext(n:n+1);
            eframes = eframe(n:n+1); 
            ecodes = ecode(n:n+1);
            break; 
            
        % otherwise find the first stance phase that matches the predefined
        % trial foot
        elseif strcmpi(econtext{n},tlimb)&&strcmpi(econtext{n},econtext{n+1})&&(strcmpi(elabel{n},LAB.FS))&&(strcmpi(elabel{n+1},LAB.FO))
            trange = [etime(n) etime(n+1)];
            triallimb = upper(econtext{n}(1));
            elabels = elabel(n:n+1);
            econtexts = econtext(n:n+1);
            eframes = eframe(n:n+1); 
            ecodes = ecode(n:n+1);
            break;
        end
        
    end 

    % compute force plate sequence
    fpidx = strcmpi(bbmeta.limbs(1:2),triallimb);
    fpseq = zeros(1,2);
    fpseq(fpidx) = fps;      
    
    % assign output struct variables
    tstruct.triallimb = triallimb;
    tstruct.trange = trange;
    tstruct.fpseq = fpseq;
    tstruct.elabels = elabels;
    tstruct.econtexts = econtexts;
    tstruct.eframes = eframes;  
    tstruct.ecodes = ecodes;
    tstruct.analysedlegs = 1;

end


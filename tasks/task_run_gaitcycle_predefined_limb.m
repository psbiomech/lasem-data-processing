function tstruct = task_run_gaitcycle_predefined_limb(itf,tinfo,bbmeta)

%task_run_gaitcycle_predefined_limb: Auto generate trial info: run - gc
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
               
    % find consective FS, FO, FS on same leg
    % assume:
    %   1. stance must occur before swing
    %   2. events exist for the contralateral limb stance phase, but do not
    %       verify that these events exist, for brevity of code, e.g. for
    %       right leg swing phase, first find right leg stance events
    %       (event1=RFS, event2=RFO), then find right leg swing
    %       (event2=RFO, event5=RFS), assume event3=LFS and event4=LFO
    for n=1:eused-1
        
        % if no predefined trial limb found from subfolder, then just
        % assume trial foot is the first stance phase found, as per
        % run-stance        
        if isempty(tlimb)&&strcmpi(econtext{n},econtext{n+1})&&strcmpi(elabel{n},LAB.FS)&&strcmpi(elabel{n+1},LAB.FO)   % stance
            if strcmpi(econtext{n+1},econtext{n+4})&&strcmpi(elabel{n+1},LAB.FO)&&strcmpi(elabel{n+4},LAB.FS)   % swing            
                trange = [etime(n) etime(n+4)];
                triallimb = upper(econtext{n}(1));
                elabels = elabel(n:n+4);
                econtexts = econtext(n:n+4);
                eframes = eframe(n:n+4); 
                ecodes = ecode(n:n+4);
                break; 
            end
            
        % otherwise find the first stance phase that matches the predefined
        % trial foot
        elseif strcmpi(econtext{n},tlimb)&&strcmpi(econtext{n},econtext{n+1})&&(strcmpi(elabel{n},LAB.FS))&&(strcmpi(elabel{n+1},LAB.FO))   % stance
            if strcmpi(econtext{n+1},econtext{n+4})&&strcmpi(elabel{n+1},LAB.FO)&&strcmpi(elabel{n+4},LAB.FS)   % swing                 
                trange = [etime(n) etime(n+4)];
                triallimb = upper(econtext{n}(1));
                elabels = elabel(n:n+4);
                econtexts = econtext(n:n+4);
                eframes = eframe(n:n+4); 
                ecodes = ecode(n:n+4);
                break;
            end
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


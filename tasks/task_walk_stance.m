function tstruct = task_walk_stance(itf,tinfo,bbmeta)

%task_walk_stance Auto generate trial info: walking - stance only
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

    
    % assign input struct variables
    subj = tinfo.subj;
    trial = tinfo.trial;
    eused = tinfo.eused;
    etime = tinfo.etime;
    econtext = tinfo.econtext;
    elabel = tinfo.elabel;
    eframe = tinfo.eframe;
    ecode = tinfo.ecode;
    vlist = tinfo.vlist;
    fpchan = tinfo.fpchan;
    fps = tinfo.fps;
    LAB = tinfo.LAB;
       
    % find consective CFS, IFO, IFS, and CFO on same leg
    % (assume all these events are labelled)
    trange = zeros(1,2);
    for n=1:eused
        if strcmpi(elabel{n},LAB.FS)
            m = n + 3;
            if m<=eused
                if (strcmpi(econtext{n},econtext{m}))&&(~strcmpi(econtext{n},econtext{n+1}))&&(~strcmpi(econtext{m},econtext{m-1}))&&(strcmpi(elabel{m},LAB.FO))&&(strcmpi(elabel{n+1},LAB.FO))&&(strcmpi(elabel{m-1},LAB.FS))
                    trange = [etime(n) etime(m)];
                    triallimb = upper(econtext{n}(1));
                    elabels = elabel(n:m);
                    econtexts = econtext(n:m);
                    eframes = eframe(n:m);
                    ecodes = ecode(n:m);
                    break;
                else
                    continue;
                end
            else
                disp('Cannot compute force plate sequence - insufficient events in C3D file.');
                break;
            end
        end                
    end
    
    
    % force plate sequence    
    fpseq = zeros(m-n,2);    
    fpidx = strcmpi(bbmeta.limbs,triallimb);    
    switch length(fps)
    
        % only one plate in lab, assume this plate is used for test leg
        case 1
            fpseq(:,fpidx) = fps;

        % otherwise only one plate can be active during single support, other plates are contralateral leg
        % (assume only CTO and CHS events exist between IHS and ITO)
        otherwise
            econtra = [n+1 m-1];
            midframe = round(mean(eframe(econtra)));
            fpmidss = zeros(1,length(fps));
            for f=1:length(fps)
                fpmidss(f) = itf.GetPointData(fpchan(f)-1,2,midframe,'1');
            end
            ifpidx = find(fpmidss);
            cfpidx = find(fpmidss==0);
            fpseq(:,fpidx) = fps(ifpidx);
            for c=cfpidx
                fpseq(c,~fpidx) = fps(c);
            end
            
    end
    
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


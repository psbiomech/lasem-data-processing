function tstruct = task_walk_stance_failt(itf,tinfo,bbmeta)

%task_walk_stance_failt Auto generate trial info: walking - FAI project
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


    % 1st stance phase:    
    % find consective IFS, CFS, and IFO on same leg
    % (assume CFO not labelled due to no FP - this is true for FAI project)
    for n=1:eused
        if strcmpi(elabel{n},LAB.FS)
            m = n + 2;
            if m<=eused
                if (strcmpi(econtext{n},econtext{m}))&&(~strcmpi(econtext{m},econtext{m-1}))&&(strcmpi(elabel{m},LAB.FO))&&(strcmpi(elabel{n+1},LAB.FS))
                    tranges{1} = [etime(n) etime(m)];
                    triallimbs{1} = upper(econtext{n}(1));
                    elabels{1} = elabel(n:m);
                    econtexts{1} = econtext(n:m);
                    eframes{1} = eframe(n:m);
                    ecodes{1} = ecode(n:m);
                    ms{1} = m;
                    ns{1} = n;
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
    
    
    % 2nd stance phase:    
    % find consective IFS, CFO, CFS, and IFO on same leg
    % (assume all 4 events are labelled)
    for n=2:eused   % start from second event
        if strcmpi(elabel{n},LAB.FS)
            m = n + 3;
            if m<=eused
                if (strcmpi(econtext{n},econtext{m}))&&(~strcmpi(econtext{n},econtext{n+1}))&&(~strcmpi(econtext{m},econtext{m-1}))&&(strcmpi(elabel{m},LAB.FO))&&(strcmpi(elabel{n+1},LAB.FO))&&(strcmpi(elabel{m-1},LAB.FS))
                    tranges{2} = [etime(n) etime(m)];
                    triallimbs{2} = upper(econtext{n}(1));
                    elabels{2} = elabel(n:m);
                    econtexts{2} = econtext(n:m);
                    eframes{2} = eframe(n:m);
                    ecodes{2} = ecode(n:m);
                    ms{2} = m;
                    ns{2} = n;                    
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
        
    
    % force plate sequence for each stance phase    
    for p=1:2
        fpseqs{p} = zeros(ms{p}-ns{p},2);    
        fpidx = strcmpi(bbmeta.limbs,triallimbs{p});    
        switch length(fps)

            % only one plate in lab, assume this plate is used for test leg
            case 1
                error('Cannot have 2 consecutive stances phases on 1 force plate. Exiting.')
                
            % otherwise only one plate can be active during single support, other plates are contralateral leg
            % (assume only CTO and CHS events exist between IHS and ITO)
            otherwise
                if p==1
                    econtra = [ns{p} ns{p}+1];
                else
                    econtra = [ns{p}+1 ms{p}-1];
                end
                midframe = round(mean(eframe(econtra)));
                fpmidss = zeros(1,length(fps));
                for f=1:length(fps)
                    fpmidss(f) = itf.GetPointData(fpchan(f)-1,2,midframe,'1');
                end
                ifpidx = find(fpmidss);
                cfpidx = find(fpmidss==0);
                fpseqs{p}(:,fpidx) = fps(ifpidx);
                for c=cfpidx
                    fpseqs{p}(c,~fpidx) = fps(c);
                end

        end
    end
    
    
    % add dummy CFO event and associated parameters for 3-event 1st stance
    % (assume CFO occurs the same time period after IFS as CFS occurs prior
    % to IFO, future versions should include an algorthim to estimate
    % event times from spatial marker data)
    oldf = eframes{1};
    cfof = oldf(1)+round((oldf(3)-oldf(1))*(oldf(3)-oldf(2))/(oldf(3)-oldf(1)));
    eframes{1} = [oldf(1) cfof oldf(2:3)];
    fpseqs{1} = [fpseqs{1}(1,:); fpseqs{1}(1,:); fpseqs{1}(2,:)];
    elabels{1} = elabels{2};
    econtexts{1} = [econtexts{1}(1) econtexts{1}(2) econtexts{1}(2:3)];
    ecodes{1} = [ecodes{1}(1), {[ecodes{1}{2}(1) ecodes{1}{3}(2:3)]}, ecodes{1}{2:3}];
    
    
    % assign output struct variables
    tstruct.triallimb = triallimbs;
    tstruct.trange = tranges;
    tstruct.fpseq = fpseqs;
    tstruct.elabels = elabels;
    tstruct.econtexts = econtexts;
    tstruct.eframes = eframes;
    tstruct.ecodes = ecodes;
    tstruct.analysedlegs = 2;
    
end



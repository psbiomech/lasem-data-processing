function tstruct = task_walk_stance(itf,tinfo,bbmeta)

%task_manual Auto generate trial info: walking - stance only
%   Prasanna Sritharan, July 2017

    
    % assign input struct variables
    subj = tinfo.subj;
    trial = tinfo.trial;
    eused = tinfo.eused;
    etime = tinfo.etime;
    econtext = tinfo.econtext;
    elabel = tinfo.elabel;
    eframe = tinfo.eframe;
    vlist = tinfo.vlist;
    fpchan = tinfo.fpchan;
    fps = tinfo.fps;
    LAB = tinfo.LAB;
       
    % find consective CFS, IFO, IFS, and CFO on same leg
    % (assume all these events are labelled)
    trange = zeros(1,2);
    triallimbguess = [];
    for n=1:eused
        if strcmpi(elabel{n},LAB.FS)
            m = n + 3;
            if m<=eused
                if (strcmpi(econtext{n},econtext{m}))&&(~strcmpi(econtext{n},econtext{n+1}))&&(~strcmpi(econtext{m},econtext{m-1}))&&(strcmpi(elabel{m},LAB.FO))&&(strcmpi(elabel{n+1},LAB.FO))&&(strcmpi(elabel{m-1},LAB.FS))
                    trange = [etime(n) etime(m)];
                    triallimb = lower(econtext{n});
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
    fpidx = strcmpi(bbmeta.limbs,triallimb(1));    
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

end


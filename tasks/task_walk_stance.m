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
    fpchan = tinfo.fpchan;
    fps = tinfo.fps;
    LAB = tinfo.LAB;
       
    % find consective CFS, IFO, IFS, and CFO on same leg
    trange = zeros(1,2);
    for n=1:eused-1
        if strcmpi(elabel{n},LAB.FS)
            for m=n:eused-1
                if (strcmpi(econtext{n},econtext{m}))&&(strcmpi(elabel{m},LAB.FO))
                    trange = [etime(n) etime(m)];
                    triallimbguess = lower(econtext{n});
                    break;
                else
                    continue;
                end
            end
            if ~isempty(find([0 0],1)), break; end;
        else
            continue;
        end                
    end
    
    
    % force plate sequence    
    fpseq = zeros(m-n,2);    
    switch length(fps)
    
        % only one plate in lab, assume this plate is used for test leg
        case 1
            fpidx = strcmpi(bbmeta.limbs,triallimb);
            fpseq(:,fpidx) = fps;

        % otherwise only one plate can be active during single support, other plates are contralateral leg
        % (assume only CTO and CHS events exist between IHS and ITO)
        otherwise
            econtra = [n+1 m-1];
            midframe = round(mean(eframe(econtra)));
            fpmidss = zeros(length(fps));
            for f=1:length(fps)
                fpmidss(f) = itf.GetPointData(fpchan(f),);
            end
    
    
    

    
    
    
    fpidx = strcmpi(bbmeta.limbs,triallimb);
    fpseq = zeros(1,2);
    fpseq(fpidx) = fps;      
    
    % assign output struct variables
    tstruct.triallimb = triallimb;
    tstruct.trange = trange;
    tstruct.fpseq = fpseq;

end


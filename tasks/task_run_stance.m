function tstruct = task_run_stance(itf,tinfo,bbmeta)

%task_manual Auto generate trial info: run - stance only
%   Prasanna Sritharan, July 2017

    
    % assign input struct variables
    eused = tinfo.eused;
    etime = tinfo.etime;
    econtext = tinfo.econtext;
    elabel = tinfo.elabel;
    fps = tinfo.fps;
    LAB = tinfo.LAB;
       
    % find consective FS and FO on same leg
    for n=1:eused-1
       if strcmpi(econtext{n},econtext{n+1})&&(strcmpi(elabel{n},LAB.FS))&&(strcmpi(elabel{n+1},LAB.FO))
           trange = [etime(n) etime(n+1)];
           triallimb = lower(econtext{n}(1));
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

end


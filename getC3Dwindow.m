function [vfrange,nframes,trialfoot] = getC3Dwindow(itf,actflag,subj,trial)


%getC3Dwindow Determine time window based on activity type
%   Prasanna Sritharan, June 2017

    % event defaults
    LAB.FS = 'FOOT STRIKE';
    LAB.FO = 'FOOT OFF';
    LAB.GEN = 'GENERAL';
    CON.R = 'RIGHT';
    CON.L = 'LEFT';
    
    % get video frequency
    vfreq = itf.GetVideoFrameRate;
    
    % get first frame
    vfirst = itf.GetVideoFrame(0);
       
    % get number of events
    idx = itf.GetParameterIndex('EVENT','USED');
    eused = itf.GetParameterValue(idx,0);

    % get events and timings
    etime = zeros(1,eused);
    econtext = cell(1,eused);
    elabel = cell(1,eused);
    idx = itf.GetParameterIndex('EVENT','TIMES');
    idx2 = itf.GetParameterIndex('EVENT','CONTEXTS');
    idx3 = itf.GetParameterIndex('EVENT','LABELS');
    for n=1:eused
       etime(n) = itf.GetParameterValue(idx,2*n-1);
       econtext{n} = itf.GetParameterValue(idx2,n-1);
       elabel{n} = itf.GetParameterValue(idx3,n-1);
    end

    % sort events in ascending time order
    [etime,order] = sort(etime);
    econtext = econtext(order);
    elabel = elabel(order);
    
    % display events
    disp(' ');
    disp([subj ' ' trial]);
    fprintf(1,'SeqNo\tTime\t\tContext\t\tLabel\n');
    for n=1:eused
        fprintf(1,'%i\t\t%5.2f\t\t%s\t\t%s\n',n,etime(n),econtext{n},elabel{n});
    end
    disp(' ');
    
    % determine window based on activity type
    switch lower(actflag)
        
        % manual
        % enter first and last event manually
        case 'manual'
            seq1 = input('Enter sequence no. of first event [first in file]: ');
            seq2 = input('Enter sequence no. of last event [last in file]: ');
            if (~isenum(seq1))||(~isenum(seq2))||(seq1<=seq2)
                seq1 = 1;
                seq2 = eused(end);
            end
            trange = [etime(seq1) etime(seq2)];
            trialfoot = econtext{seq1};
        
        % run stance:
        % look for consecutive FS and FO on same foot
        case 'run-stance'
            for n=1:eused-1
               if strcmpi(econtext{n},econtext{n+1})&&(strcmpi(elabel{n},LAB.FS))&&(strcmpi(elabel{n+1},LAB.FO))
                   trange = [etime(n) etime(n+1)];
                   trialfoot = econtext{n};
                   break;
               end
            end               
                            
        % single-leg drop and jump: 
        % look for consecutive FS and FO on same foot
        case 'sldj'            
            for n=1:eused-1
               if strcmpi(econtext{n},econtext{n+1})&&(strcmpi(elabel{n},LAB.FS))&&(strcmpi(elabel{n+1},LAB.FO))
                   trange = [etime(n) etime(n+1)];
                   trialfoot = econtext{n};
                   break;
               end
            end            
            
            
            
    end
        
    % calculate window video frames
    vfrange = round(((trange*vfreq)+1)-vfirst+1);
    
    % calculate no. of frames
    nframes = vfrange(2)-vfrange(1)+1;


end


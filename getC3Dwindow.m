function c3dout = getC3Dwindow(c3dfile,task,bbmeta,subj,trial)


%getC3Dwindow Determine time window based on activity type
%   Prasanna Sritharan, June 2017

    % add search path for tasks
    addpath('./tasks/');    

    % event defaults
    LAB.FS = 'FOOT STRIKE';
    LAB.FO = 'FOOT OFF';
    LAB.GEN = 'GENERAL';


    % add C3D extension if necessary
    if isempty(regexpi(c3dfile,'.c3d')), c3dfile = [c3dfile '.c3d']; end;

    % initiate C3DServer
    itf = c3dserver();

    % turn strict parameter checking off
    itf.SetStrictParameterChecking(0);

    % open C3D file
    try
        sflag = itf.Open(c3dfile,3);
    catch
        sflag = -1;
        disp('ERROR: C3D file could not be opened for processing. Please check if file exists and is not corrupted.');
    end
    
    % get video frequency
    vfreq = itf.GetVideoFrameRate;
        
    % get first video frame
    vfirst = itf.GetVideoFrame(0);
       
    % get analog-to-video ratio
    avratio = itf.GetAnalogVideoRatio;
    
    % get number of events
    idx = itf.GetParameterIndex('EVENT','USED');
    eused = itf.GetParameterValue(idx,0);

    % get events and timings
    etime = zeros(1,eused);
    econtext = cell(1,eused);
    elabel = cell(1,eused);
    eframe = zeros(1,eused);
    idx = itf.GetParameterIndex('EVENT','TIMES');
    idx2 = itf.GetParameterIndex('EVENT','CONTEXTS');
    idx3 = itf.GetParameterIndex('EVENT','LABELS');
    for n=1:eused
       etime(n) = itf.GetParameterValue(idx,2*n-1);
       econtext{n} = itf.GetParameterValue(idx2,n-1);
       elabel{n} = itf.GetParameterValue(idx3,n-1);
       eframe(n) = round(vfreq*etime(n)+1);
    end

    % sort events in ascending time order
    [etime,order] = sort(etime);
    econtext = econtext(order);
    elabel = elabel(order);  
    eframe = eframe(order);

    % event labels and contexts in short form
    ecode = {num2cell(cellfun(@(x) upper(x(1)),econtext)); cellfun(@(x) upper([x(1) x(6)]),elabel,'UniformOutput',false)};
    ecode2 = cell(size(ecode{1}));
    for e=1:length(ecode{1})
        ecode2{e} = [ecode{1}{e} ecode{2}{e}];
    end
    ecode = ecode2;
    
    
    % get number of video channels used
    idx = itf.GetParameterIndex('POINT','USED');
    nused = itf.GetParameterValue(idx,0);               

    % list all point parameters
    vlist = cell(1,nused);
    idx = itf.GetParameterIndex('POINT','LABELS');
    for n=1:nused
        vlist{n} = itf.GetParameterValue(idx,n-1);
    end    

    % get force plate numbers
    fpnums = regexp(vlist,[bbmeta.fpvectors{2} '(\d+)'],'tokens');
    isfp = ~cellfun('isempty',fpnums);
    fpchan = find(isfp);
    fpnums = fpnums(isfp); 
    nfps = size(fpnums,2);
    fps = zeros(1,nfps);
    for f=1:nfps, fps(f) = str2double(fpnums{f}{1}{1}); end;    
    
    
    % generate info struct for evaluating C3D window
    tinfo.subj = subj;
    tinfo.trial = trial;
    tinfo.eused = eused;
    tinfo.etime = etime;
    tinfo.econtext = econtext;
    tinfo.elabel = elabel;
    tinfo.eframe = eframe;
    tinfo.ecode = ecode;
    tinfo.vlist = vlist;
    tinfo.fpchan = fpchan;
    tinfo.fps = fps;
    tinfo.LAB = LAB;
       
    
    
    % determine window parameters based on activity type
    switch lower(task)
        
        % manual      
        case 'manual'
            tstruct = task_manual(itf,tinfo,bbmeta);

        % walk stance:
        case 'walk-stance'
            tstruct = task_walk_stance(itf,tinfo,bbmeta);
            
        % run stance:
        case 'run-stance'
            tstruct = task_run_stance(itf,tinfo,bbmeta);             
                            
        % single-leg drop and jump: 
        case 'sldj'            
            tstruct = task_sldj(itf,tinfo,bbmeta);

        otherwise
            error(['Unknown task code "' task '". Exiting.']);
            
    end

    
    % assign info struct variables
    trange = tstruct.trange;
    triallimb = tstruct.triallimb;
    fpseq = tstruct.fpseq;
    elabels = tstruct.elabels;
    econtexts = tstruct.econtexts;
    eframes = tstruct.eframes;
    ecodes = tstruct.ecodes;
    
    % calculate window for video frames
    vfrange = round(((trange*vfreq)+1)-vfirst+1);
    
    % calculate window for analog frames
    afrange = round((vfrange-1)*avratio+1);
    
    % calculate no. of video frames
    nvframes = vfrange(2)-vfrange(1)+1;
    
    % calculate no. of analog frames
    naframes = afrange(2)-afrange(1)+1; 
       
    % close C3D file
    itf.Close();    
    
    
    % generate output struct
    c3dout.vfrange = vfrange;
    c3dout.nvframes = nvframes;
    c3dout.afrange = afrange;
    c3dout.naframes = naframes;
    c3dout.trange = trange;
    c3dout.fpseq = fpseq;
    c3dout.triallimb = triallimb;
    %c3dout.elabels = elabels;
    %c3dout.econtexts = econtexts;
    c3dout.eframes = eframes;
    c3dout.ecodes = ecodes;
    
    % write info to stdout
    disp(['Trial limb: ' triallimb]);
    disp(['Time range: ' mat2str(trange,4)]);
    disp(['Force plate sequence: ' mat2str(fpseq)]);
    
end


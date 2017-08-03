function fpseq = getFPsequence(itf,bbmeta,task,triallimb)


%getFPsequence Determine force plate stepping sequence from C3D data
%   Prasanna Sritharan, July 2017

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
    fpnums = regexp(vlist,[bbmeta.fpvectors{1} '(\d+)'],'tokens');
    fpnums = fpnums(~cellfun('isempty',fpnums)); 
    nfps = size(fpnums,2);
    fps = zeros(1,nfps);
    for f=1:nfps, fps(f) = str2num(fpnums{f}{1}{1}); end;
    
    % determine sequence based on task
    switch task

        % manually enter sequence
        case 'manual'
            fpseq = input('Enter force plate sequence: ');
            fpsize = size(fpseq);
            if (~ismatrix(fpseq))||(fpsize(2)~=2)
                fpseq = [0 0];
            end

        % walk stance: 
        % TBA
        case 'walk-stance'
            disp('TBA');
            
        % run stance: 
        % assume only 1 force plate active, assign to trial foot
        case 'run-stance'
            fpidx = strcmpi(bbmeta.limbs,triallimb);
            fpseq = zeros(1,2);
            fpseq(fpidx) = fps;            
            
        % single-leg drop and jump: 
        % assume only 1 force plate active, assign to trial foot
        case 'sldj'
            fpidx = strcmpi(bbmeta.limbs,triallimb);
            fpseq = zeros(1,2);
            fpseq(fpidx) = fps;            
            
    end
    
    
end


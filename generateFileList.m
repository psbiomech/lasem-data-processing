function [flist,fnames,subtri] = generateFileList(c3droot,subjprefix,trialprefix,selectmode)

%generateFileList Parse file structure and extract files with names matching pattern
%   Prasanna Sritharan, June 2017

   
    % generate expression for pattern matching
    c3dexpr = ['(' subjprefix '\d+' trialprefix '\d+)\.c3d'];

    % parse all subdirectories and get list of all C3D files starting from
    % c3droot that match c3dexpr
    fstruct = subdir([c3droot '\*.c3d']);
    flist = cell(size(fstruct));
    for f=1:length(flist)
        flist{f} = fstruct(f).name;
    end

    % test if file of interest
    fflag = zeros(size(flist));
    tokens = cell(size(flist));
    for f=1:length(flist)
        [toks,match] = regexp(fstruct(f).name,['.*\\' c3dexpr '$'],'tokens');
        fflag(f) = ~isempty(match);
        if (fflag(f)==1), tokens{f} = toks{1}{1}; end;
    end
    
    % cut down list to only files of interest
    ftemp = flist(logical(fflag));
    toktemp = tokens(logical(fflag));
    
    % further manually cut down list
    switch selectmode
        
        % keep all files in list
        case 'auto'
            flist = ftemp;
            fnames = toktemp;
        
        % select files to keep and discard
        fflag2 = zeros(size(ftemp));
        case 'manual'
            disp(' ');
            disp('Keep these files?');
            disp('------------------------------');
            for f=1:length(ftemp)
                keep = input([toktemp{f} ': y/n [y]: '],'s');  % default: yes
                if (isempty(keep))||~strcmpi(keep,'Y')||~strcmpi(keep,'N'), keep = 'y'; end
                switch upper(keep)
                    case 'Y'
                        fflag2(f) = 1;
                    case 'N'
                        fflag2(f) = 0;
                end
            end
            flist = ftemp(logical(fflag2));
            fnames = toktemp(logical(fflag2));
            disp(' ');
    end
    
    % further split tokens into subjects and trials, trim results
    splitexp = ['(' subjprefix '\d+)(' trialprefix '\d+)'];
    subtri = cell(size(fnames));
    for t=1:length(fnames)
       [toks2,~] = regexp(fnames{t},splitexp,'tokens');
       sbtemp = regexp(toks2{1},'[-_.]*(\w*)[-_.]*','tokens');
       subtri{t} = [sbtemp{1}{1},sbtemp{2}{1}];
    end
    

end


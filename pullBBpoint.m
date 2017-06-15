function [point,trialfoot,sflag] = pullBBpoint(c3dfile,bbmeta,amp,actflag)

%pullC3Ddata Get Body Builder point data from C3D file
%   Prasanna Sritharan, June 2017
   
    try

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

        
        % get time range window
        [vfrange,nframes,trialfoot] = getC3Dwindow(itf,actflag);
                
        % get number of video channels used
        idx = itf.GetParameterIndex('POINT','USED');
        nused = itf.GetParameterValue(idx,0);               
        
        % get video channel list
        vlist = cell(1,nused);
        idx = itf.GetParameterIndex('POINT','LABELS');
        for n=1:nused
            vlist{n} = itf.GetParameterValue(idx,n-1);
        end
        
        % get desired output data groups
        outgrps = bbmeta.BBGROUPS(logical(amp));
        
        % get data for all parameters in each desired group and store in struct
        for g=1:length(outgrps)
            idx = itf.GetParameterIndex('POINT',outgrps{g});
            nvals = itf.GetParameterLength(idx);
            for n=0:nvals-1
                qname = itf.GetParameterValue(idx,n);
                vchan = find(strcmp(qname,vlist))-1;
                for x=1:3
                   point.(outgrps{g}).(qname)(:,x) = double(cell2mat(itf.GetPointDataEx(vchan,x-1,vfrange(1),vfrange(2),'1')));
                end
            end            
        end                   

        % close C3D file
        itf.Close();
        
    catch exception
        rethrow(exception)
        sflag = -2;
        disp('ERROR: C3D file could not be processed.');
    end

end


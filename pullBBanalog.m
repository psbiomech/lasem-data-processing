function [analog,sflag] = pullBBanalog(c3dfile,vfrange,bbmeta,ge)


%pullC3Ddanalog Get Body Builder analog data from C3D file
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
                
        % get number of analog channels used
        idx = itf.GetParameterIndex('ANALOG','USED');
        nused = itf.GetParameterValue(idx,0);               
        
        % get analog channel list
        alist = cell(1,nused);
        idx = itf.GetParameterIndex('ANALOG','LABELS');
        for n=1:nused
            alist{n} = itf.GetParameterValue(idx,n-1);
        end
        
        % get number of force plates
        idx = itf.GetParameterIndex('FORCE_PLATFORM','USED');
        nfp = itf.GetParameterValue(idx,0);          
        
        % get desired output data groups
        outgrps = bbmeta.BBANALOGS(logical(ge));
        
        % get data for all parameters in each desired group and store in struct
        analog = struct();
        for g=1:length(outgrps)
            for a=1:2
                for n=1:nfp
                    for x=1:3
                        qstructname = [upper(bbmeta.GRF.prefix{a}) num2str(n)];
                        qname = [upper(bbmeta.GRF.prefix{a}) lower(bbmeta.dirs{x}) num2str(n)];
                        achan = find(strcmp(qname,alist))-1;                        
                        analog.(outgrps{g}).(qstructname)(:,x) = double(cell2mat(itf.GetAnalogDataEx(achan,vfrange(1),vfrange(2),'1',0,0,'0')));
                    end
                end  
            end
        end                   

        % close C3D file
        itf.Close();
        
    catch excp
        rethrow(excp);
        sflag = -2;
        disp('ERROR: C3D file could not be processed.');
    end

end


function [point,sflag] = pullBBpoint(c3dfile,vfrange,bbmeta,ampg)

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
        outgrps = bbmeta.BBGROUPS(logical(ampg));
        
        % get data for all parameters in each desired group and store in struct
        point = struct();
        for g=1:length(outgrps)
            for q=1:length(bbmeta.(outgrps{g}))
        
                % determine how to extract based on point data type
                switch outgrps{g}
                    
                    % Body Builder GRF point data
                    case 'GRFS'                        
                        fpnums = regexp(vlist,[bbmeta.fpvectors{1} '(\d+)'],'tokens');
                        fpnums = fpnums(~cellfun('isempty',fpnums)); 
                        %point.activefp = zeros(length(fpnums));
                        for f = 1:length(fpnums)
                            fpsuffix = fpnums{f}{1}{1};
                            %point.activefp(f) = fpsuffix;
                            cop = [bbmeta.fpvectors{1} fpsuffix];
                            grf = [bbmeta.fpvectors{2} fpsuffix];
                            copchan = find(strcmp(cop,vlist))-1;
                            grfchan = find(strcmp(grf,vlist))-1;
                            qname = [bbmeta.(outgrps{g}){q} num2str(f)];
                            for x=1:3
                                copvec = double(cell2mat(itf.GetPointDataEx(copchan,x-1,vfrange(1),vfrange(2),'1')));
                                grfvec = double(cell2mat(itf.GetPointDataEx(grfchan,x-1,vfrange(1),vfrange(2),'1')));
                                point.(outgrps{g}).(qname)(:,x) = grfvec - copvec;
                            end
                        end
                            
                    % all other Body Builder data
                    otherwise
                        for f=1:2
                            qname = [bbmeta.limbs{f} bbmeta.(outgrps{g}){q}];
                            vchan = find(strcmp(qname,vlist))-1;
                            for x=1:3
                                point.(outgrps{g}).(qname)(:,x) = double(cell2mat(itf.GetPointDataEx(vchan,x-1,vfrange(1),vfrange(2),'1')));
                            end
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


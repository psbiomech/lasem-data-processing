function temp = buildTempStruct(tstruct,p)


%BUILDTEMPSTRUCT Build temporary struct for multiple analysed legs
%   Prasanna Sritharan, April 2018

    % build struct
    temp.vfirst = tstruct.vfirst;
    temp.vfrange = tstruct.vfrange{p};
    temp.nvframes = tstruct.nvframes{p};
    temp.afrange = tstruct.afrange{p};
    temp.naframes = tstruct.naframes{p};
    temp.trange = tstruct.trange{p};
    temp.fpseq = tstruct.fpseq{p};
    temp.triallimb = tstruct.triallimb{p};
    temp.analysedlegs = 1;
    temp.filepath = tstruct.filepath;
    
end


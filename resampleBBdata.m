function bbstruct = resampleBBdata(bbstruct,subj,trial,rawdata,newsamp)

%resampleBBdata Resample Body Builder data extracted from C3D
%   Prasanna Sritharan, June 2017

    % parse Body Builder data groups
    grps = fieldnames(rawdata);
    for g=1:length(grps)

        % parse quantitative parameters within group
        qnames = fieldnames(rawdata.(grps{g}));
        for q=1:length(qnames)

            % resample data
            bbstruct.(subj).(trial).(grps{g}).(qnames{q}) = resampleData(rawdata.(grps{g}).(qnames{q}),newsamp);

        end
    end

end


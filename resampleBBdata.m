function resampled = resampleBBdata(bb,newsamp)

%resampleBBdata Resample Body Builder data extracted from C3D
%   Prasanna Sritharan, June 2017

    % parse Body Builder data groups
    grps = fieldnames(bb);
    for g=1:length(grps)

        % parse quantitative parameters within group
        qnames = fieldnames(bb.(grps{g}));
        for q=1:length(qnames)

            % resample data
            resampled.(grps{g}).(qnames{q}) = resampleData(bb.(grps{g}).(qnames{q}),newsamp);

        end
    end

end


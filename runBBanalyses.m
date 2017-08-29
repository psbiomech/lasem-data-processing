function bbstruct = runBBanalyses(bbstruct,bbmeta)

%runBBanalyses Run additional analyses on Body Builder data
%   Prasanna Sritharan, August 2017

    % add search path for tasks
    addpath('./analyses/'); 

    % get Body Builder point data from C3D files
    subjs = fieldnames(bbstruct);
    for s=1:length(subjs)
        trials = fieldnames(bbstruct.(subjs{s}));
        for t=1:length(trials)            
            if isempty(find(strcmpi(trials{t},{'cohort','affected'}),1))

                % joint rotational work (angular work)
                bbstruct = analysis_work_rotational(bbstruct,bbmeta,subjs{s},trials{t});     

                % joint rotational impulse
                bbstruct = analysis_impulse_rotational(bbstruct,bbmeta,subjs{s},trials{t});                

                % GRF impulse
                bbstruct = analysis_impulse_grf(bbstruct,bbmeta,subjs{s},trials{t});   
                
                
            
            else
                continue;
            end
        end
    end   


end


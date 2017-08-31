function bbstruct = calcAnalysesMeans(bbstruct,bbmeta,user)

%meanBBanalyses Calculate means for additional analyses on Body Builder data
%   Prasanna Sritharan, August 2017

    % add search path for tasks
    addpath('./analyses/'); 

    
    % joint rotational work (angular work)
    bbstruct = analysis_mean_work_rotational(bbstruct,bbmeta);     

    % joint rotational impulse
    %bbstruct = analysis_mean_impulse_rotational(bbstruct,bbmeta);                

    % GRF impulse
    %bbstruct = analysis_mean_impulse_grf(bbstruct,bbmeta);   
                                            
end


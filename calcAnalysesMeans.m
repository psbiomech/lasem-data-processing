function bbstruct = calcAnalysesMeans(bbstruct,bbmeta,user)

%meanBBanalyses Calculate means for additional analyses on Body Builder data
%   Prasanna Sritharan, August 2017

    % add search path for tasks
    addpath('./analyses/'); 

    
    % joint rotational work (angular work)
    bbstruct = analysis_mean_work_rotational(bbstruct,bbmeta);     

    % joint rotational impulse
    bbstruct = analysis_mean_impulse_rotational(bbstruct,bbmeta);                

    % GRF impulse
    bbstruct = analysis_mean_impulse_grf(bbstruct,bbmeta);   

    % Body Builder data values at events
    bbstruct = analysis_mean_eventval_angle(bbstruct,bbmeta);
    bbstruct = analysis_mean_eventval_moment(bbstruct,bbmeta);
    bbstruct = analysis_mean_eventval_power(bbstruct,bbmeta);
    bbstruct = analysis_mean_eventval_grf(bbstruct,bbmeta);
    
end


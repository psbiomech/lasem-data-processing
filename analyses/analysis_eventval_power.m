function bbstruct = analysis_eventval_power(bbstruct,bbmeta,user,subj,trial)


%analysis_eventval_angle Get GRF values at events
%   Prasanna Sritharan, August 2017

    % input data group name
    GRPIN = bbmeta.BBGROUPS{1};
    GRPOUT = upper(bbmeta.BBANALYSES{6});   

    % midstring
    INMIDSTR = GRPIN(1:end-1);
    OUTMIDSTR = bbmeta.BBANALYSES{6};     

    % get values
    qnames = fieldnames(bbstruct.(subj).(trial).(GRPIN));        
    timemap = linspace(bbstruct.(subj).(trial).vfrange(1),bbstruct.(subj).(trial).vfrange(2),user.SAMP);
    sampmap = 1:user.SAMP;
    for q=1:length(qnames)
        for e=1:length(bbstruct.(subj).(trial).ecodes)
            tstep = round(interp1(timemap,sampmap,bbstruct.(subj).(trial).eframes(e)));
            bbstruct.(subj).(trial).(GRPOUT).(qnames{q})(e,:) = bbstruct.(subj).(trial).(GRPIN).(qnames{q})(tstep,:);
        end
    end
        
end


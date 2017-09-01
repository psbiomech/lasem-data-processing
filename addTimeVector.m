function bbstruct = addTimeVector(bbstruct,subj,trial,samp)

%addTimeVector Add time vector to trial data
%   Prasanna Sritharan, August 2017

    % absolute time vector    
    bbstruct.(subj).(trial).TIMES.absolute = linspace(bbstruct.(subj).(trial).trange(1),bbstruct.(subj).(trial).trange(2),samp);
    
    % relative time vector
    bbstruct.(subj).(trial).TIMES.relative = bbstruct.(subj).(trial).TIMES.absolute - bbstruct.(subj).(trial).TIMES.absolute(1);
    
end


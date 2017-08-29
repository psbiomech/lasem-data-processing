function bbstruct = addTimeVector(bbstruct,subj,trial,samp)

%addTimeVector Add time vector to trial data
%   Prasanna Sritharan, August 2017

    % create time vector    
    bbstruct.(subj).(trial).TIME = linspace(bbstruct.(subj).(trial).trange(1),bbstruct.(subj).(trial).trange(2),samp);
    
end


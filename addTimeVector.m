function bbstruct = addTimeVector(bbstruct,subj,trial,samp)

%addTimeVector Add time vector to trial data
%   Prasanna Sritharan, August 2017

    % create time vector
    bbstruct.(subj).(trial).TIME = resampleData(bbstruct.(subj).(trial).trange',samp);
    
end


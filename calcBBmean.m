function bbstruct = calcBBmean(bbstruct,bbmeta,user)


%calcMeanBB Mean and standard deviation of BB data
%   Prasanna Sritharan, July 2017

    % assign struct fields
    ampg = user.AMPG;

    % calculate subject means
    bbwithsubjmean = meanBBsubject(bbstruct,bbmeta,ampg);
    
    % calculate total means (requires subject means already calculated)
    bbstruct = meanBBall(bbwithsubjmean,bbmeta,ampg);


end


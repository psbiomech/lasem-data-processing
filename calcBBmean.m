function bbstruct = calcBBmean(bbstruct,bbmeta,AMPG)


%calcMeanBB Mean and standard deviation of BB data
%   Prasanna Sritharan, July 2017

    % calculate subject means
    bbwithsubjmean = meanBBsubject(bbstruct,bbmeta,AMPG);
    
    % calculate total means (requires subject means already calculated)
    bbstruct = meanBBall(bbwithsubjmean,bbmeta,AMPG);


end


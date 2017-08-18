function bb = calcBBmean(bb,bbmeta,AMPG)


%calcMeanBB Mean and standard deviation of BB data
%   Prasanna Sritharan, July 2017

    % calculate subject means
    bbwithsubjmean = meanBBsubject(bb,bbmeta,AMPG);
    
    % calculate total means (requires subject means already calculated)
    bb = meanBBall(bbwithsubjmean,bbmeta,AMPG);


end


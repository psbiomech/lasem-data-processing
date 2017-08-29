function saveBBstruct(bb,user)

%saveBBstruct Save Body Builder struct to MAT file
%   Prasanna Sritharan, June 2017

    % assign struct fields
    bbfilename = user.TRIALPREFIX;
    bbfilepath = user.OUTPUTPATH;

    % add MAT extension if necessary
    if isempty(regexpi(bbfilename,'.mat')), bbfilename = [bbfilename '.mat']; end; 

    % save Body Builder struct
    mkdir(bbfilepath);
    save([bbfilepath '\' bbfilename],'bb');
    
end


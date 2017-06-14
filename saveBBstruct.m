function saveBBstruct(bb,bbfilename,bbfilepath)

%saveBBstruct Save Body Builder struct to MAT file
%   Prasanna Sritharan, June 2017

    % add MAT extension if necessary
    if isempty(regexpi(bbfilename,'.mat')), xlsname = [xlsname '.mat']; end; 

    % save Body Builder struct
    save([bbfilepath '\' bbfilename],'bb');
    
end


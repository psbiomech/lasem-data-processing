function bbstruct = loadMetaStruct()


%LOADMETASTRUCT Load metadata struct
%   Prasanna Sritharan, August 2020


% user settings
user = getUserScriptSettings();
structpath = user.DATASRCPATH;


bbstruct = load(fullfile(structpath,'bb.mat'));

end


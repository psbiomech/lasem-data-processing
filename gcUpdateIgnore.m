function bbstruct = gcUpdateIgnore(bbstruct,bbmeta,user)


%GCUPDATEIGNORE Update the ignore flag for non-gaitcycle trials
%   Prasanna Sritharan, September 2020
%
% For use with Mark Scholes FAILT running data only.
%
% Loads gait cycle trials meta table and updates ignore flag in bbstruct to
% ignore those non-gaitcycle trials. This is a wide-form table, with the
% format given below. This function uses the meta table as a look-up table.
%
% Table format:
%
% Row 1: Headers: Subject, Trial codes (e.g. RUN01, RUN02, etc)
%
% Column 1: Subject code
% Columns 2..n: Trials, with flag (0=non-gaitcycle,1=gaitcycle)



% assign struct fields
structpath = user.DATASRCPATH;
errorpath = user.ERRORPATH;
subjprefix = user.SUBJECTPREFIX;
trialprefix = user.TRIALPREFIX;

% load the gait cycles trials meta table
gctable = readtable(fullfile(structpath,[upper(subjprefix) '_' upper(trialprefix) '_gaitcycle_trials.xlsx']));
gctable.Properties.VariableNames = upper(gctable.Properties.VariableNames);
colnames = gctable.Properties.VariableNames;

% update ignore flags
gcignorelist = {};
subjs = fieldnames(bbstruct);
for s=1:length(subjs)

    subj = subjs{s};
    trials = fieldnames(bbstruct.(subjs{s}));

    disp(' ');
    disp(['Subject: ' subjs{s}]);
    disp(['==============================']);        

    % look up the row index of the subject in the table
    % (assumes the subject exists in the table)
    sidx = find(strcmpi(gctable.(colnames{1}),subj),1,'first');
    
    for t=1:length(trials)                                    
        trial = trials{t};           
        if isempty(find(strcmpi(trials{t},bbmeta.SUBJECTFIELDS),1))            
              
            % look up the gait cycle flag for the current trial
            gcflag = gctable.(upper(trial))(sidx);
            
            % if the trial is a gaitcycle trial and it is already ignored,
            % then record this, but continue to ignore file
            if (gcflag==1)&&(bbstruct.(subj).(trial).ignore==1)
                gcignorelist = [gcignorelist, [subj '_' trial ' *** GC TRIAL!!! ***']];  
                disp(['Trial: ' trial ' ---> Invalid GC trial, previously ignored']);
            elseif (gcflag==0)&&(bbstruct.(subj).(trial).ignore==1)
                gcignorelist = [gcignorelist, [subj '_' trial]];
                disp(['Trial: ' trial ' ---> Invalid non-GC trial, previously ignored']);
            elseif gcflag==0
                bbstruct.(subj).(trial).ignore = 1;
                gcignorelist = [gcignorelist, [subj '_' trial]];
                disp(['Trial: ' trial ' ---> Valid non-GC trial, ignored']);
            elseif gcflag==1
                bbstruct.(subj).(trial).ignore = 0;
                disp(['Trial: ' trial ' *** VALID GC TRIAL!!! ***']); 
            end

        else
            continue;
        end

    end
end                   

% write new error file reporting only gaitcycle files that are already
% ignored
if ~exist(errorpath,'dir'), mkdir(errorpath); end
fid = fopen([errorpath '\metadata_failed_gaitcycle_trials_' datestr(now,'yyyymmdd_HHMMSS') '.txt'],'at');
for e=1:length(gcignorelist)
    fprintf(fid,'%s\n',gcignorelist{e}); 
end
fclose(fid);
fprintf(1,'\n\nERRORS: There are %d files that failed metadata processing.\n\n',length(gcignorelist));

% save the updated meta struct
disp('Saving metadata struct...');
save(fullfile(structpath,'bb.mat'),'-struct','bbstruct');    
    
disp(' ');


end


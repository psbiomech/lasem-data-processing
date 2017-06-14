function [meandata,sddata] = meanBBsubject(subjstruct)

%meanBBsubject Calculates mean of all trials per subject
%   Prasanna Sritharan, June 2017


    % Body Builder data groups
    BBGROUPS = {'ANGLES','MOMENTS','POWERS'};

    % required quantities of interest from Body Builder
    default.ANGLES = {'RAnkleAngles','LTrunkAngles','RTrunkAngles','LTrunkLABAngles','RTrunkLABAngles','LPelvisAngles','RPelvisAngles','RHipAngles','RKneeAngles','LHipAngles','LKneeAngles','LAnkleAngles'};
    default.MOMENTS = {'RKneeMomentPTIB','RAnkleMomentFOOT','RAnkleMomentDTIB','RAnkleMomentROT','RKneeMomentFEM','RKneeMomentROT','RHipMomentFEM','RHipMomentPEL','RHipMomentROT','LAnkleMomentFOOT','LAnkleMomentDTIB','LAnkleMomentROT','LHipMomentFEM','LKneeMomentPTIB','LHipMomentPEL','LHipMomentROT','LKneeMomentFEM','LKneeMomentROT'};
    default.POWERS = {'RAnklePower','RHipPower','RKneePower','LHipPower','LKneePower','LAnklePower'};


    % get list of trials
    trials = fieldnames(subjstruct);
    ntrials = length(trials);

    % collate data
    for b=1:length(BBGROUPS)
        for q=1:length(default.(BBGROUPS{b}))
            quantname = default.(BBGROUPS{b}){q};
            for n = 1:ntrials
                try
                    alldata.(BBGROUPS{b}).(quantname)(:,:,n) = subjstruct.(trials{n}).(BBGROUPS{b}).(quantname);
                catch
                    disp(['ERROR: Unable to process quantity ' quantname ' for trial ' trials{n} '.'])  ;
                end                           
            end
        end
    end

    % calculate mean and sd
    for b=1:length(BBGROUPS)
        for q=1:length(default.(BBGROUPS{b}))
            quantname = default.(BBGROUPS{b}){q};
            meandata.(BBGROUPS{b}).(quantname) = mean(alldata.(BBGROUPS{b}).(quantname),3);
            sddata.(BBGROUPS{b}).(quantname) = std(alldata.(BBGROUPS{b}).(quantname),0,3);
        end
    end    
    
    
end


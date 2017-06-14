function bbmeta = getBBmeta()

%getBBmeta Return a struct containing Body Builder metadata
%   Prasanna Sritharan, June 2017

    bbmeta.BBGROUPS = {'ANGLES','MOMENTS','POWERS'};
    bbmeta.ANGLES = {'RAnkleAngles','LTrunkAngles','RTrunkAngles','LTrunkLABAngles','RTrunkLABAngles','LPelvisAngles','RPelvisAngles','RHipAngles','RKneeAngles','LHipAngles','LKneeAngles','LAnkleAngles'};
    bbmeta.MOMENTS = {'RKneeMomentPTIB','RAnkleMomentFOOT','RAnkleMomentDTIB','RAnkleMomentROT','RKneeMomentFEM','RKneeMomentROT','RHipMomentFEM','RHipMomentPEL','RHipMomentROT','LAnkleMomentFOOT','LAnkleMomentDTIB','LAnkleMomentROT','LHipMomentFEM','LKneeMomentPTIB','LHipMomentPEL','LHipMomentROT','LKneeMomentFEM','LKneeMomentROT'};
    bbmeta.POWERS = {'RAnklePower','RHipPower','RKneePower','LHipPower','LKneePower','LAnklePower'};              
    bbmeta.units.ANGLES = 'deg';
    bbmeta.units.MOMENTS = 'Nm';
    bbmeta.units.POWERS = 'Nms-1';
    bbmeta.dirs = {'X','Y','Z'};

end


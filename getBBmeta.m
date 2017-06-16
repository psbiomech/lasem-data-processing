function bbmeta = getBBmeta()

%getBBmeta Return a struct containing Body Builder metadata
%   Prasanna Sritharan, June 2017

    bbmeta.BBGROUPS = {'ANGLES','MOMENTS','POWERS'};
    bbmeta.ANGLES = {'RAnkleAngles','RKneeAngles','RHipAngles','RPelvisAngles','RTrunkAngles','RTrunkLABAngles', ...
                     'LHipAngles','LKneeAngles','LAnkleAngles','LTrunkAngles','LTrunkLABAngles','LPelvisAngles'};
    bbmeta.MOMENTS = {'RAnkleMomentFOOT','RAnkleMomentDTIB','RAnkleMomentROT','RKneeMomentPTIB','RKneeMomentFEM','RKneeMomentROT','RHipMomentFEM','RHipMomentPEL','RHipMomentROT', ...
                      'LAnkleMomentFOOT','LAnkleMomentDTIB','LAnkleMomentROT','LKneeMomentPTIB','LKneeMomentFEM','LKneeMomentROT','LHipMomentFEM','LHipMomentPEL','LHipMomentROT'};
    bbmeta.POWERS = {'RAnklePower','RHipPower','RKneePower', ...
                     'LHipPower','LKneePower','LAnklePower'};              
    bbmeta.units.ANGLES = 'deg';
    bbmeta.units.MOMENTS = 'Nm';
    bbmeta.units.POWERS = 'Nms-1';
    bbmeta.dirs = {'X','Y','Z'};

end


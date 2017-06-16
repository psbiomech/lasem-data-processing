function bbmeta = getBBmeta()

%getBBmeta Return a struct containing Body Builder metadata
%   Prasanna Sritharan, June 2017

    bbmeta.BBGROUPS = {'ANGLES','MOMENTS','POWERS'};
    bbmeta.ANGLES = {'AnkleAngles','KneeAngles','HipAngles','PelvisAngles','TrunkAngles','TrunkLABAngles'};
    bbmeta.MOMENTS = {'AnkleMomentFOOT','AnkleMomentDTIB','AnkleMomentROT','KneeMomentPTIB','KneeMomentFEM','KneeMomentROT','HipMomentFEM','HipMomentPEL','HipMomentROT'};
    bbmeta.POWERS = {'AnklePower','HipPower','KneePower'};
    bbmeta.units.ANGLES = 'deg';
    bbmeta.units.MOMENTS = 'Nm';
    bbmeta.units.POWERS = 'Nms-1';
    bbmeta.dirs = {'X','Y','Z'};
    bbmeta.limbs = {'R','L','C'};
    bbmeta.cohorts = {'AFF','CON'};
    bbmeta.conditions = {'SYM','ASYM','CON'};
    
end


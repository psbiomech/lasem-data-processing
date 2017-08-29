function bbmeta = getBBmeta()

%getBBmeta Return a struct containing Body Builder metadata
%   Prasanna Sritharan, June 2017

    bbmeta.BBGROUPS = {'ANGLES','MOMENTS','POWERS','GRFS'};
    bbmeta.ANGLES = {'AnkleAngles','KneeAngles','HipAngles','PelvisAngles','TrunkAngles','TrunkLABAngles'};
    bbmeta.MOMENTS = {'AnkleMomentFOOT','AnkleMomentDTIB','AnkleMomentROT','KneeMomentPTIB','KneeMomentFEM','KneeMomentROT','HipMomentFEM','HipMomentPEL','HipMomentROT'};
    bbmeta.POWERS = {'AnklePower','HipPower','KneePower'};
    bbmeta.GRFS = {'GRF'};    
    bbmeta.BBANALYSES = {'RotWork','RotImpulse','GRFImpulse'};
    %bbmeta.BBANALOGS = {'GRF','EMG'};
    %bbmeta.GRF.string = '%s%s%d';
    %bbmeta.GRF.prefix = {'F','M'};
    %bbmeta.GRF.suffix = {'',''};
    bbmeta.fpvectors = {'CofP','Vector'};    
    bbmeta.units.ANGLES = 'deg';
    bbmeta.units.MOMENTS = 'Nm';
    bbmeta.units.POWERS = 'Nms-1';
    bbmeta.units.GRFS = 'N';
    bbmeta.dirs = {'X','Y','Z'};
    bbmeta.limbs = {'R','L'};
    bbmeta.cohorts = {'AFF','CON'};
    bbmeta.conditions = {'SYM','ASYM','CON'};
    
end


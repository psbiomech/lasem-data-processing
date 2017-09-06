function bbmeta = getBBmeta()

%  getBBmeta: Return a struct containing Body Builder metadata
%   Prasanna Sritharan, June 2017
% 
% -------------------------------------------------------------------- 
%     Copyright (C) 2017 Prasanna Sritharan
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
% -------------------------------------------------------------------- 


    bbmeta.BBGROUPS = {'ANGLES','MOMENTS','POWERS','GRFS'};
    bbmeta.ANGLES = {'AnkleAngles','KneeAngles','HipAngles','PelvisAngles','TrunkAngles','TrunkLABAngles'};
    bbmeta.MOMENTS = {'AnkleMomentFOOT','AnkleMomentDTIB','AnkleMomentROT','KneeMomentPTIB','KneeMomentFEM','KneeMomentROT','HipMomentFEM','HipMomentPEL','HipMomentROT'};
    bbmeta.POWERS = {'AnklePower','HipPower','KneePower'};
    bbmeta.GRFS = {'GRF'};
    bbmeta.TIMES = {'absolute','relative'};
    bbmeta.BBANALYSES = {'RotWork','RotImpulse','GRFImpulse','AngleEventVals','MomentEventVals','PowerEventVals','GRFEventVals'};
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


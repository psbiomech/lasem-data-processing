function bbstruct = calcAnalysesMeans(bbstruct,bbmeta,user)

%calcAnalysesMeans: Calculate means for additional analyses on Body Builder data
%   Prasanna Sritharan, April 2018
% 
% -------------------------------------------------------------------- 
%     Copyright (C) 2018 Prasanna Sritharan
%     Copyright (C) 2018 La Trobe University
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


    % add search path for tasks
    addpath('./analyses/'); 
    
    % assign struct fields
    structpath = user.DATASRCPATH;
    
    % joint rotational work (angular work)
    disp(' ');
    disp('Calculating mean rotational work...');
    bbstruct = analysis_mean_work_rotational(bbstruct,bbmeta);     

    
    % joint rotational impulse
    disp(' ');
    disp('Calculating mean joint rotational impulse...');
    bbstruct = analysis_mean_impulse_rotational(bbstruct,bbmeta);                

    
    % GRF impulse
    disp(' ');
    disp('Calculating mean GRF impulse...');
    bbstruct = analysis_mean_impulse_grf(bbstruct,bbmeta);   

    
    % Body Builder data values at events
    disp(' ');
    disp('Calculating mean data values at events...');
    bbstruct = analysis_mean_eventval_angle(bbstruct,bbmeta);
    
    disp(' ');
    disp('Calculating mean moments at events...');
    bbstruct = analysis_mean_eventval_moment(bbstruct,bbmeta);
    
    disp(' ');
    disp('Calculating mean powers at events...');    
    bbstruct = analysis_mean_eventval_power(bbstruct,bbmeta);
    
    disp(' ');
    disp('Calculating mean GRFs at events...');    
    bbstruct = analysis_mean_eventval_grf(bbstruct,bbmeta);

    
    % save struct
    save(fullfile(structpath,'bb.mat'),'-struct','bbstruct');    
    
    disp(' ');
    
end


%% RUN BODY BUILDER DATA EXTRACTION
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


clc; 

disp('C3D BODY BUILDER DATA EXTRACTION');
disp('Prasanna Sritharan, June 2017');
disp(' ');
disp([datestr(now) ': Execution commenced.']);
disp(' ');
disp(' ');
disp('===========================================================');
disp(' ');



%% ********************
% SCRIPT SETTINGS

% get user script settings
disp('Retrieving script settings...');
user = getUserScriptSettings();

% get Body Builder defaults
disp('Retrieving Body Builder C3D metadata...');
bbmeta = getBBmeta(); 



%% ********************
% CREATE DATA STRUCT

disp(' ');

% generate C3D file list
disp('Generating list of available C3D files matching file name format...');
[flist,fnames,subtri] = generateFileList(user);

% add additional information about trial (metadata)
disp('Generating subject and trial metadata and settings...');
bb = getSubjTrialMeta(flist,subtri,bbmeta,user,'ignore');


%% ********************
% EXTRACT & PROCESS BODY BUILDER DATA

disp(' ');

% pull raw Body Builder data into a struct, trim and resample
disp('Extracting Body Builder data from C3D files...');
bb = extractBBdata(bb,bbmeta,user);

% calculate mean and sd for BB data
disp('Calculating means and standard deviations for Body Builder data...');
bb = calcBBmean(bb,bbmeta,user);


%% ********************
% ADDITIONAL ANALYSES

disp(' ');

% run additional analyses on Body Builder data
disp('Running additional analyses on Body Builder data...');
bb = runAnalyses(bb,bbmeta,user);

% calculate mean and sd for additional analyses
disp('Calculating means and standard deviations for additional analyses...');
bb = calcAnalysesMeans(bb,bbmeta);


%% ********************
% SAVE TO FILE

disp(' ');

% export to Excel spreadsheet from Body Builder struct
disp('Exporting Body Builder data to Excel spreadsheet...');
exportBBdata(bb,bbmeta,user);

% save Body Builder struct
disp('Saving complete data set (Body Builder data and additional analyses) as Matlab struct...');
saveBBstruct(bb,user);



%% ********************

disp(' ');
disp([datestr(now) ': Execution complete.']);
disp('-----------------------------------------------------------');
disp(' ');
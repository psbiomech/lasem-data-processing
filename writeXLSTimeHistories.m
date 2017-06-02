function writeXLSTimeHistories(gaitdata,sheetnames,resamp,xlsname,xlspath)


%writeXLSTimeHistories write BodyBuilder data to Excel workbook
%   Prasanna Sritharan, June 2017



% output database path
%xlspath = '.\outputDatabase\';
FULLPATH = 'C:\Users\Prasanna\Documents\Drop_Landings_Project\outputDatabase\';

% foot index
%FOOT = {'r','l'};

% condition
%SHOES = {'Barefoot','Kayano','Zaraca'};

% number of resamples
%resamp = 100;

% gravity
%GRAV = 9.81;

% data for writing
DATAPREFIX = 'zz_DropLanding_';
DATASETS = {'ik','id','so','jr','pf'};
DATANAMES = {'angle','torque','force','force','force'};
DATACOLS = {{2 3 4 8 9 10 11 13 24}, ...
            {2 3 4 8 9 10 11 13 24}, ...
            {[17 18 19],[20 21 22],[36],[44 45 46],[9],[8 38 39],[14 15],[40]}, ...
            {2 3 4 11 12 13 20 21 22}, ...
            {1}};
DATAUNITS = {'deg','Nperkg','BW','BW','BW'};
COLHEADERS = {{'pelvis_tilt','pelvis_list','pelvis_rotation','hip_flexion','hip_adduction','hip_rotation','knee_angle','ankle_angle','lumbar_extension'}, ...
              {'pelvis_tilt','pelvis_list','pelvis_rotation','hip_flexion','hip_adduction','hip_rotation','knee_angle','ankle_angle','lumbar_extension'}, ...
              {'GMAX','GMED','RF','VAS','BFSH','HAMS','GAS','SOL'}, ...
              {'hip_x','hip_y','hip_z','knee_x','knee_y','knee_z','ankle_x','ankle_y','ankle_z'}, ...
              {'net_pf_force'}};
        


%% GET VALUES                         


% parse trials
for d=1:length(DATASETS)
    
    % load data
    osdata = load([xlspath DATAPREFIX DATASETS{d} '.mat']);  
    subjs = fieldnames(osdata.subjects);    
    
    % get data column                
    for c=1:length(DATACOLS{d})                

        % title row
        xldata.(DATASETS{d})(1,:,c) = ['Subject', ...
                                       'Shoe', ...
                                       'Trial', ...
                                       cellfun(@(z)num2str(z,'%i'),num2cell(1:resamp),'UniformOutput',false)];                    

        % get time histories               
        x = 2;
        for s=1:length(subjs)
        
            for b=1:length(SHOES)        
            
                % trial list
                trials = fieldnames(osdata.subjects.(subjs{s}).(SHOES{b}));
            
                for t=1:length(trials)
                                   
                    % sum data groups
                    datarow = sum(osdata.subjects.(subjs{s}).(SHOES{b}).(trials{t}).(DATANAMES{d})(:,DATACOLS{d}{c}),2);
                    
                    % condition data
                    xldata.(DATASETS{d})(x,:,c) = [subjs{s}, ...
                                                   SHOES{b}, ...
                                                   trials{t}, ...
                                                   cellfun(@(z)num2str(z,'%12.8f'),num2cell(datarow),'UniformOutput',false)'];
          
                end
                
                % increment counter
                x = x + 1;
                
            end
            
        end
        
    end
        
end


% write Excel spreadsheet
for d=1:length(DATASETS)

    % write data
    for c=1:length(DATACOLS{d})
        xlswrite([xlspath '\DropLandings_' DATASETS{d} '_all.xlsx'],squeeze(xldata.(DATASETS{d})(:,:,c)),c);
    end
    
    % rename sheets
    xl = actxserver('Excel.Application');
    wb = xl.Workbooks.Open([xlspath '\DropLandings_' DATASETS{d} '_all.xlsx']);
    for c=1:length(DATACOLS{d})
        wb.Worksheets.Item(c).Name = [COLHEADERS{d}{c} '_' DATAUNITS{d}];
    end
    wb.Save;
    wb.Close(false);
    xl.Quit;
    
end



end



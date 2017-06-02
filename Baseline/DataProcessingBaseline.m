
 %FOR RUNNING: CTO and CHS data analysis removed    
%%%%%%%%%%%%
%This Matlab script reads in kinematics and net joint torque data
%(kinetics) from 3 trials for a given subject. The data are averaged and are
%written to an Exel spreadsheet. This script loops for each subject, so multiple 
% subjects may be processed. 
%To run this script, an Excel spreadsheet in the correct format must
%be written - this spreadsheet contains the information pertaining to each
%C3D file, including the C3D file name, path and gait event data
 
 
%David Ackland
%February 2016
 
%AVERAGES 3 TRIALS PER SUBJECT
 
 
 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WRITE PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all 
%Path for Excel input/output file
filepath_xls_input = 'C:\Users\hhart\Desktop\Stairs_CAKP\Stairs_up_settings_shoes.xlsx';
filepath_xls_output = 'C:\Users\hhart\Documents\MATLAB\Data_output_Stairs_up_shoes.xlsx';
 
%initialise c3d server
itf = c3dserver;
 
%set parameters for Excel read
Subject_input_data = {'B3:D9';'F3:H9'; 'J3:L9'; 'N3:P9'; 'R3:T9'; 'V3:X9'; 'Z3:AB9'; 'AD3:AF9'; 'AH3:AJ9'; 'AL3:AN9'; ...
    'AP3:AR9'; 'AT3:AV9'; 'AX3:AZ9'; 'BB3:BD9'; 'BF3:BH9'; 'BJ3:BL9'; 'BN3:BP9'; 'BR3:BT9'; 'BV3:BX9'; 'BZ3:CB9'; ...
    'CD3:CF9'; 'CH3:CJ9'; 'CL3:CN9'; 'CP3:CR9'; 'CT3:CV9'; 'CX3:CZ9'; 'DB3:DD9'; 'DF3:DH9'; 'DJ3:DL9'; ...
    'DN3:DP9'; 'DR3:DT9'; 'DV3:DX9'; 'DZ3:EB9'; 'ED3:EF9'; 'EH3:EJ9'; 'EL3:EN9'; 'EP3:ER9'; 'ET3:EV9'; 'EX3:EZ9'; 'FB3:FD9'; 'FF3:FH9'; 'FJ3:FL9'; ...
    'FN3:FP9'; 'FR3:FT9'; 'FV3:FX9'; 'FZ3:GB9'; 'GD3:GF9'; 'GH3:GJ9'; 'GL3:GN9'; 'GP3:GR9'; 'GT3:GV9'; 'GX3:GZ9'; 'HB3:HD9'; 'HF3:HH9'; ...
    'HJ3:HL9'; 'HN3:HP9'; 'HR3:HT9'; 'HV3:HX9'; 'HZ3:IB9'; 'ID3:IF9'; 'IH3:IJ9'; 'IL3:IN9'; 'IP3:IR9'; 'IT3:IV9'; 'IX3:IZ9'; 'JB3:JD9'; ...
    'JF3:JH9'; 'JJ3:JL9'; 'JN3:JP9'; 'JR3:JT9'; 'JV3:JX9'; 'JZ3:KB9'; 'KD3:KF9'; 'KH3:KJ9'; 'KL3:KN9'; 'KP3:KR9'; 'KT3:KV9'; 'KX3:KZ9'; ...
    'LB3:LD9'; 'LF3:LH9'; 'LJ3:LL9'; 'LN3:LP9'; 'LR3:LT9'; 'LV3:LX9'; 'LZ3:MB9'; 'MD3:MF9'; 'MH3:MJ9'; 'ML3:MN9'; 'MP3:MR9'; 'MT3:MV9'; ...
    'MX3:MZ9'; 'NB3:ND9'; 'NF3:NH9'; 'NJ3:NL9'; 'NN3:NP9'; 'NR3:NT9'; 'NV3:NX9'; 'NZ3:OB9'; 'OD3:OF9'; 'OH3:OJ9'; 'OL3:ON9'; 'OP3:OR9'; ...
    'OT3:OV9'; 'OX3:OZ9'; 'PB3:PD9'; 'PF3:PH9'; 'PJ3:PL9'; 'PN3:PP9'; 'PR3:PT9'; 'PV3:PX9'; 'PZ3:QB9'; 'QD3:QF9'; 'QH3:QJ9'; 'QL3:QN9'; ...
    'QP3:PR9'; 'QT3:QV9'; 'QX3:QZ9'; 'RB3:RD9'; 'RF3:RH9'; 'RJ3:RL9'; 'RN3:RP9'; 'RR3:RT9'};
kinematics_kinetics = {'TrunkAngles'; 'TrunkInclination'; 'TrunkLABAngles'; 'HipAngles'; 'KneeAngles'; 'AnkleAngles'; 'HipMomentPEL'; 'HipMomentROT'; 'HipMomentFEM'; 'KneeMomentFEM'; ...
    'KneeMomentROT'; 'KneeMomentPTIB'; 'AnkleMomentDTIB'; 'AnkleMomentROT'; 'AnkleMomentFoot'; 'GRF_X'; 'GRF_Y'; 'GRF_Z'; 'GaitSpeed';'AngImp_HipFlexion'; ...
    'AngImp_HipAdduction'; 'AngImp_HipInternalRot'; 'AngImp_KneeFlexion'; 'AngImp_KneeAdduction'; 'AngImp_KneeInternalRot'; 'AngImp_AnkleDorsiflexion'; ...
    'AngImp_AnkleInternalRot'; 'AngImp_AnkleInversion'};
Left_right = {'R'; 'L'};    
F_A_R = {'flexion'; 'adduction'; 'internal_rot'};
D_I_I = {'dorsiflexion'; 'internal_rot'; 'inversion'};
cell_chars = {'A';'B'; 'C';'D';'E';'F';'G';'H';'I';'J';'K';'L';'M';'N';'O';'P';'Q';'R';'S';'T';'U';'V';...
'W';'X';'Y';'Z';'AA';'AB';'AC';'AD';'AE';'AF';'AG';'AH';'AI';'AJ' ;'AK';'AL';'AM';'AN';'AO';...
'AP';'AQ';'AR';'AS';'AT';'AU';'AV';'AW';'AX';'AY';'AZ';'BA';'BB';'BC';'BD';'BE';'BF';'BG';'BH';'BI';'BJ';'BK';'BL';'BM';'BN';'BO';...
'BP';'BQ';'BR';'BS';'BT';'BU';'BV';'BW';'BX';'BY';'BZ';'CA';'CB';'CC';'CD';'CE';'CF';'CG';'CH';'CI';'CJ';'CK';'CL';'CM';'CN';'CO';...
'CP';'CQ';'CR';'CS';'CT';'CU';'CV';'CW';'CX';'CY';'CZ';'DA';'DB';'DC';'DD';'DE';'DF';'DG';'DH';'DI';'DJ';'DK';'DL';'DM';'DN';'DO'; ...
'DP';'DQ';'DR';'DS';'DT';'DU';'DV';'DW';'DX';'DY';'DZ';'EA';'EB';'EC';'ED';'EE';'EF';'EG';'EH';'EI';'EJ';'EK';'EL';'EM';'EN';'EO';...
'EP';'EQ';'ER';'ES';'ET';'EU';'EV';'EW';'EX';'EY';'EZ';'FA';'FB';'FC';'FD';'FE';'FF';'FG';'FH';'FI';'FJ';'FK';'FL';'FM';'FN';'FO';...
'FP';'FQ';'FR';'FS';'FT';'FU';'FV';'FW';'FX';'FY';'FZ';'GA';'GB';'GC';'GD';'GE';'GF';'GG';'GH';'GI';'GJ';'GK';'GL';'GM';'GN';'GO';...
'GP';'GQ';'GR';'GS';'GT';'GU';'GV';'GW';'GX';'GY';'GZ';'HA';'HB';'HC';'HD';'HE';'HF';'HG';'HH';'HI';'HJ';'HK';'HL';'HM';'HN';'HO';...
'HP';'HQ';'HR';'HS';'HT';'HU';'HV';'HW';'HX';'HY';'HZ';'IA';'IB';'IC';'ID';'IE';'IF';'IG';'IH';'II';'IJ';'IK';'IL';'IM';'IN';'IO';...
'IP';'IQ';'IR';'IS';'IT';'IU';'IV';'IW';'IX';'IY';'IZ';'JA';'JB';'JC';'JD';'JE';'JF';'JG';'JH';'JI';'JJ';'JK';'JL';'JM';'JN';'JO';...
'JP';'JQ';'JR';'JS';'JT';'JU';'JV';'JW';'JX';'JY';'JZ';'KA';'KB';'KC';'KD';'KE';'KF';'KG';'KH';'KI';'KJ';'KK';'KL';'KM';'KN';'KO';...
'KP';'KQ';'KR';'KS';'KT';'KU';'KV';'KW';'KX';'KY';'KZ';'LA';'LB';'LC';'LD';'LE';'LF';'LG';'LH';'LI';'LJ';'LK';'LL';'LM';'LN';'LO';...
'LP';'LQ';'LR';'LS';'LT';'LU';'LV';'LW';'LX';'LY';'LZ';'MA';'MB';'MC';'MD';'ME';'MF';'MG';'MH';'MI';'MJ';'MK';'ML';'MM';'MN';'MO';...
'MP';'MQ';'MR';'MS';'MT';'MU';'MV';'MW';'MX';'MY';'MZ';'NA';'NB';'NC';'ND';'NE';'NF';'NG';'NH';'NI';'NJ';'NK';'NL';'NM';'NN';'NO';...
'NP';'NQ';'NR';'NS';'NT';'NU';'NV';'NW';'NX';'NY';'NZ';'OA';'OB';'OC';'OD';'OE';'OF';'OG';'OH';'OI';'OJ';'OK';'OL';'OM';'ON';'OO';...
'OP';'OQ';'OR';'OS';'OT';'OU';'OV';'OW';'OX';'OY';'OZ';'PA';'PB';'PC';'PD';'PE';'PF';'PG';'PH';'PI';'PJ';'PK';'PL';'PM';'PN';'PO';...
'PP';'PQ';'PR';'PS';'PT';'PU';'PV';'PW';'PX';'PY';'PZ';'QA';'QB';'QC';'QD';'QE';'QF';'QG';'QH';'QI';'QJ';'QK';'QL';'QM';'QN';'QO';...
'QP';'QQ';'QR';'QS';'QT';'QU';'QV';'QW';'QX';'QY';'QZ';'RA';'RB';'RC';'RD';'RE';'RF';'RG';'RH';'RI';'RJ';'RK';'RL';'RM';'RN';'RO';...
'RP';'RQ';'RR';'RS';'RT';'RU';'RV';'RW';'RX';'RY';'RZ'};
 
force_plate = {'Vector1'; 'Vector2'; 'Vector3'};
CoP = {'CofP1'; 'CofP2'; 'CofP3'}; %centre of pressure 
frame_rate = 120;
%Set data for output Excel file
time = 0:2:100; %This is the percent gait column (from 0 to 100)
 
 
%c = 1      Trunk angles with respect to pelvis. Only use angles 2 and 3 i.e. trunk obliquity ('TrunkAngles_adduction') and axial rotation ('TrunkAngles_internal_rot')
%c = 2      Trunk inclination (only use 1st angles: flexion)
%c = 3      Trunk angles with respect to LAB coordinates (only use angles 2 and 3)
%c = 4      Hip angles
%c = 5      Knee angles
%c = 6      Ankle angles
%c = 7      Hip moment flexion
%c = 8      Hip moment adduction
%c = 9      Hip moment internal rotation 
%c = 10     Knee moment flexion
%c = 11     Knee moment adduction
%c = 12     Knee moment internal rotation
%c = 13     Ankle moment dorsiflexion
%c = 14     Ankle moment internal rotation
%c = 15     Ankle moment inversion
%c = 16     GRF X
%c = 17     GRF Y
%c = 18     GRF Z
%c = 19     SPEED of gait
%c = 20     Angular impulse hip flexion
%c = 21     Angular impulse hip adduction
%c = 22     Angular impulse hip internal rotation
%c = 23     Angular impulse knee flexion
%c = 24     Angular impulse knee adduction
%c = 25     Angular impulse knee internal rotation
%c = 26     Angular impulse ankle dorsiflexion
%c = 27     Angular impulse internal rotation
%c = 28     Angular impulse ankle inversion
 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READ DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
f_plate = [2,2,2]; %specify force plate number for calculation of GRF
 
%Subject number, e.g. for subject 5, a1 = 5
a1 = [50];
 
%Let a = subject number
for a = a1
[N2,T2] = xlsread(filepath_xls_input, Subject_input_data{a});
 
 
    %Let b = trial number
    %n = number of trials, usually n = 3
    for b = 1:3 %don't touch b = trial number (average 3 trials)
        
        frames = N2(:,b);
        L_R = frames(1);
        i_h_s = frames(2);
        c_t_o = frames(3);
        c_h_s = frames(4);
        i_t_o = frames(5);
 
        
        trial_path = T2{1:b};
        C3D_name = T2(2,b);
        complete_path = strcat(trial_path, C3D_name, '.c3d');
        
        %open c3d file
        openc3d(itf,0, char(complete_path));    
        
        %let c = kinematics_kinetics data to extract: max = 4; 1 = trunk angles, 2 = hip angles, 3 = knee angles, 4 = ankle angles
        %max 1:15
        for c = [20:28]
       
            count1= {strcat(('Subject'),':',{' '}, num2str(a)),{'       '} }; 
            count3= {strcat(('Trial'),':',{' '}, num2str(b)), {'    '}}; 
            count4= {strcat(char('Gen_coord'),':',{' '}, num2str(c)),  {'  '}};
            [count1{1} count3{1} count4{1}]
            
            if c<16
                traj_name = strcat(Left_right(L_R), kinematics_kinetics(c));
                kinematics_kinetics_matrix = get3dtarget(itf, traj_name, 0, i_h_s, i_t_o);            
            end
            
            if c<=6 %kinematics_kinetics
                %let d = either flexion(1), adduction(2) or internal rotation(3)
                for d = 1:3
                    kinematics_kinetics_data = kinematics_kinetics_matrix(:,d);
                    %time data from 0 to 100 to match kinematics_kinetics length
                    new_time = 0:(100/(length(kinematics_kinetics_data)-1)):100;
 
                    %interpolate data between 0 and 100%
                    kinematics_kinetics_data_percent{a,b,c,d} = interp1(new_time', kinematics_kinetics_data, time');
 
                    %get gait event times
                    time_i_h_s{a,b,c,d} = i_h_s; %record time at ipsilateral heel strike
                    time_c_t_o{a,b,c,d} = c_t_o; %record time at contralateral toe off
                    time_c_h_s{a,b,c,d} = c_h_s; %record time at contralateral heel strike
                    time_i_t_o{a,b,c,d} = i_t_o; %record time at ipsilateral toe off 
                    
                    %get value at contralateral toe off
                    val_c_t_o = get3dtarget(itf, traj_name, 0, c_t_o, c_t_o+1); %retrieves value at toe off + value after
                    value_c_t_o{a,b,c,d} = val_c_t_o(1,d); %get first value from column d (i.e. discard value after)
 
                    %get value at contralateral heel strike
                    val_c_h_s = get3dtarget(itf, traj_name, 0, c_h_s, c_h_s+1); %retrieves value at toe off + value after
                    value_c_h_s{a,b,c,d} = val_c_h_s(1,d); %get first value from column d (i.e. discard value after)
 
                    %get maximum value and its index (% of gait cycle) 
                    [valmax indmax] = max(kinematics_kinetics_data);
                    val_max{a,b,c,d} = valmax;       
                    time_max{a,b,c,d} = take_first(kinematics_kinetics_data,indmax);
                    
                    %get minimum value and its index (% of gait cycle) 
                    [valmin indmin] = min(kinematics_kinetics_data);
                    val_min{a,b,c,d} = valmin;
                    time_min{a,b,c,d} = take_first(kinematics_kinetics_data, indmin);
                    
                    %get first peak value and time (% of gait cycle) 
                    matlength = length(kinematics_kinetics_data);
                    [valmax1peak indmax1peak] = max(kinematics_kinetics_data(1:floor(matlength/2)));
                    valmax_1peak{a,b,c,d} = valmax1peak;
                    time_valmax_1peak{a,b,c,d} = take_first(kinematics_kinetics_data, indmax1peak);      
                    
                    %get second peak value and time (% of gait cycle) 
                    [valmax2peak indmax2peak] = max(kinematics_kinetics_data(round(matlength/2):matlength));
                    valmax_2peak{a,b,c,d} = valmax2peak;
                    time_valmax_2peak{a,b,c,d} = take_first(kinematics_kinetics_data, indmax2peak+floor(matlength/2));   
                    
                    %get first trough value and time (% of gait cycle) 
                    matlength = length(kinematics_kinetics_data);
                    [valmin1peak indmin1peak] = min(kinematics_kinetics_data(1:floor(matlength/2)));
                    valmin_1peak{a,b,c,d} = valmin1peak;
                    time_valmin_1peak{a,b,c,d} = take_first(kinematics_kinetics_data, indmin1peak);      
                    
                    %get second trough value and time (% of gait cycle) 
                    [valmin2peak indmin2peak] = min(kinematics_kinetics_data(round(matlength/2):matlength));
                    valmin_2peak{a,b,c,d} = valmin2peak;
                    time_valmin_2peak{a,b,c,d} = take_first(kinematics_kinetics_data, indmin2peak+floor(matlength/2));        
                    
                    
                end
            end
                
            if c==7 %HipMomentPEL
                d = 1; %take first angle 
            end
                    
            if c==8
                d = 2; %HipMomentROT 
            end
               
            if c==9
                d = 3; %HipMomentFEM
            end
                
            if c==10
                d = 1; %KneeMomentFEM
            end
 
            if c==11
                d = 2; %KneeMomentROT
            end
 
            if c==12
                d = 3; %KneeMomentPTIB
            end
 
            if c==13
                d = 1; %AnkleMomentDTIB
            end
 
            if c==14
                d = 2; %AnkleMomentROT
            end
 
            if c==15
                d = 3; %AnkleMomentFoot
            end
            
            if c>6 && c<16
                kinematics_kinetics_data = kinematics_kinetics_matrix(:,d);
                new_time = 0:(100/(length(kinematics_kinetics_data)-1)):100;
                kinematics_kinetics_data_percent{a,b,c,d} = interp1(new_time', kinematics_kinetics_data, time');       
                
                time_i_h_s{a,b,c,d} = i_h_s; %record time at ipsilateral heel strike
                time_c_t_o{a,b,c,d} = c_t_o; %record time at contralateral toe off
                time_c_h_s{a,b,c,d} = c_h_s; %record time at contralateral heel strike
                time_i_t_o{a,b,c,d} = i_t_o; %record time at ipsilateral toe offe
                
                %get value at contralateral toe off
                val_c_t_o = get3dtarget(itf, traj_name, 0, c_t_o, c_t_o+1); %retrieves value at toe off + value after
                value_c_t_o{a,b,c,d} = val_c_t_o(1,d); %get first value from column d (i.e. discard value after)
 
                %get value at contralateral heel strike
                val_c_h_s = get3dtarget(itf, traj_name, 0, c_h_s, c_h_s+1); %retrieves value at toe off + value after
                value_c_h_s{a,b,c,d} = val_c_h_s(1,d); %get first value from column d (i.e. discard value after)
 
                %get maximum value and its index (% of gait cycle) 
                [valmax indmax] = max(kinematics_kinetics_data);
                val_max{a,b,c,d} = valmax;       
                time_max{a,b,c,d} = take_first(kinematics_kinetics_data,indmax);
 
                %get minimum value and its index (% of gait cycle) 
                [valmin indmin] = min(kinematics_kinetics_data);
                val_min{a,b,c,d} = valmin;
                time_min{a,b,c,d} = take_first(kinematics_kinetics_data, indmin);
                
                
                %get first peak value and time (% of gait cycle) 
                matlength = length(kinematics_kinetics_data);
                [valmax1peak indmax1peak] = max(kinematics_kinetics_data(1:floor(matlength/2)));
                valmax_1peak{a,b,c,d} = valmax1peak;
                time_valmax_1peak{a,b,c,d} = take_first(kinematics_kinetics_data, indmax1peak);      
 
                %get second peak value and time (% of gait cycle) 
                [valmax2peak indmax2peak] = max(kinematics_kinetics_data(round(matlength/2):matlength));
                valmax_2peak{a,b,c,d} = valmax2peak;
                time_valmax_2peak{a,b,c,d} = take_first(kinematics_kinetics_data, indmax2peak+floor(matlength/2)); 
                
                %get first trough value and time (% of gait cycle) 
                matlength = length(kinematics_kinetics_data);
                [valmin1peak indmin1peak] = min(kinematics_kinetics_data(1:floor(matlength/2)));
                valmin_1peak{a,b,c,d} = valmin1peak;
                time_valmin_1peak{a,b,c,d} = take_first(kinematics_kinetics_data, indmin1peak);      
 
                %get second trough value and time (% of gait cycle) 
                [valmin2peak indmin2peak] = min(kinematics_kinetics_data(round(matlength/2):matlength));
                valmin_2peak{a,b,c,d} = valmin2peak;
                time_valmin_2peak{a,b,c,d} = take_first(kinematics_kinetics_data, indmin2peak+floor(matlength/2));  
                    
            end 
            
            if c>15 && c<19
                d = 1; %use a default value
            end
            
            if c==16 %GRF_X
                traj_name = force_plate(f_plate(b));
                kinematics_kinetics_data = get3dtarget(itf, force_plate(f_plate(b)), 0, i_h_s, i_t_o)- get3dtarget(itf, CoP(f_plate(b)), 0, i_h_s, i_t_o); %find force plate data
                GRF_X = kinematics_kinetics_data(:,1); %GRF = 1st column
                new_time = 0:(100/(length(kinematics_kinetics_data)-1)):100;    %find column length to interpolate about           
                kinematics_kinetics_data_percent{a,b,c,d} = interp1(new_time', GRF_X, time');   %data to write to spreadsheet
                
                time_i_h_s{a,b,c,d} = i_h_s; %record time at ipsilateral heel strike
                time_c_t_o{a,b,c,d} = c_t_o; %record time at contralateral toe off
                time_c_h_s{a,b,c,d} = c_h_s; %record time at contralateral heel strike
                time_i_t_o{a,b,c,d} = i_t_o; %record time at ipsilateral toe offe
                
                %get value at contralateral toe off
                val_c_t_o = get3dtarget(itf, traj_name, 0, c_t_o, c_t_o+1)- get3dtarget(itf, CoP(f_plate(b)), 0, c_t_o, c_t_o+1); %retrieves value at toe off + value after
                value_c_t_o{a,b,c,d} = val_c_t_o(1,1); %get first value from column d (i.e. discard value after)
 
                %get value at contralateral heel strike
                val_c_h_s = get3dtarget(itf, traj_name, 0, c_h_s, c_h_s+1)- get3dtarget(itf, CoP(f_plate(b)), 0, c_h_s, c_h_s+1); %retrieves value at toe off + value after
                value_c_h_s{a,b,c,d} = val_c_h_s(1,1); %get first value from column d (i.e. discard value after)
 
                %get maximum value and its index (% of gait cycle) 
                [valmax indmax] = max(kinematics_kinetics_data(:,1));
                val_max{a,b,c,d} = valmax;       
                time_max{a,b,c,d} = take_first(kinematics_kinetics_data(:,1),indmax);
 
                %get minimum value and its index (% of gait cycle) 
                [valmin indmin] = min(kinematics_kinetics_data(:,1));
                val_min{a,b,c,d} = valmin;
                time_min{a,b,c,d} = take_first(kinematics_kinetics_data(:,1), indmin);  
                
                %get first peak value and time (% of gait cycle) 
                GRFX = kinematics_kinetics_data(:,1);
                matlength = length(GRFX);
                [valmax1peak indmax1peak] = max(GRFX(1:floor(matlength/2)));
                valmax_1peak{a,b,c,d} = valmax1peak;
                time_valmax_1peak{a,b,c,d} = take_first(GRFX, indmax1peak);      
 
                %get second peak value and time (% of gait cycle) 
                [valmax2peak indmax2peak] = max(GRFX(round(matlength/2):matlength));
                valmax_2peak{a,b,c,d} = valmax2peak;
                time_valmax_2peak{a,b,c,d} = take_first(GRFX, indmax2peak+floor(matlength/2)); 
 
                %get first trough value and time (% of gait cycle) 
                [valmin1peak indmin1peak] = min(GRFX(1:floor(matlength/2)));
                valmin_1peak{a,b,c,d} = valmin1peak;
                time_valmin_1peak{a,b,c,d} = take_first(GRFX, indmin1peak);      
 
                %get second peak value and time (% of gait cycle) 
                [valmin2peak indmin2peak] = min(GRFX(round(matlength/2):matlength));
                valmin_2peak{a,b,c,d} = valmin2peak;
                time_valmin_2peak{a,b,c,d} = take_first(GRFX, indmin2peak+floor(matlength/2)); 
                
          
                
            end
            
            
            if c==17 %GRF_Y
                traj_name = force_plate(f_plate(b));
                kinematics_kinetics_data = get3dtarget(itf, force_plate(f_plate(b)), 0, i_h_s, i_t_o)- get3dtarget(itf, CoP(f_plate(b)), 0, i_h_s, i_t_o); %find force plate data
                GRF_Y = kinematics_kinetics_data(:,2); %GRF = 1st column
                new_time = 0:(100/(length(kinematics_kinetics_data)-1)):100;    %find column length to interpolate about           
                kinematics_kinetics_data_percent{a,b,c,d} = interp1(new_time', GRF_Y, time');   %data to write to spreadsheet
                max_GRF_Y = max(GRF_Y);
 
                time_i_h_s{a,b,c,d} = i_h_s; %record time at ipsilateral heel strike
                time_c_t_o{a,b,c,d} = c_t_o; %record time at contralateral toe off
                time_c_h_s{a,b,c,d} = c_h_s; %record time at contralateral heel strike
                time_i_t_o{a,b,c,d} = i_t_o; %record time at ipsilateral toe offe
                
                %get value at contralateral toe off
                val_c_t_o = get3dtarget(itf, traj_name, 0, c_t_o, c_t_o+1)- get3dtarget(itf, CoP(f_plate(b)), 0, c_t_o, c_t_o+1); %retrieves value at toe off + value after
                value_c_t_o{a,b,c,d} = val_c_t_o(1,2); %get first value from column d (i.e. discard value after)
 
                %get value at contralateral heel strike
                val_c_h_s = get3dtarget(itf, traj_name, 0, c_h_s, c_h_s+1)- get3dtarget(itf, CoP(f_plate(b)), 0, c_h_s, c_h_s+1); %retrieves value at toe off + value after
                value_c_h_s{a,b,c,d} = val_c_h_s(1,2); %get first value from column d (i.e. discard value after)
 
                %get maximum value and its index (% of gait cycle) 
                [valmax indmax] = max(kinematics_kinetics_data(:,2));
                val_max{a,b,c,d} = valmax;       
                time_max{a,b,c,d} = take_first(kinematics_kinetics_data(:,2),indmax);
 
                %get minimum value and its index (% of gait cycle) 
                [valmin indmin] = min(kinematics_kinetics_data(:,2));
                val_min{a,b,c,d} = valmin;
                time_min{a,b,c,d} = take_first(kinematics_kinetics_data(:,2), indmin); 
                
                %get first peak value and time (% of gait cycle) 
                GRFY = kinematics_kinetics_data(:,2);
                matlength = length(GRFY);
                [valmax1peak indmax1peak] = max(GRFY(1:floor(matlength/2)));
                valmax_1peak{a,b,c,d} = valmax1peak;
                time_valmax_1peak{a,b,c,d} = take_first(GRFY, indmax1peak);      
 
                %get second peak value and time (% of gait cycle) 
                [valmax2peak indmax2peak] = max(GRFY(round(matlength/2):matlength));
                valmax_2peak{a,b,c,d} = valmax2peak;
                time_valmax_2peak{a,b,c,d} = take_first(GRFY, indmax2peak+floor(matlength/2)); 
  
                %get first trough value and time (% of gait cycle) 
                [valmin1peak indmin1peak] = min(GRFY(1:floor(matlength/2)));
                valmin_1peak{a,b,c,d} = valmin1peak;
                time_valmin_1peak{a,b,c,d} = take_first(GRFY, indmin1peak);      
 
                %get second peak value and time (% of gait cycle) 
                [valmin2peak indmin2peak] = min(GRFY(round(matlength/2):matlength));
                valmin_2peak{a,b,c,d} = valmin2peak;
                time_valmin_2peak{a,b,c,d} = take_first(GRFY, indmin2peak+floor(matlength/2));  
                
                
            end
            
            if c==18 %GRF_Z
                traj_name = force_plate(f_plate(b));
                kinematics_kinetics_data = get3dtarget(itf, force_plate(f_plate(b)), 0, i_h_s, i_t_o); %find force plate data
                GRF_Z = kinematics_kinetics_data(:,3); %GRF = 1st column
                new_time = 0:(100/(length(kinematics_kinetics_data)-1)):100;    %find column length to interpolate about           
                kinematics_kinetics_data_percent{a,b,c,d} = interp1(new_time', GRF_Z, time');   %data to write to spreadsheet
                max_GRF_Z = max(GRF_Z);
 
                time_i_h_s{a,b,c,d} = i_h_s; %record time at ipsilateral heel strike
                time_c_t_o{a,b,c,d} = c_t_o; %record time at contralateral toe off
                time_c_h_s{a,b,c,d} = c_h_s; %record time at contralateral heel strike
                time_i_t_o{a,b,c,d} = i_t_o; %record time at ipsilateral toe offe
                
                %get value at contralateral toe off
                val_c_t_o = get3dtarget(itf, traj_name, 0, c_t_o, c_t_o+1); %retrieves value at toe off + value after
                value_c_t_o{a,b,c,d} = val_c_t_o(1,3); %get first value from column d (i.e. discard value after)
 
                %get value at contralateral heel strike
                val_c_h_s = get3dtarget(itf, traj_name, 0, c_h_s, c_h_s+1); %retrieves value at toe off + value after
                value_c_h_s{a,b,c,d} = val_c_h_s(1,3); %get first value from column d (i.e. discard value after)
 
                %get maximum value and its index (% of gait cycle) 
                [valmax indmax] = max(kinematics_kinetics_data(:,3));
                val_max{a,b,c,d} = valmax;       
                time_max{a,b,c,d} = take_first(kinematics_kinetics_data(:,3),indmax);
 
                %get minimum value and its index (% of gait cycle) 
                [valmin indmin] = min(kinematics_kinetics_data(:,3));
                val_min{a,b,c,d} = valmin;
                time_min{a,b,c,d} = take_first(kinematics_kinetics_data(:,3), indmin); 
                
                
                %get first peak value and time (% of gait cycle) 
                GRFZ = kinematics_kinetics_data(:,3);
                matlength = length(GRFZ);
                [valmax1peak indmax1peak] = max(GRFZ(1:floor(matlength/2)));
                valmax_1peak{a,b,c,d} = valmax1peak;
                time_valmax_1peak{a,b,c,d} = take_first(GRFZ, indmax1peak);      
 
                %get second peak value and time (% of gait cycle) 
                [valmax2peak indmax2peak] = max(GRFZ(round(matlength/2):matlength));
                valmax_2peak{a,b,c,d} = valmax2peak;
                time_valmax_2peak{a,b,c,d} = take_first(GRFZ, indmax2peak+floor(matlength/2)); 
                
                [valmin1peak indmin1peak] = min(GRFZ(1:floor(matlength/2)));
                valmin_1peak{a,b,c,d} = valmin1peak;
                time_valmin_1peak{a,b,c,d} = take_first(GRFZ, indmin1peak);      
 
                %get second peak value and time (% of gait cycle) 
                [valmin2peak indmin2peak] = min(GRFZ(round(matlength/2):matlength));
                valmin_2peak{a,b,c,d} = valmin2peak;
                time_valmin_2peak{a,b,c,d} = take_first(GRFZ, indmin2peak+floor(matlength/2));  
                
            end
 
            if c==19 %calculate gait speed
                d = 1;
                %get value at ipsilateral heel strike
                val_i_h_s = get3dtarget(itf, 'SACR', 0, i_h_s, i_h_s+1); %retrieves value at ipsilateral heel strike
                val_i_t_o = get3dtarget(itf, 'SACR', 0, i_t_o, i_t_o+1); %retrieves value at ipsilateral toe off
                distance = (val_i_t_o(2,2)-val_i_h_s(1,2)); %distance in millimetres
                time2 = (i_t_o - i_h_s)/120;
                speed = abs(distance/time2);
                kinematics_kinetics_data_percent{a,b,c,d} = speed/1000; %display speed in metres per second
            end              
            
            if c>19 && c<29
 
                if c-15==7 %HipMomentPEL
                    d = 1; %take first angle 
                end
 
                if c-15==8
                    d = 2; %HipMomentROT 
                end
 
                if c-15==9
                    d = 3; %HipMomentFEM
                end
 
                if c-15==10
                    d = 1; %KneeMomentFEM
                end
 
                if c-15==11
                    d = 2; %KneeMomentROT
                end
 
                if c-15==12
                    d = 3; %KneeMomentPTIB
                end
 
                if c-15==13
                    d = 1; %AnkleMomentDTIB
                end
 
                if c-15==14
                    d = 2; %AnkleMomentROT
                end
 
                if c-15==15
                    d = 3; %AnkleMomentFoot
                end
 
                
                traj_name = strcat(Left_right(L_R), kinematics_kinetics(c-13));
                kinematics_kinetics_matrix2 = get3dtarget(itf, traj_name, 0, i_h_s, i_t_o);  
                kinematics_kinetics_data = kinematics_kinetics_matrix2(:,d);
                time2 = 0:(1/frame_rate):(length(kinematics_kinetics_data)-1)/120; %length of data
 
                kinematics_kinetics_data_percent{a,b,c,d} = Impulse(time2,kinematics_kinetics_data);
  
                
            end 
 
        end
    end
end
 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%WRITE DATA
%sheet name (generalised coordinate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
for a = a1 %subject  
    for c = [20:28] %kinematics or kinetics coordinate (max 13)
        
        count1= {strcat(('Subject'),':',{' '}, num2str(a)),{'       '} }; 
        count4= {strcat(char('Gen_coord'),':',{' '}, num2str(c)),  {'  '}};
        [count1{1} count4{1}]
                 
        if c==1 || c ==4 || c ==5 || c==6; %c = 1:6 represent kinematics (joint angles)
            for d = 1:3 %submotion
                data_to_write = average_matrix_data(kinematics_kinetics_data_percent,a, c, d); %average 3 trials (between b = 1:3)
                sheet_name = strcat(kinematics_kinetics(c), '_', F_A_R(d));
 
                xlswrite(filepath_xls_output, {'%Stance'}, char(sheet_name), strcat(cell_chars{2},num2str(1))); %time title
                xlswrite(filepath_xls_output, time, char(sheet_name), strcat(cell_chars{3},num2str(1))); %time column
 
                xlswrite(filepath_xls_output, {strcat('Subject', num2str(a))}, char(sheet_name), strcat(cell_chars{2},num2str(a+1))); %data title
                xlswrite(filepath_xls_output, data_to_write', char(sheet_name), strcat(cell_chars{3},num2str(a+1))); %data column 
 
                xlswrite(filepath_xls_output, {'%Time at CTO'}, char(sheet_name), strcat(cell_chars{56},num2str(1))); %data title
                av_time_c_t_o = average_value_data(time_c_t_o, time_i_h_s, time_i_t_o, a, c, d); %find average %time value of contralateral toe off
                xlswrite(filepath_xls_output, av_time_c_t_o, char(sheet_name), strcat(cell_chars{56},num2str(a+1))); %data column 
    
                xlswrite(filepath_xls_output, {'%Time at CHS'}, char(sheet_name), strcat(cell_chars{57},num2str(1))); %data title
                av_time_c_h_s = average_value_data(time_c_h_s, time_i_h_s, time_i_t_o, a, c, d);   
                xlswrite(filepath_xls_output, av_time_c_h_s, char(sheet_name), strcat(cell_chars{57},num2str(a+1))); %data column                   
      
                xlswrite(filepath_xls_output, {'Value at CTO'}, char(sheet_name), strcat(cell_chars{58},num2str(1))); %data title 
                av_value_c_t_o = (1/3)*(value_c_t_o{a,1,c,d}+value_c_t_o{a,2,c,d}+value_c_t_o{a,3,c,d});            
                xlswrite(filepath_xls_output, av_value_c_t_o, char(sheet_name), strcat(cell_chars{58},num2str(a+1))); %data column
 
                xlswrite(filepath_xls_output, {'Value at CHS'}, char(sheet_name), strcat(cell_chars{59},num2str(1))); %data title 
                av_value_c_h_s = (1/3)*(value_c_h_s{a,1,c,d}+value_c_h_s{a,2,c,d}+value_c_h_s{a,3,c,d});            
                xlswrite(filepath_xls_output, av_value_c_h_s, char(sheet_name), strcat(cell_chars{59},num2str(a+1))); %data column
                
                xlswrite(filepath_xls_output, {'Time at max value'}, char(sheet_name), strcat(cell_chars{60},num2str(1))); %data title 
                av_time_max = (1/3)*(time_max{a,1,c,d}+time_max{a,2,c,d}+time_max{a,3,c,d});            
                xlswrite(filepath_xls_output, av_time_max, char(sheet_name), strcat(cell_chars{60},num2str(a+1))); %data column     
              
                xlswrite(filepath_xls_output, {'Max value'}, char(sheet_name), strcat(cell_chars{61},num2str(1))); %data title 
                av_val_max = (1/3)*(val_max{a,1,c,d}+val_max{a,2,c,d}+val_max{a,3,c,d});            
                xlswrite(filepath_xls_output, av_val_max, char(sheet_name), strcat(cell_chars{61},num2str(a+1))); %data column 
                
                xlswrite(filepath_xls_output, {'Time at min value'}, char(sheet_name), strcat(cell_chars{62},num2str(1))); %data title 
                av_time_min = (1/3)*(time_min{a,1,c,d}+time_min{a,2,c,d}+time_min{a,3,c,d});            
                xlswrite(filepath_xls_output, av_time_min, char(sheet_name), strcat(cell_chars{62},num2str(a+1))); %data column     
              
                xlswrite(filepath_xls_output, {'Min value'}, char(sheet_name), strcat(cell_chars{63},num2str(1))); %data title 
                av_val_min = (1/3)*(val_min{a,1,c,d}+val_min{a,2,c,d}+val_min{a,3,c,d});            
                xlswrite(filepath_xls_output, av_val_min, char(sheet_name), strcat(cell_chars{63},num2str(a+1))); %data column      
                
                xlswrite(filepath_xls_output, {'Time at first peak value'}, char(sheet_name), strcat(cell_chars{64},num2str(1))); %data title 
                av_time_max_1p = (1/3)*(time_valmax_1peak{a,1,c,d}+time_valmax_1peak{a,2,c,d}+time_valmax_1peak{a,3,c,d});            
                xlswrite(filepath_xls_output, rounding(av_time_max_1p), char(sheet_name), strcat(cell_chars{64},num2str(a+1))); %data column     
              
                xlswrite(filepath_xls_output, {'First peak value'}, char(sheet_name), strcat(cell_chars{65},num2str(1))); %data title 
                av_val_max_1p = (1/3)*(valmax_1peak{a,1,c,d}+valmax_1peak{a,2,c,d}+valmax_1peak{a,3,c,d});            
                xlswrite(filepath_xls_output, av_val_max_1p, char(sheet_name), strcat(cell_chars{65},num2str(a+1))); %data column   
                
                xlswrite(filepath_xls_output, {'Time at second peak value'}, char(sheet_name), strcat(cell_chars{66},num2str(1))); %data title 
                av_time_max_2p = (1/3)*(time_valmax_2peak{a,1,c,d}+time_valmax_2peak{a,2,c,d}+time_valmax_2peak{a,3,c,d});            
                xlswrite(filepath_xls_output, rounding(av_time_max_2p), char(sheet_name), strcat(cell_chars{66},num2str(a+1))); %data column     
              
                xlswrite(filepath_xls_output, {'Second peak value'}, char(sheet_name), strcat(cell_chars{67},num2str(1))); %data title 
                av_val_max_2p = (1/3)*(valmax_2peak{a,1,c,d}+valmax_2peak{a,2,c,d}+valmax_2peak{a,3,c,d});            
                xlswrite(filepath_xls_output, av_val_max_2p, char(sheet_name), strcat(cell_chars{67},num2str(a+1))); %data column               
                                 
                xlswrite(filepath_xls_output, {'Time at first trough value'}, char(sheet_name), strcat(cell_chars{68},num2str(1))); %data title 
                av_time_min_1p = (1/3)*(time_valmin_1peak{a,1,c,d}+time_valmin_1peak{a,2,c,d}+time_valmin_1peak{a,3,c,d});            
                xlswrite(filepath_xls_output, rounding(av_time_min_1p), char(sheet_name), strcat(cell_chars{68},num2str(a+1))); %data column     
              
                xlswrite(filepath_xls_output, {'First trough value'}, char(sheet_name), strcat(cell_chars{69},num2str(1))); %data title 
                av_val_min_1p = (1/3)*(valmin_1peak{a,1,c,d}+valmin_1peak{a,2,c,d}+valmin_1peak{a,3,c,d});            
                xlswrite(filepath_xls_output, av_val_min_1p, char(sheet_name), strcat(cell_chars{69},num2str(a+1))); %data column   
                
                xlswrite(filepath_xls_output, {'Time at second trough value'}, char(sheet_name), strcat(cell_chars{70},num2str(1))); %data title 
                av_time_min_2p = (1/3)*(time_valmin_2peak{a,1,c,d}+time_valmin_2peak{a,2,c,d}+time_valmin_2peak{a,3,c,d});            
                xlswrite(filepath_xls_output, rounding(av_time_min_2p), char(sheet_name), strcat(cell_chars{70},num2str(a+1))); %data column     
              
                xlswrite(filepath_xls_output, {'Second trough value'}, char(sheet_name), strcat(cell_chars{71},num2str(1))); %data title 
                av_val_min_2p = (1/3)*(valmin_2peak{a,1,c,d}+valmin_2peak{a,2,c,d}+valmin_2peak{a,3,c,d});            
                xlswrite(filepath_xls_output, av_val_min_2p, char(sheet_name), strcat(cell_chars{71},num2str(a+1))); %data column      
            end
        end
        
        
        if c==2 
                d=1; %take first angle (trunk inclination in sagittal plane wrt lab i.e. flexion)
                data_to_write = average_matrix_data(kinematics_kinetics_data_percent,a, c, d); %average 3 trials (between b = 1:3)
                sheet_name = strcat(kinematics_kinetics(c), '_', F_A_R(d));
 
                %xlswrite(filepath_xls_output, {'%Stance'}, char(sheet_name), strcat(cell_chars{2},num2str(1))); %time title
                xlswrite(filepath_xls_output, time, char(sheet_name), strcat(cell_chars{3},num2str(1))); %time column
 
                xlswrite(filepath_xls_output, {strcat('Subject', num2str(a))}, char(sheet_name), strcat(cell_chars{2},num2str(a+1))); %data title
                xlswrite(filepath_xls_output, data_to_write', char(sheet_name), strcat(cell_chars{3},num2str(a+1))); %data column 
 
                %xlswrite(filepath_xls_output, {'%Time at CTO'}, char(sheet_name), strcat(cell_chars{56},num2str(1))); %data title
                av_time_c_t_o = average_value_data(time_c_t_o, time_i_h_s, time_i_t_o, a, c, d); %find average %time value of contralateral toe off
                xlswrite(filepath_xls_output, av_time_c_t_o, char(sheet_name), strcat(cell_chars{56},num2str(a+1))); %data column 
    
                %xlswrite(filepath_xls_output, {'%Time at CHS'}, char(sheet_name), strcat(cell_chars{57},num2str(1))); %data title
                av_time_c_h_s = average_value_data(time_c_h_s, time_i_h_s, time_i_t_o, a, c, d);   
                xlswrite(filepath_xls_output, av_time_c_h_s, char(sheet_name), strcat(cell_chars{57},num2str(a+1))); %data column                   
      
                %xlswrite(filepath_xls_output, {'Value at CTO'}, char(sheet_name), strcat(cell_chars{58},num2str(1))); %data title 
                av_value_c_t_o = (1/3)*(value_c_t_o{a,1,c,d}+value_c_t_o{a,2,c,d}+value_c_t_o{a,3,c,d});            
                xlswrite(filepath_xls_output, av_value_c_t_o, char(sheet_name), strcat(cell_chars{58},num2str(a+1))); %data column
 
                %xlswrite(filepath_xls_output, {'Value at CHS'}, char(sheet_name), strcat(cell_chars{59},num2str(1))); %data title 
                av_value_c_h_s = (1/3)*(value_c_h_s{a,1,c,d}+value_c_h_s{a,2,c,d}+value_c_h_s{a,3,c,d});            
                xlswrite(filepath_xls_output, av_value_c_h_s, char(sheet_name), strcat(cell_chars{59},num2str(a+1))); %data column
                
                %xlswrite(filepath_xls_output, {'Time at max value'}, char(sheet_name), strcat(cell_chars{60},num2str(1))); %data title 
                av_time_max = (1/3)*(time_max{a,1,c,d}+time_max{a,2,c,d}+time_max{a,3,c,d});            
                xlswrite(filepath_xls_output, av_time_max, char(sheet_name), strcat(cell_chars{60},num2str(a+1))); %data column     
              
                %xlswrite(filepath_xls_output, {'Max value'}, char(sheet_name), strcat(cell_chars{61},num2str(1))); %data title 
                av_val_max = (1/3)*(val_max{a,1,c,d}+val_max{a,2,c,d}+val_max{a,3,c,d});            
                xlswrite(filepath_xls_output, av_val_max, char(sheet_name), strcat(cell_chars{61},num2str(a+1))); %data column 
                
                %xlswrite(filepath_xls_output, {'Time at min value'}, char(sheet_name), strcat(cell_chars{62},num2str(1))); %data title 
                av_time_min = (1/3)*(time_min{a,1,c,d}+time_min{a,2,c,d}+time_min{a,3,c,d});            
                xlswrite(filepath_xls_output, av_time_min, char(sheet_name), strcat(cell_chars{62},num2str(a+1))); %data column     
              
                %xlswrite(filepath_xls_output, {'Min value'}, char(sheet_name), strcat(cell_chars{63},num2str(1))); %data title 
                av_val_min = (1/3)*(val_min{a,1,c,d}+val_min{a,2,c,d}+val_min{a,3,c,d});            
                xlswrite(filepath_xls_output, av_val_min, char(sheet_name), strcat(cell_chars{63},num2str(a+1))); %data column      
                
                %xlswrite(filepath_xls_output, {'Time at first peak value'}, char(sheet_name), strcat(cell_chars{64},num2str(1))); %data title 
                av_time_max_1p = (1/3)*(time_valmax_1peak{a,1,c,d}+time_valmax_1peak{a,2,c,d}+time_valmax_1peak{a,3,c,d});            
                xlswrite(filepath_xls_output, rounding(av_time_max_1p), char(sheet_name), strcat(cell_chars{64},num2str(a+1))); %data column     
              
                %xlswrite(filepath_xls_output, {'First peak value'}, char(sheet_name), strcat(cell_chars{65},num2str(1))); %data title 
                av_val_max_1p = (1/3)*(valmax_1peak{a,1,c,d}+valmax_1peak{a,2,c,d}+valmax_1peak{a,3,c,d});            
                xlswrite(filepath_xls_output, av_val_max_1p, char(sheet_name), strcat(cell_chars{65},num2str(a+1))); %data column   
                
                %xlswrite(filepath_xls_output, {'Time at second peak value'}, char(sheet_name), strcat(cell_chars{66},num2str(1))); %data title 
                av_time_max_2p = (1/3)*(time_valmax_2peak{a,1,c,d}+time_valmax_2peak{a,2,c,d}+time_valmax_2peak{a,3,c,d});            
                xlswrite(filepath_xls_output, rounding(av_time_max_2p), char(sheet_name), strcat(cell_chars{66},num2str(a+1))); %data column     
              
                %xlswrite(filepath_xls_output, {'Second peak value'}, char(sheet_name), strcat(cell_chars{67},num2str(1))); %data title 
                av_val_max_2p = (1/3)*(valmax_2peak{a,1,c,d}+valmax_2peak{a,2,c,d}+valmax_2peak{a,3,c,d});            
                xlswrite(filepath_xls_output, av_val_max_2p, char(sheet_name), strcat(cell_chars{67},num2str(a+1))); %data column               
                                 
                %xlswrite(filepath_xls_output, {'Time at first trough value'}, char(sheet_name), strcat(cell_chars{68},num2str(1))); %data title 
                av_time_min_1p = (1/3)*(time_valmin_1peak{a,1,c,d}+time_valmin_1peak{a,2,c,d}+time_valmin_1peak{a,3,c,d});            
                xlswrite(filepath_xls_output, rounding(av_time_min_1p), char(sheet_name), strcat(cell_chars{68},num2str(a+1))); %data column     
              
                %xlswrite(filepath_xls_output, {'First trough value'}, char(sheet_name), strcat(cell_chars{69},num2str(1))); %data title 
                av_val_min_1p = (1/3)*(valmin_1peak{a,1,c,d}+valmin_1peak{a,2,c,d}+valmin_1peak{a,3,c,d});            
                xlswrite(filepath_xls_output, av_val_min_1p, char(sheet_name), strcat(cell_chars{69},num2str(a+1))); %data column   
                
                %xlswrite(filepath_xls_output, {'Time at second trough value'}, char(sheet_name), strcat(cell_chars{70},num2str(1))); %data title 
                av_time_min_2p = (1/3)*(time_valmin_2peak{a,1,c,d}+time_valmin_2peak{a,2,c,d}+time_valmin_2peak{a,3,c,d});            
                xlswrite(filepath_xls_output, rounding(av_time_min_2p), char(sheet_name), strcat(cell_chars{70},num2str(a+1))); %data column     
              
                %xlswrite(filepath_xls_output, {'Second trough value'}, char(sheet_name), strcat(cell_chars{71},num2str(1))); %data title 
                av_val_min_2p = (1/3)*(valmin_2peak{a,1,c,d}+valmin_2peak{a,2,c,d}+valmin_2peak{a,3,c,d});            
                xlswrite(filepath_xls_output, av_val_min_2p, char(sheet_name), strcat(cell_chars{71},num2str(a+1))); %data column            
        end
        
        if c==3
            for d = 2:3 %submotion
                data_to_write = average_matrix_data(kinematics_kinetics_data_percent,a, c, d); %average 3 trials (between b = 1:3)
                sheet_name = strcat(kinematics_kinetics(c), '_', F_A_R(d));
 
                xlswrite(filepath_xls_output, {'%Stance'}, char(sheet_name), strcat(cell_chars{2},num2str(1))); %time title
                xlswrite(filepath_xls_output, time, char(sheet_name), strcat(cell_chars{3},num2str(1))); %time column
 
                xlswrite(filepath_xls_output, {strcat('Subject', num2str(a))}, char(sheet_name), strcat(cell_chars{2},num2str(a+1))); %data title
                xlswrite(filepath_xls_output, data_to_write', char(sheet_name), strcat(cell_chars{3},num2str(a+1))); %data column 
 
                xlswrite(filepath_xls_output, {'%Time at CTO'}, char(sheet_name), strcat(cell_chars{56},num2str(1))); %data title
                av_time_c_t_o = average_value_data(time_c_t_o, time_i_h_s, time_i_t_o, a, c, d); %find average %time value of contralateral toe off
                xlswrite(filepath_xls_output, av_time_c_t_o, char(sheet_name), strcat(cell_chars{56},num2str(a+1))); %data column 
    
                xlswrite(filepath_xls_output, {'%Time at CHS'}, char(sheet_name), strcat(cell_chars{57},num2str(1))); %data title
                av_time_c_h_s = average_value_data(time_c_h_s, time_i_h_s, time_i_t_o, a, c, d);   
                xlswrite(filepath_xls_output, av_time_c_h_s, char(sheet_name), strcat(cell_chars{57},num2str(a+1))); %data column                   
      
                xlswrite(filepath_xls_output, {'Value at CTO'}, char(sheet_name), strcat(cell_chars{58},num2str(1))); %data title 
                av_value_c_t_o = (1/3)*(value_c_t_o{a,1,c,d}+value_c_t_o{a,2,c,d}+value_c_t_o{a,3,c,d});            
                xlswrite(filepath_xls_output, av_value_c_t_o, char(sheet_name), strcat(cell_chars{58},num2str(a+1))); %data column
 
                xlswrite(filepath_xls_output, {'Value at CHS'}, char(sheet_name), strcat(cell_chars{59},num2str(1))); %data title 
                av_value_c_h_s = (1/3)*(value_c_h_s{a,1,c,d}+value_c_h_s{a,2,c,d}+value_c_h_s{a,3,c,d});            
                xlswrite(filepath_xls_output, av_value_c_h_s, char(sheet_name), strcat(cell_chars{59},num2str(a+1))); %data column
                
                xlswrite(filepath_xls_output, {'Time at max value'}, char(sheet_name), strcat(cell_chars{60},num2str(1))); %data title 
                av_time_max = (1/3)*(time_max{a,1,c,d}+time_max{a,2,c,d}+time_max{a,3,c,d});            
                xlswrite(filepath_xls_output, av_time_max, char(sheet_name), strcat(cell_chars{60},num2str(a+1))); %data column     
              
                xlswrite(filepath_xls_output, {'Max value'}, char(sheet_name), strcat(cell_chars{61},num2str(1))); %data title 
                av_val_max = (1/3)*(val_max{a,1,c,d}+val_max{a,2,c,d}+val_max{a,3,c,d});            
                xlswrite(filepath_xls_output, av_val_max, char(sheet_name), strcat(cell_chars{61},num2str(a+1))); %data column 
                
                xlswrite(filepath_xls_output, {'Time at min value'}, char(sheet_name), strcat(cell_chars{62},num2str(1))); %data title 
                av_time_min = (1/3)*(time_min{a,1,c,d}+time_min{a,2,c,d}+time_min{a,3,c,d});            
                xlswrite(filepath_xls_output, av_time_min, char(sheet_name), strcat(cell_chars{62},num2str(a+1))); %data column     
              
                xlswrite(filepath_xls_output, {'Min value'}, char(sheet_name), strcat(cell_chars{63},num2str(1))); %data title 
                av_val_min = (1/3)*(val_min{a,1,c,d}+val_min{a,2,c,d}+val_min{a,3,c,d});            
                xlswrite(filepath_xls_output, av_val_min, char(sheet_name), strcat(cell_chars{63},num2str(a+1))); %data column      
                
                xlswrite(filepath_xls_output, {'Time at first peak value'}, char(sheet_name), strcat(cell_chars{64},num2str(1))); %data title 
                av_time_max_1p = (1/3)*(time_valmax_1peak{a,1,c,d}+time_valmax_1peak{a,2,c,d}+time_valmax_1peak{a,3,c,d});            
                xlswrite(filepath_xls_output, rounding(av_time_max_1p), char(sheet_name), strcat(cell_chars{64},num2str(a+1))); %data column     
              
                xlswrite(filepath_xls_output, {'First peak value'}, char(sheet_name), strcat(cell_chars{65},num2str(1))); %data title 
                av_val_max_1p = (1/3)*(valmax_1peak{a,1,c,d}+valmax_1peak{a,2,c,d}+valmax_1peak{a,3,c,d});            
                xlswrite(filepath_xls_output, av_val_max_1p, char(sheet_name), strcat(cell_chars{65},num2str(a+1))); %data column   
                
                xlswrite(filepath_xls_output, {'Time at second peak value'}, char(sheet_name), strcat(cell_chars{66},num2str(1))); %data title 
                av_time_max_2p = (1/3)*(time_valmax_2peak{a,1,c,d}+time_valmax_2peak{a,2,c,d}+time_valmax_2peak{a,3,c,d});            
                xlswrite(filepath_xls_output, rounding(av_time_max_2p), char(sheet_name), strcat(cell_chars{66},num2str(a+1))); %data column     
              
                xlswrite(filepath_xls_output, {'Second peak value'}, char(sheet_name), strcat(cell_chars{67},num2str(1))); %data title 
                av_val_max_2p = (1/3)*(valmax_2peak{a,1,c,d}+valmax_2peak{a,2,c,d}+valmax_2peak{a,3,c,d});            
                xlswrite(filepath_xls_output, av_val_max_2p, char(sheet_name), strcat(cell_chars{67},num2str(a+1))); %data column               
                                 
                xlswrite(filepath_xls_output, {'Time at first trough value'}, char(sheet_name), strcat(cell_chars{68},num2str(1))); %data title 
                av_time_min_1p = (1/3)*(time_valmin_1peak{a,1,c,d}+time_valmin_1peak{a,2,c,d}+time_valmin_1peak{a,3,c,d});            
                xlswrite(filepath_xls_output, rounding(av_time_min_1p), char(sheet_name), strcat(cell_chars{68},num2str(a+1))); %data column     
              
                xlswrite(filepath_xls_output, {'First trough value'}, char(sheet_name), strcat(cell_chars{69},num2str(1))); %data title 
                av_val_min_1p = (1/3)*(valmin_1peak{a,1,c,d}+valmin_1peak{a,2,c,d}+valmin_1peak{a,3,c,d});            
                xlswrite(filepath_xls_output, av_val_min_1p, char(sheet_name), strcat(cell_chars{69},num2str(a+1))); %data column   
                
                xlswrite(filepath_xls_output, {'Time at second trough value'}, char(sheet_name), strcat(cell_chars{70},num2str(1))); %data title 
                av_time_min_2p = (1/3)*(time_valmin_2peak{a,1,c,d}+time_valmin_2peak{a,2,c,d}+time_valmin_2peak{a,3,c,d});            
                xlswrite(filepath_xls_output, rounding(av_time_min_2p), char(sheet_name), strcat(cell_chars{70},num2str(a+1))); %data column     
              
                xlswrite(filepath_xls_output, {'Second trough value'}, char(sheet_name), strcat(cell_chars{71},num2str(1))); %data title 
                av_val_min_2p = (1/3)*(valmin_2peak{a,1,c,d}+valmin_2peak{a,2,c,d}+valmin_2peak{a,3,c,d});            
                xlswrite(filepath_xls_output, av_val_min_2p, char(sheet_name), strcat(cell_chars{71},num2str(a+1))); %data column      
            end              
        end
        
     
        
        if c==7 %HipMomentPEL
            d=1;
        end
        
        if c==8 %HipMomentROT
            d=2;  
        end
        
        if c==9 %HipMomentFEM
            d=3;
        end
        
        if c==10 %KneeMomentFEM
            d=1;
        end
        
        if c==11 %KneeMomentROT
            d=2;
        end
        
        if c==12 %KneeMomentPTIB
            d=3; 
        end
        
        if c==13 %AnkleMomentDTIB
            d=1;  
        end
        
        if c==14 %AnkleMomentROT
            d=2;  
        end
        
        if c==15 %AnkleMomentFoot
            d=3; 
        end
        
        if c>15 && c<19
             d = 1; %use a default value
        end
        
             
        if c>6 && c<19
            data_to_write = average_matrix_data(kinematics_kinetics_data_percent,a, c, d); %average 3 trials (between b = 1:3)
            
            if c<13
                sheet_name = strcat(kinematics_kinetics(c), '_', F_A_R(d)); %append sheet name to HipMomentPEL_flexion/adduction/internal_rot
            end
            
            if c>12 && c<16 
                sheet_name = strcat(kinematics_kinetics(c), '_', D_I_I(d)); %append sheet name to HipMomentPEL_dorsiflexion/internal_rot/inversion
            end
            
            if c>15 
                sheet_name = kinematics_kinetics(c); %append sheet name to HipMomentPEL_dorsiflexion/internal_rot/inversion
            end
 
           
            
            xlswrite(filepath_xls_output, {'%Stance'}, char(sheet_name), strcat(cell_chars{2},num2str(1))); %time title
            xlswrite(filepath_xls_output, time, char(sheet_name), strcat(cell_chars{3},num2str(1))); %time column
 
            xlswrite(filepath_xls_output, {strcat('Subject', num2str(a))}, char(sheet_name), strcat(cell_chars{2},num2str(a+1))); %data title
            xlswrite(filepath_xls_output, data_to_write', char(sheet_name), strcat(cell_chars{3},num2str(a+1))); %data column 
 
            xlswrite(filepath_xls_output, {'%Time at CTO'}, char(sheet_name), strcat(cell_chars{56},num2str(1))); %data title
            av_time_c_t_o = average_value_data(time_c_t_o, time_i_h_s, time_i_t_o, a, c, d); %find average %time value of contralateral toe off
            xlswrite(filepath_xls_output, av_time_c_t_o, char(sheet_name), strcat(cell_chars{56},num2str(a+1))); %data column 
 
            xlswrite(filepath_xls_output, {'%Time at CHS'}, char(sheet_name), strcat(cell_chars{57},num2str(1))); %data title
            av_time_c_h_s = average_value_data(time_c_h_s, time_i_h_s, time_i_t_o, a, c, d);   
            xlswrite(filepath_xls_output, av_time_c_h_s, char(sheet_name), strcat(cell_chars{57},num2str(a+1))); %data column                   
 
            xlswrite(filepath_xls_output, {'Value at CTO'}, char(sheet_name), strcat(cell_chars{58},num2str(1))); %data title 
            av_value_c_t_o = (1/3)*(value_c_t_o{a,1,c,d}+value_c_t_o{a,2,c,d}+value_c_t_o{a,3,c,d});            
            xlswrite(filepath_xls_output, av_value_c_t_o, char(sheet_name), strcat(cell_chars{58},num2str(a+1))); %data column
 
            xlswrite(filepath_xls_output, {'Value at CHS'}, char(sheet_name), strcat(cell_chars{59},num2str(1))); %data title 
            av_value_c_h_s = (1/3)*(value_c_h_s{a,1,c,d}+value_c_h_s{a,2,c,d}+value_c_h_s{a,3,c,d});            
            xlswrite(filepath_xls_output, av_value_c_h_s, char(sheet_name), strcat(cell_chars{59},num2str(a+1))); %data column
 
            xlswrite(filepath_xls_output, {'Time at max value'}, char(sheet_name), strcat(cell_chars{60},num2str(1))); %data title 
            av_time_max = (1/3)*(time_max{a,1,c,d}+time_max{a,2,c,d}+time_max{a,3,c,d});            
            xlswrite(filepath_xls_output, av_time_max, char(sheet_name), strcat(cell_chars{60},num2str(a+1))); %data column     
 
            xlswrite(filepath_xls_output, {'Max value'}, char(sheet_name), strcat(cell_chars{61},num2str(1))); %data title 
            av_val_max = (1/3)*(val_max{a,1,c,d}+val_max{a,2,c,d}+val_max{a,3,c,d});            
            xlswrite(filepath_xls_output, av_val_max, char(sheet_name), strcat(cell_chars{61},num2str(a+1))); %data column 
 
            xlswrite(filepath_xls_output, {'Time at min value'}, char(sheet_name), strcat(cell_chars{62},num2str(1))); %data title 
            av_time_min = (1/3)*(time_min{a,1,c,d}+time_min{a,2,c,d}+time_min{a,3,c,d});            
            xlswrite(filepath_xls_output, av_time_min, char(sheet_name), strcat(cell_chars{62},num2str(a+1))); %data column     
 
            xlswrite(filepath_xls_output, {'Min value'}, char(sheet_name), strcat(cell_chars{63},num2str(1))); %data title 
            av_val_min = (1/3)*(val_min{a,1,c,d}+val_min{a,2,c,d}+val_min{a,3,c,d});            
            xlswrite(filepath_xls_output, av_val_min, char(sheet_name), strcat(cell_chars{63},num2str(a+1))); %data column  
            
            xlswrite(filepath_xls_output, {'Time at first peak value'}, char(sheet_name), strcat(cell_chars{64},num2str(1))); %data title 
            av_time_max_1p = (1/3)*(time_valmax_1peak{a,1,c,d}+time_valmax_1peak{a,2,c,d}+time_valmax_1peak{a,3,c,d});            
            xlswrite(filepath_xls_output, rounding(av_time_max_1p), char(sheet_name), strcat(cell_chars{64},num2str(a+1))); %data column     
 
            xlswrite(filepath_xls_output, {'First peak value'}, char(sheet_name), strcat(cell_chars{65},num2str(1))); %data title 
            av_val_max_1p = (1/3)*(valmax_1peak{a,1,c,d}+valmax_1peak{a,2,c,d}+valmax_1peak{a,3,c,d});            
            xlswrite(filepath_xls_output, av_val_max_1p, char(sheet_name), strcat(cell_chars{65},num2str(a+1))); %data column   
         
            xlswrite(filepath_xls_output, {'Time at second peak value'}, char(sheet_name), strcat(cell_chars{66},num2str(1))); %data title 
            av_time_max_2p = (1/3)*(time_valmax_2peak{a,1,c,d}+time_valmax_2peak{a,2,c,d}+time_valmax_2peak{a,3,c,d});            
            xlswrite(filepath_xls_output, rounding(av_time_max_2p), char(sheet_name), strcat(cell_chars{66},num2str(a+1))); %data column     
 
            xlswrite(filepath_xls_output, {'Second peak value'}, char(sheet_name), strcat(cell_chars{67},num2str(1))); %data title 
            av_val_max_2p = (1/3)*(valmax_2peak{a,1,c,d}+valmax_2peak{a,2,c,d}+valmax_2peak{a,3,c,d});            
            xlswrite(filepath_xls_output, av_val_max_2p, char(sheet_name), strcat(cell_chars{67},num2str(a+1))); %data column    
            
 
            xlswrite(filepath_xls_output, {'Time at first trough value'}, char(sheet_name), strcat(cell_chars{68},num2str(1))); %data title 
            av_time_min_1p = (1/3)*(time_valmin_1peak{a,1,c,d}+time_valmin_1peak{a,2,c,d}+time_valmin_1peak{a,3,c,d});            
            xlswrite(filepath_xls_output, rounding(av_time_min_1p), char(sheet_name), strcat(cell_chars{68},num2str(a+1))); %data column     
 
            xlswrite(filepath_xls_output, {'First trough value'}, char(sheet_name), strcat(cell_chars{69},num2str(1))); %data title 
            av_val_min_1p = (1/3)*(valmin_1peak{a,1,c,d}+valmin_1peak{a,2,c,d}+valmin_1peak{a,3,c,d});            
            xlswrite(filepath_xls_output, av_val_min_1p, char(sheet_name), strcat(cell_chars{69},num2str(a+1))); %data column   
 
            xlswrite(filepath_xls_output, {'Time at second trough value'}, char(sheet_name), strcat(cell_chars{70},num2str(1))); %data title 
            av_time_min_2p = (1/3)*(time_valmin_2peak{a,1,c,d}+time_valmin_2peak{a,2,c,d}+time_valmin_2peak{a,3,c,d});            
            xlswrite(filepath_xls_output, rounding(av_time_min_2p), char(sheet_name), strcat(cell_chars{70},num2str(a+1))); %data column     
 
            xlswrite(filepath_xls_output, {'Second trough value'}, char(sheet_name), strcat(cell_chars{71},num2str(1))); %data title 
            av_val_min_2p = (1/3)*(valmin_2peak{a,1,c,d}+valmin_2peak{a,2,c,d}+valmin_2peak{a,3,c,d});            
            xlswrite(filepath_xls_output, av_val_min_2p, char(sheet_name), strcat(cell_chars{71},num2str(a+1))); %data column  
 
        end
        
        if c==19
            sheet_name = kinematics_kinetics(c);            
            data_to_write = average_matrix_data(kinematics_kinetics_data_percent,a, c, d); %average 3 trials (between b = 1:3)
            xlswrite(filepath_xls_output, {strcat('Subject', num2str(a))}, char(sheet_name), strcat(cell_chars{2},num2str(a+1))); %data title
            xlswrite(filepath_xls_output, {'Gait_speed (m/s)'}, char(sheet_name), strcat(cell_chars{3},num2str(1))); %data title
            xlswrite(filepath_xls_output, data_to_write, char(sheet_name), strcat(cell_chars{3},num2str(a+1))); %data column   
        end
        
        
        
        if c>19 && c<29
            
           if c-15==7 %HipMomentPEL
                d = 1; %take first angle 
            end
 
            if c-15==8
                d = 2; %HipMomentROT 
            end
 
            if c-15==9
                d = 3; %HipMomentFEM
            end
 
            if c-15==10
                d = 1; %KneeMomentFEM
            end
 
            if c-15==11
                d = 2; %KneeMomentROT
            end
 
            if c-15==12
                d = 3; %KneeMomentPTIB
            end
 
            if c-15==13
                d = 1; %AnkleMomentDTIB
            end
 
            if c-15==14
                d = 2; %AnkleMomentROT
            end
 
            if c-15==15
                d = 3; %AnkleMomentFoot
            end
            
            sheet_name = kinematics_kinetics(c);
            data_to_write = average_matrix_data_LC(kinematics_kinetics_data_percent,a, c, d); %average 3 trials (between b = 1:3)
            xlswrite(filepath_xls_output, {strcat('Subject', num2str(a))}, char(sheet_name), strcat(cell_chars{2},num2str(a+1))); %data title
            xlswrite(filepath_xls_output, {'Angular Impulse (Nm.s)'},char(sheet_name), strcat(cell_chars{3},num2str(1))); %data title
            xlswrite(filepath_xls_output, data_to_write, char(sheet_name), strcat(cell_chars{3},num2str(a+1))); %data column      
        end   
        
        
        
        
        
        
    end
end
char({'job complete!'})
 
    
 
 
 
 
 
 
%%
 



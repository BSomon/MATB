
function [MATB_DATA]=Init_LSL(MATB_DATA)
global fileID outlet outlet3% SUPPRIMER OUTLET ?

if MATB_DATA.LSL_Streaming
    try
        disp('Loading library...');
        lib = lsl_loadlib();
        
        %%---------- MATB
        disp('Creating MATB stream info...');
        info = lsl_streaminfo(lib,'MATB','Markers',3,0,'cf_string','myID_MATB');
        outlet = lsl_outlet(info);
        MATB_DATA.LSLoutlet=outlet;
        
        % fprintf(fileID,'%.4f \t\t %.4f \t\t\t %s \n',char(datetime('now','Format','HH:mm:ss')),0,'LAB STREAMING LAYER INIT');
        fprintf(fileID,'%s\t\t %.4f \t\t\t %s \n',char(datetime('now','Format','HH:mm:ss')),0,'LAB STREAMING LAYER INIT');
        outlet.push_sample({0,'LSL Init',''});
        
        %%---------- EYE TRACKING
%         disp('Creating EyeTracking stream info...');
%         info = lsl_streaminfo(lib,'GazePoint','EyeTrack',24,60,'cf_float32','sdfwerr32432');
%         outlet2 = lsl_outlet(info);
%         MATB_DATA.EyeTrack.outlet=outlet2;
        
        %%---------- COMM ---- rajout� pour r�cup�rer les donn�es de la COMM
        disp('Creating communication stream info...');
        info = lsl_streaminfo(lib,'COMM','perf',1,0,'cf_double64','COMMdata');
        outlet3 = lsl_outlet(info);
        MATB_DATA.COMM.outlet=outlet3;
        
        disp('Now transmitting data...');
    catch
        warning('Make sure that LSL library has been added to the path')
    end
end
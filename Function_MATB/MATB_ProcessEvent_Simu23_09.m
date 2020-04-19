
% function  [faulty_al,faulty_pmp,pmp,LastUpdate_EVENT]=MATB_ProcessEvent(faulty_al,faulty_pmp,pmp,pahandle,lE,IdxCOMM,ListFichierAudio)
function [MATB_DATA]=MATB_ProcessEvent_Simu23_09(MATB_DATA,lE) % ----on a rajout� Bool perf en argument

if any(lE(15:18)~=0) % Si jamais y'a de la COMM a envoyer
    ttt=lE(15:18);
    TypeOwnOth=ttt(find(ttt));
    TypeCOMM=find(ttt);
    IdFichier=find(MATB_DATA.COMM.IdxCOMM(:,1)==TypeOwnOth & MATB_DATA.COMM.IdxCOMM(:,2)==TypeCOMM);
    
    % VERSIO LOADING RESAMPLING a la vol�e mamene : Trop long
    %     FichierAudio=MATB_DATA.COMM.ListFichierAudio{IdFichier(randi(8,1))};
    %     [y,Fs] = audioread(['Audio/' FichierAudio]);
    %     y2=resample(y,44100,Fs);
    %     PsychPortAudio('FillBuffer', MATB_DATA.handlePortAudio, [y2' ; y2']);
    %     PsychPortAudio('Start', MATB_DATA.handlePortAudio,1,0,1);
    
    NumRandFichier=randi(8,1);
  
    PsychPortAudio('FillBuffer', MATB_DATA.handlePortAudio,...
        [MATB_DATA.COMM.ListFichierAudio{IdFichier(NumRandFichier)}' ; MATB_DATA.COMM.ListFichierAudio{IdFichier(NumRandFichier)}']);
    PsychPortAudio('Start', MATB_DATA.handlePortAudio,1,0,1);
%     T_comm = GetSecs;
    
    Fich=MATB_DATA.COMM.NomFichierAudio{IdFichier(NumRandFichier)};
%     send_log('COMM PLAY',Fich);
    send_log('COMM PLAY',Fich,1); % ----------------- 3e argument �gal � 1 car on a rajout� un argument � la fonction send log pour lui introduire  Bool_com + bool_perf
    MATB_DATA.COMM.DATA{MATB_DATA.ScenarioNumber}=cat(1,MATB_DATA.COMM.DATA{MATB_DATA.ScenarioNumber},cat(2,TypeOwnOth,TypeCOMM,str2num(Fich(end-10:end-8)),str2num(Fich(end-6:end-4)),0));
end

MATB_DATA.LastUpdate.EVENT=GetSecs;
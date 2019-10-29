% Performance Calculation
function [FigPerf]=Performance
global MATB_DATA
% close all
% MATB_DATA.ScenarioNumber=7;
FigPerf=figure('position',[ 449  55  1056  948],'menubar','none','numbertitle','off','name','Performance','windowstyle','Modal');
%% SYSMON
if ~isempty(MATB_DATA.SYSMON.DATA{MATB_DATA.ScenarioNumber})
    PS=MATB_DATA.SYSMON.DATA{MATB_DATA.ScenarioNumber}(:,2);
else
    PS=10;
end
% subplot(221);
% [left bottom width height].
Posi=[ .1 .6 .3 .3 
       .5 .55 .4 .35
       .5 .05 .4 .4
       .1 .1 .3 .3 ];
subplot('Position',Posi(1,:))
PerfSys
%% TRACK
PT=sqrt(MATB_DATA.TRACK.DATA{MATB_DATA.ScenarioNumber}(:,1).^2 + MATB_DATA.TRACK.DATA{MATB_DATA.ScenarioNumber}(:,2).^2);  % /(sqrt(2)*10);

x=MATB_DATA.TRACK.DATA{MATB_DATA.ScenarioNumber};
y=x < 2 & x > -2;
TempsPasseNoir=size(find(y(:,1)&y(:,2)),1)/length(y)*100;
TempsPasseNoir=round(TempsPasseNoir,2);

y= x > 4 | x < -4;
TempsPasseRouge=size(find(y(:,1) | y(:,2)),1)/length(y)*100;
TempsPasseRouge=round(TempsPasseRouge,2);

TempsPasseOrange=100-TempsPasseRouge-TempsPasseNoir;

% subplot(222)
subplot('Position',Posi(2,:))
PerfTrack

%% RESMAN
PR=abs(2500-MATB_DATA.RESMAN.DATA{MATB_DATA.ScenarioNumber});
% subplot(223)
subplot('Position',Posi(3,:))
PerfRes


%% COMM
Data=MATB_DATA.COMM.DATA{MATB_DATA.ScenarioNumber};
if ~isempty(Data)
    Request=find(Data(:,1)==1); % On cherche les request comm
    PC=0;
    
    for i=1:length(Request)
        if Request(i)+1 <= size(Data,1)  % Si il a des events apr�s la derni�re requete
            if i == length(Request)
                b=find(Data(Request(i)+1:end,1)==3); % Si c'est la derni�re requete on prend toutes les entr�es suivantes
            else
                b=find(Data(Request(i)+1:Request(i+1),1)==3); % On cherche les entr�e avant la prochaine requete
            end
            
            if ~isempty(b) % Si il y une r�ponse
                Ask=Data(Request(i),:);
                Rep=Data(Request(i)+b,2:end);
                
                if Ask(3)+0.001*Ask(4)==Rep(Ask(2))
                    PC=PC+1;
                    %                         disp([' Request ' num2str(i) ' OK'])
                else
                    %                         disp([' Request ' num2str(i) ' FAUX'])
                end
            else
                %                     disp([' Request ' num2str(i) ' No Response'])
            end
        end
    end
    
    
else
    Request=0;
    PC=0;
end
% subplot(224)
subplot('Position',Posi(4,:))
PerfComm
%% Pour PAUSE CLAVIER
drawnow

pause(1)
yesKeys = KbName('Return');

while true
    [~,~,keyCode] = KbCheck;
    if any(keyCode(yesKeys))
        break
    end
end

close(FigPerf)

% close(PRfig)
% close(PTfig)
% close(PCfig)


%% OTHER TEST
% %% Perf TRACK
% % Distance / Distance Max (bord)
% PT=1-mean(sqrt(MATB_DATA.TRACK.DATA{1}(:,1).^2 + MATB_DATA.TRACK.DATA{1}(:,2).^2))/(sqrt(2)*10);
% disp(['TRACK NOTE : ' num2str(round(PT*20,1)) ' / 20'])
%
%
% %% Perf RESMAN (Difference � 2500) / 2500
% PRes=1-mean(abs(2500-MATB_DATA.RESMAN.DATA{1}))/2500;
% Presm=mean(PRes);
% disp(['RESMAN NOTE : ' num2str(round(Presm*20,1)) ' / 20'])
%
% %% Perf SYSMON
% a= MATB_DATA.SYSMON.DATA{1};
% disp(['SYSMON RT m= ' num2str(mean(a(:,2))) ' sec ; std= '  num2str(std(a(:,2)))])
%
% b= -0.25*a(:,2)+1.25;
% Note=max(cat(2,b,zeros(length(b),1)),[],2);
% Note=min(cat(2,Note,ones(length(b),1)),[],2);
%
% disp(['SYSMON NOTE : ' num2str(round(mean(Note)*20,1)) ' / 20'])
%
% %%
% Data=MATB_DATA.COMM.DATA{1};
%
% Request=find(Data==1);
%
% b=find(Data(Request(i):end,1)==3);
% Point=0;
% for i=1:length(Request)
%     if ~isempty(b) && b-Request(i)==1
%         if Data(Request(i),3)+0.001*Data(Request(i),4)==Data(b,Data(Request(1),2))
%             Point=Point+1;
%         end
%     end
% end






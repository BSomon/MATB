function Data_COMM = send_log(Indic,Valeur,Bool_comm)
% function send_log(Indic,Valeur)
global   MATB_DATA n_dim_old outlet fileID Start outlet3

%-----initialisation des variables qui vont servir � calculer les perf de COMM-------
Data_COMM = MATB_DATA.COMM.DATA{MATB_DATA.ScenarioNumber};
disp(Data_COMM)
Perf_Comm = [];
%------------------------------------------------------------------------------------

% str=[num2str(GetSecs) '\t\t' num2str(GetSecs-Start)  '\t\t\t'  Indic  '\t ' Valeur '\n' ];
% fprintf(fileID,str); outlet.push_sample({num2str(GetSecs-Start),Indic,Valeur});
% fprintf(fileID,'%.4f \t\t %.4f \t\t\t %s \t\t %s \n',GetSecs,GetSecs-Start,Indic,Valeur);
% %
fprintf(fileID,'%s\t\t %.4f \t\t\t %s \t\t %s \n',char(datetime('now','Format','HH:mm:ss')),GetSecs-Start,Indic,Valeur);

if MATB_DATA.LSL_Streaming
    outlet.push_sample({num2str(GetSecs-Start),Indic,Valeur});
    %
    %--------------partie d�di�e au calcul de perf de la COMM------------------
    % if isempty(Data_COMM) || size(Data_COMM,1)==1
    %     n_dim_old = 1;
    % elseif size(Data_COMM,1) > n_dim_old
    % %
    
    if ~any(Bool_comm < 1) % --------- si bool_comm est un vecteur contenant uniquement des 1 (i.e., COCPIT continue de dire � MATB de s'ex�cuter)
        
        if ~isempty(Data_COMM)
            
            if size(Data_COMM,1) == 1
                n_dim_old = 1;
                %     else
                %         n_dim_old = size(Data_COMM,1)-1;
            end
            
            
            if size(Data_COMM,1) > n_dim_old
                
                if Data_COMM(end,1) == 1 && Data_COMM(end-1,1) == 1 %%%%%%%%%%%%%%%%%% rajouter cette condition pour le dernier NASA 504 && GetSecs - T_comm == 15
                    Perf_Comm = -2; % Ici -2 signifie que le participant a fait un Miss car aucune rep n'a �t� donn�e (pas de 3) et la comm pr�c�dente nous �tait d�di�e (1)
                    disp('Miss type1');
                    
                elseif Data_COMM(end,1) == -1 &&  Data_COMM(end-1,1) == 1
                    Perf_Comm = -2; % Ici -2 signifie que le participant a fait un Miss car aucune rep n'a �t� donn�e (pas de 3), la comm pr�c�dente nous �tait d�di�e (1) mais la suivante ne l'�tait pas
                    disp('Miss type2');
                    
                elseif Data_COMM(end,1) == 3 && Data_COMM(end-1,1) == -1
                    Perf_Comm = -1; % Ici -1 signifie que le participant a fait une fausse d�tection car une r�ponse a �t� donn�e et la comm pr�c�dente ne nous �tait pas d�di�e (-1)
                    disp('Fausse detection');
                    
                elseif Data_COMM(end,1) == 3 && Data_COMM(end-1,1) == 1 && ~isequal(Data_COMM(end,Data_COMM(end-1,2)+1), Data_COMM(end-1,3) + Data_COMM(end-1,4)*0.001)
                    %           elseif Data_COMM(end,1) == 3 && Data_COMM(end-1,1) == 1 && Data_COMM(end,Data_COMM(end-1,2)+1) ~=  Data_COMM(end-1,3) + Data_COMM(end-1,4)*0.001
                    Perf_Comm = 0; % Ici 0 sigifie que le participant a bien rep � la comm car une r�ponse � �t� donn�e (3) suite � une comm qui nous �tait d�di�e (1) et la valeur renseign�e n'�tait pas la bonne
                    disp('Mauvaise Comm');
                    
                elseif Data_COMM(end,1) == 3 && Data_COMM(end-1,1) == 1 && isequal(Data_COMM(end,Data_COMM(end-1,2)+1), Data_COMM(end-1,3) + Data_COMM(end-1,4)*0.001)
                    %           elseif Data_COMM(end,1) == 3 && Data_COMM(end-1,1) == 1 && Data_COMM(end,Data_COMM(end-1,2)+1) ==  Data_COMM(end-1,3) + Data_COMM(end-1,4)*0.001
                    Perf_Comm = 1; % Ici 1 sigifie que le participant a bien rep � la comm car une r�ponse � �t� donn�e (3) suite � une comm qui nous �tait d�di�e (1) et la valeur renseign�e �tait la bonne
                    disp('OK maggle');
                    
                elseif Data_COMM(end,1) == 3 && Data_COMM(end-1,1) == 3 % Si jamais 2 apply sont envoy�s successivement
                    
                    if Data_COMM(end-2,1) == 1 && isequal(Data_COMM(end,Data_COMM(end-2,2)+1), Data_COMM(end-2,3) + Data_COMM(end-2,4)*0.001)
                        %           if Data_COMM(end-2,1) == 1 && Data_COMM(end,Data_COMM(end-2,2)+1) ==  Data_COMM(end-2,3) + Data_COMM(end-2,4)*0.001
                        Perf_Comm = 1; % On met perf_comm a 1 apr�s si l'un des deux apply �tait bon par rapport � la COMM demand�e. Cela permet d'offrir au participant de se tromper 1x
                        disp('OK maggle');
                    end
                    
                    %         else
                    %             Perf_Comm = 3;
                    %             disp('RAS');
                    
                end
                %       disp (['performance de comm:',Perf_Comm])
                %      disp (['performance de comm:' num2str(Perf_Comm)])
                n_dim_old = size(Data_COMM,1);
                
                %         outlet = MATB_DATA.COMM.outlet3;
                %             outlet3.push_sample(double(Perf_Comm)); % tester avec des double au cas ou
                outlet3.push_chunk(double(Perf_Comm)); % tester avec des double au cas ou
                
            end
        end
        
    elseif any(Bool_comm < 1) %---------- s'il y en a un strictement inf�rieur � 1 (c'est ce que l'on recherche puisqu'on veut d�tecter d�s qu'il y a un 0)
        
        if ~isequal(Data_COMM(end,:), [0 0 0 0 0])
            Data_COMM1 = zeros(size(Data_COMM,1)+1,5);
            Data_COMM1(1:end-1,:) = Data_COMM;
            Data_COMM = Data_COMM1;
        end
        
        n_dim_old = size(Data_COMM,1);
        
        %         outlet = MATB_DATA.COMM.outlet3;
%         outlet3.push_sample(double(Perf_Comm)); % tester avec des double au cas ou
        outlet3.push_chunk(double(Perf_Comm)); % tester avec des double au cas ou
        %
        
    end
    
%     if Bool_perf == 1 % -------- bool_perf devient 1 quand l'interruption de la tache de oddball sur cocpit prend fin, ce qui permet de r�initialiser la matrice de COMM en int�grant une ligne de -200
% 
%        
%       if ~isequal(Data_COMM(end,:), [-200 -200 -200 -200 -200])
%         Data_COMM1 = zeros(size(Data_COMM,1)+1,5);
%         Data_COMM1(1:end-1,:) = Data_COMM;
%         Data_COMM1(end,:) = ones(1,5)*-200;
%         Data_COMM = Data_COMM1;
%         
%         n_dim_old = size(Data_COMM,1);
%         
%         disp('blabalbalaabalaal')
%       end
%     end
    
end
end
%




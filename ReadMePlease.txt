15/02/18 Creation du Script

02/03/18 Copie de Linux vers PC. Tout fonctionne, besoin d'ajouter un Tutoriel interactif
05/03/18 Ajout des << Jaune sur le SYSMON + le catch du Joystick
14/03/18 Nouvelle difficulte, reparation des COMM, flux differents selon difficulte
15/03/18 Nouveau Generateur d'evenements etc.

13/05/18 Multiple clavier avec KbQueueCheck revoir dans l'Updtae Keyboard et l'INIT MATB
00/06/18 Une fenetre pour feedback
00/06/18 Chargement des sons � l'avance
00/06/18 Message HIT ENTER a chaque fois

TO DO/CHECK : Pas de comm � T0, pas laisser descendre les value des comm trop bas pour le log

%% REPLIQUE DE LA NASA MATB
On est sur code tr�s tr�s sale pour l'instant, 
95% des variables ont des noms illisibles 
Certains script sont cod� directement avec le cul
Certaines choses fonctionne sans vraiment que je sache pourquoi :)

Apr�s �a marche ! et bien :) Ca affiche quasi en temps r�el, ca stream,  
et �a tol�re en plus quelque oublie de toolbox, de branchements de joystick
Apr�s ca peut crasher si on fait pas exactement ce que je faisais :)

Le fichier pricipale c'est le script MATB, juste � faire PLAY :)
Les param�tres � config sont directement dans le script
Nombre de sc�nario, duree etc...
Tout est modifiable (avec plus ou moins de difficult�s)
Le script �tait pr�vu pour 2 joueurs donc �a impliquait 2 claviers
2 eye tracker et le stream en double etc... 
et du coup la difficult� est assez �lev� tel quel pour 1 seul joueur. 

Dans le dossier AUDIO y'a juste les fichiers audio de la MATB original que je reutilise
Dans le dossier DATA les data seront sauvegard�s (en .mat)
Dans le dossier LOG, le log en txt (ce qui y'a de plus robuste comme infos) 
et le diary (le journal de console matlab) seront stock�es avec la date et l'here en titre

-- Si besoin : 
J'ai des scripts de visualisation en live de Double biosemi, des offsets et des spectre
des ECG et des eyetracker si besoin 
Je faisais �a via un pc sur le r�seau via le LSL. Parceque quand un biosmi stream via l'app LSL
Actiview ne peut pas �tre en route en meme temps et du coup on voit pas les signaux

J'ai des script qui relise les log.txt et qui regenere des .mat pour quand �a a crash�.
J'ai des script qui font des rapport pdf sur le comportement et l'eyetrack, 
exemple dans le dossier log si �a peut vous interess�

J'ai essay� de commenter, j'ai essay� d'expliquer la ou je me suis dit que vous voudriez modifier. 
J'ai tout cod� � la main de A � Z donc si vous avez des questions n'h�sitez pas
Je suis content que ce code servent � quelqu'un :)

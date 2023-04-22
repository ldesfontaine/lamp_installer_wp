# Installation de LAMP et Wordpress
Ce script bash vous permet d'installer facilement un environnement LAMP (Linux, Apache, MySQL et PHP) ainsi que Wordpress sur votre serveur. Il vous permet également de mettre à jour et de supprimer cet environnement.

## Utilisation
Téléchargez le script sur votre serveur en utilisant la commande git clone https://github.com/ldesfontaine/lamp_installer_wp.git

Rendez-vous dans le répertoire où se trouve le script en utilisant la commande cd lamp_installer_wp . 
Pour lancer le script faire : " sudo bash setup_lamp_wp.sh "
Suivez les instructions à l'écran pour installer LAMP et Wordpress, mettre à jour ou supprimer l'environnement.

`Pour plus d'informations sur l'utilisation du script regarder cette documentation :`

https://github.com/ldesfontaine/Documentation/blob/be048a4eb66fa67a3addb9686c070ff967063425/Lamp_installer.md


## Options
Installation LAMP : Cette option vous permet d'installer un environnement LAMP sur votre serveur. Il vous demandera votre nom, le nom de domaine et votre adresse e-mail pour configurer Apache.

Installation LAMP & Wordpress : Cette option vous permet d'installer un environnement LAMP ainsi que Wordpress sur votre serveur. Il vous demandera également les informations nécessaires pour configurer Wordpress.

Mise à jour & Upgrade de votre LAMP : Cette option vous permet de mettre à jour les paquets de votre environnement LAMP.

Désinstallation de votre LAMP : Cette option vous permet de supprimer complètement votre environnement LAMP de votre serveur.

Quitter : Cette option vous permet de quitter le script.

## Note
Il est important de noter que ce script a été testé et fonctionne correctement avec debian 11. Il peut ne pas fonctionner correctement sur d'autres distributions Linux.

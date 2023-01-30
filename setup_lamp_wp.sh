#!/bin/bash

while true; do
  echo "1) Installation LAMP"
  echo "2) Installation LAMP & Wordpress"
  echo "2) Update & Upgrade de votre LAMP"
  echo "4) Désinstallation de votre LAMP"
  echo "3) Quitter"
  read -p "Choisissez une option : " choice
  case $choice in







    1)  echo "Installation LAMP en cours..."
        # -------- Installation du LAMP --------





        # Demande les informations nécessaires à l'utilisateur A REFAIRE VERIFIER DE BASE SI CA EXISTE SINON ON DEMANDE
        read -p "Entrez votre nom (ex : Aterrieur ): " name
        read -p "Entrez le nom de domaine (ex : btsinfo.nc): " Alias
        read -p "Entrez votre Adresse Mail: " email

       #Create full path for var/www & $name
        directory="/var/www/$name"
        domain="$name.$Alias"

        #Affiche les informations saisies
        echo ""
        echo "Vous avez saisi : { $name } comme nom"
        echo "Vous avez saisi : { $domain } comme nom de domaine / url"
        echo "Vous avez saisi : { $email } comme adresse mail"
        echo "Vous avez saisi : { $Alias } comme alias / nom de domaine"
        echo "Vous avez saisi : { $directory } comme répertoire"
        echo ""


# ----------------- Vérification de l'installation des paquets -----------------

        # Vérification de l'installation de Apache
        if ! [ -x "$(command -v apache2)" ]; then
            echo "Apache2 n'est pas installé. Installations en cours..."
            sudo apt-get install apache2 -y
        else
            echo "Apache2 est déjà installé."
        fi

        # Vérification de l'installation de MySQL
        if ! [ -x "$(command -v mysql)" ]; then
            echo "MySQL n'est pas installé. Installations en cours..."
            sudo apt-get install mysql-server -y
        else
            echo "MySQL est déjà installé."
        fi

        # Vérification de l'installation de PHP
        if ! [ -x "$(command -v php)" ]; then
            echo "PHP n'est pas installé. Installations en cours..."
            sudo apt-get install php libapache2-mod-php -y
            sudo apt-get install php-mysql -y
        else
            echo "PHP est déjà installé."
            sudo apt-get install php-mysql -y
        fi


        # -------- Crée le fichier de configuration Apache --------
        sudo touch /etc/apache2/sites-available/$domain.conf
        sudo chmod 755 /etc/apache2/sites-available/$domain.conf
        echo "<VirtualHost *:80>
             ServerAdmin $email
             ServerName $domain
             ServerAlias $Alias
             DocumentRoot $directory

             ErrorLog ${APACHE_LOG_DIR}/error.$name.log
             CustomLog ${APACHE_LOG_DIR}/access.$name.log combined
         </VirtualHost>" > /etc/apache2/sites-available/$domain.conf

        # -------- Active le site avec a2ensite --------
         sudo a2ensite $domain.conf

        # -------- Crée le répertoire pour le site --------
         sudo mkdir $directory

        # -------- Crée un fichier index.html dans le répertoire --------
        sudo touch $directory/index.html
        sudo chmod 755 $directory/index.html
        echo "<html>
         <head>
             <title>$domain</title>
         </head>
         <body>
             <h1>Bienvenue sur $domain</h1>
         </body>
         </html>" >$directory/index.html

        # -------- Redémarre Apache pour prendre en compte les changements --------
         sudo systemctl reload apache2
         sudo service apache2 restart

         echo ""
         echo "Voila votre site et prets a etre utiliser"

                break
                ;;











    2)  echo "Installation LAMP en cours..."
        # -------- Installation du LAMP --------

        # Demande les informations nécessaires à l'utilisateur A REFAIRE VERIFIER DE BASE SI CA EXISTE SINON ON DEMANDE
        read -p "Entrez votre nom (ex : Aterrieur ): " name
        read -p "Entrez le nom de domaine (ex : btsinfo.nc): " Alias
        read -p "Entrez votre Adresse Mail: " email

       #Create full path for var/www & $name
        directory="/var/www/$name"
        domain="$name.$Alias"

        #Affiche les informations saisies
        echo ""
        echo "Vous avez saisi : { $name } comme nom"
        echo "Vous avez saisi : { $domain } comme nom de domaine / url"
        echo "Vous avez saisi : { $email } comme adresse mail"
        echo "Vous avez saisi : { $Alias } comme alias / nom de domaine"
        echo "Vous avez saisi : { $directory } comme répertoire"
        echo ""


# ----------------- Vérification de l'installation des paquets -----------------

        # Vérification de l'installation de Apache
        if ! [ -x "$(command -v apache2)" ]; then
            echo "Apache2 n'est pas installé. Installations en cours..."
            sudo apt-get install apache2 -y
        else
            echo "Apache2 est déjà installé."
        fi

        # Vérification de l'installation de MySQL
        if ! [ -x "$(command -v mysql)" ]; then
            echo "MySQL n'est pas installé. Installations en cours..."
            sudo apt-get install mysql-server -y
        else
            echo "MySQL est déjà installé."
        fi

        # Vérification de l'installation de PHP
        if ! [ -x "$(command -v php)" ]; then
            echo "PHP n'est pas installé. Installations en cours..."
            sudo apt-get install php libapache2-mod-php -y
            sudo apt-get install php-mysql -y
        else
            echo "PHP est déjà installé."
            sudo apt-get install php-mysql -y
        fi





        # -------- Crée le fichier de configuration Apache --------
        sudo touch /etc/apache2/sites-available/$domain.conf
        sudo chmod 755 /etc/apache2/sites-available/$domain.conf
        echo "<VirtualHost *:80>
             ServerAdmin $email
             ServerName $domain
             ServerAlias $Alias
             DocumentRoot $directory

             ErrorLog ${APACHE_LOG_DIR}/error.$name.log
             CustomLog ${APACHE_LOG_DIR}/access.$name.log combined
         </VirtualHost>" > /etc/apache2/sites-available/$domain.conf

        # -------- Active le site avec a2ensite --------
         sudo a2ensite $domain.conf

        # -------- Crée le répertoire pour le site --------
         sudo mkdir $directory

        # -------- Crée un fichier index.html dans le répertoire --------
        sudo mkdir $directory


         echo ""
         echo "Installation LAMP terminée"
         echo "Installation de Wordpress en cours..."
         echo ""

        # -------- Installation de Wordpress --------
        # -------- On va dans le repertoire home --------
        cd ~
        mkdir script_wordpress_$name
        cd script_wordpress_$name
        pwd
        pwd
        pwd
        pwd

        # -------- Téléchargement de Wordpress --------
        wget https://wordpress.org/latest.tar.gz
        
        # -------- On deplace le wordpress dans le repertoire $directory  --------
        sudo mv latest.tar.gz $directory

        # -------- On se place dans le repertoire $directory --------
        cd $directory

        # -------- On extrait le fichier --------
        sudo tar -xvf latest.tar.gz

        # -------- On supprime le fichier tar.gz --------
        sudo rm -r latest.tar.gz

        # -------- On se place dans le repertoire wordpress --------
        cd wordpress

        # -------- On copie le contenu du repertoire wordpress dans le repertoire $directory --------
        sudo cp -r * $directory

        # -------- On se place dans le repertoire $directory --------
        cd $directory

        # -------- On supprime le repertoire wordpress --------
        sudo rm -r wordpress

        # -------- On donne les droits au repertoire $directory --------
        sudo chown -R www-data:www-data $directory
        sudo chmod -R 755 $directory
        # -------- On crée la base de données --------

        # -------- On demmande les informations necessaires à l'utilisateur --------
        echo "Entrez le nom de la base de données pour Wordpress :"
        read dbname
        echo "Entrez l'utilisateur de la base de données :"
        read dbuser
        echo "Entrez le mot de passe de la base de données :"
        read dbpass

        # -------- On crée la base de données --------
        mysql -u root -p -e "CREATE DATABASE $dbname"
        mysql -u root -p -e "GRANT ALL PRIVILEGES ON $dbname.* TO $dbuser@localhost IDENTIFIED BY '$dbpass'"
        mysql -u root -p -e "FLUSH PRIVILEGES"

        #on supprime les dossiers & fichiers inutiles
        cd ~
        sudo rm -r script_wordpress_$name


        # -------- Redémarre Apache pour prendre en compte les changements --------
         sudo systemctl reload apache2
         sudo service apache2 restart

         echo ""
         echo "Installation de Wordpress terminée"
         echo ""
         echo "Pour accéder à l'interface d'administration de Wordpress, rendez-vous à l'adresse suivante dans votre navigateur :"
         echo "http://$domain/wordpress/wp-admin"
         echo ""
         echo "Maintenant il faut configurer le sertificat SSL via certbot. "
         echo "Si vous avez une backup de wordpress, suivez églament les instructions dans la documentations. "


        break
        ;;










    3)  echo "Update & Upgrade en cours..."
        # -------- Mise a jour et upgrade du systeme --------
        sudo apt-get update && sudo apt-get upgrade -y
        break
        ;;




    4)  echo "Suppression de LAMP en cours..."
        # -------- Suppression de LAMP --------
        sudo apt-get remove apache2 -y
        sudo apt-get remove mysql-server -y
        sudo apt-get remove php libapache2-mod-php -y
        sudo apt-get remove php-mysql -y
        sudo apt-get autoremove -y
        break
        ;;





    5)  exit
        ;;

    *) # -------- dans le cas ou l'utilisateur rentre autre chose que 1, 2 ou 3 --------
        clear
        echo "Option non valide"
        ;;
  esac
done

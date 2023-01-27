#!/bin/bash

while true; do
  echo "1) Installation LAMP"
  echo "2) Update & Upgrade de votre LAMP"
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
            echo "Configuration de MySQL en cours..."
            # Configuration de MySQL en utilisant MySQL Secure
            read -p "Entrez le nom d'utilisateur root mysql: " MYSQL_USER
            read -p "Entrez le mot de passe root mysql: " MYSQL_PASSWORD
            # Configuration de MySQL en utilisant MySQL Secure
            sudo mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -e "mysql_secure_installation"
        else
            echo "MySQL est déjà installé."
        fi

        # Vérification de l'installation de PHP
        if ! [ -x "$(command -v php)" ]; then
            echo "PHP n'est pas installé. Installations en cours..."
            sudo apt-get install php libapache2-mod-php -y
        else
            echo "PHP est déjà installé."
        fi




        # -------- Crée le fichier de configuration Apache --------
        sudo touch /etc/apache2/sites-available/$domain.conf
         sudo echo "<VirtualHost *:80>
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
         sudo echo "<html>
         <head>
             <title>$domain</title>
         </head>
         <body>
             <h1>Bienvenue sur $domain</h1>
         </body>
         </html>" > $directory/index.html

        # -------- Redémarre Apache pour prendre en compte les changements --------
         sudo service apache2 restart






                break
                ;;





    2)  echo "Update & Upgrade en cours..."
        # -------- Mise a jour et upgrade du systeme --------
        sudo apt-get update && sudo apt-get upgrade -y
        break
        ;;






    3)  exit
        ;;


    *) # -------- dans le cas ou l'utilisateur rentre autre chose que 1, 2 ou 3 --------
        clear
        echo "Option non valide"
        ;;
  esac
done

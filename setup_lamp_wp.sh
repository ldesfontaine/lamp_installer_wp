#!/bin/bash

check_apache() {
  # Vérification de l'installation de Apache
  if ! [ -x "$(command -v apache2)" ]; then
      echo "Apache2 n'est pas installé. Installations en cours..."
      sudo apt-get install apache2 -y
  else
      echo "Apache2 est déjà installé."
  fi
}


check_MySql(){
  # Vérification de l'installation de MySQL ou de mariaDB
#  ON VERRIFIE QUE MARIADB OU MYSQL NE SOIS PAS DEJA INSTALLE
  if ! [ -x "$(command -v mysql)" ]; then
      echo "MySQL n'est pas installé. Installations en cours..."
#      si on obtiens une erreur on installe mariaDB
      try
      {
        sudo apt-get install mysql-server -y
      }
      catch || {
        echo "Erreur lors de l'installation de MySQL. Installation de MariaDB en cours..."
        sudo apt-get install mariadb-server -y
      }
  else
      echo "MySQL est déjà installé."
  fi
}

check_MySql_Secure(){
  if [ -f /root/.mysql_secure_installation ]; then
      echo "MySQL est déjà installé et sécurisé."
  else
      echo "MySQL n'est pas installé et sécurisé. Installations en cours..."
      sudo mysql_secure_installation
      touch /root/.mysql_secure_installation
      #TODO faire une installation plus sécurisé + probleme connexion mysql/bdd avec wordpress ....

  fi
}

db_setup(){
  # -------- On crée la base de données --------
  mysql -u root -p -e "CREATE DATABASE $dbname"
  mysql -u root -p -e "GRANT ALL PRIVILEGES ON $dbname.* TO $dbuser@localhost IDENTIFIED BY '$dbpass'"
  mysql -u root -p -e "FLUSH PRIVILEGES"
}

check_PHP(){
  # Vérification de l'installation de PHP
  if ! [ -x "$(command -v php)" ]; then
      echo "PHP n'est pas installé. Installations en cours..."
      sudo apt-get install php libapache2-mod-php -y
      sudo apt-get install php-mysql -y
  else
      echo "PHP est déjà installé."
      sudo apt-get install php-mysql -y
  fi
}

apache_conf(){
# -------- Crée le fichier de configuration Apache --------
  sudo touch /etc/apache2/sites-available/"$domain".conf
  sudo chmod 755 /etc/apache2/sites-available/"$domain".conf
  echo "<VirtualHost *:80>
       ServerAdmin $email
       ServerName $domain
       ServerAlias $Alias
       DocumentRoot $directory

       ErrorLog ${APACHE_LOG_DIR}/error.$name.log
       CustomLog ${APACHE_LOG_DIR}/access.$name.log combined
   </VirtualHost>" > /etc/apache2/sites-available/"$domain".conf

   #on active le site et désactive le site par défaut
  sudo a2ensite "$domain".conf
  if [ -f /etc/apache2/sites-enabled/000-default.conf ]; then
      sudo a2dissite 000-default.conf
  fi
}

directory_lamp(){
# -------- Crée le répertoire pour le site --------
  sudo mkdir "$directory"
# -------- Crée un fichier index.html dans le répertoire --------
  sudo touch "$directory"/index.html
  sudo chmod 755 "$directory"/index.html
  echo "<html>
   <head>
       <title>$domain</title>
   </head>
   <body>
       <h1>Bienvenue sur $domain</h1>
   </body>
   </html>" >"$directory"/index.html



directory(){
# -------- Crée le répertoire pour le site --------
  sudo mkdir "$directory"
}

restart_service(){
  sudo systemctl reload apache2
  sudo systemctl restart apache2
}

download_wordpress(){
  # -------- Installation de Wordpress --------
  echo "Installation de Wordpress en cours..."
  echo ""

  cd ~
  mkdir script_wordpress_"$name"
  cd script_wordpress_"$name"
  # -------- Téléchargement de Wordpress --------
  wget https://wordpress.org/latest.tar.gz
  #on déplace le dossier dans le répertorie $directory
  sudo mv latest.tar.gz "$directory"
  # -------- On se place dans le repertoire $directory --------
  cd "$directory"
  # -------- On extrait le fichier --------
  sudo tar -xvf latest.tar.gz
  # -------- On supprime le fichier tar.gz --------
  sudo rm -r latest.tar.gz
  # -------- On se place dans le repertoire wordpress --------
  cd wordpress
  # -------- On copie le contenu du repertoire wordpress dans le repertoire $directory --------
  sudo cp -r * "$directory"
  # -------- On se place dans le repertoire $directory --------
  cd "$directory"
  # -------- On supprime le repertoire wordpress --------
  sudo rm -r wordpress
  # -------- On donne les droits au repertoire $directory --------
  sudo chown -R www-data:www-data "$directory"
  sudo chmod -R 755 "$directory"
}

clear_script(){
  #on supprime les dossiers & fichiers inutiles
  cd ~
  sudo rm -r script_wordpress_"$name"
}

show_info(){
  echo ""
  echo "Installation de Wordpress terminée"
  echo ""
  echo "Pour accéder à l'interface d'administration de Wordpress, rendez-vous à l'adresse suivante dans votre navigateur :"
  echo "http://$domain/wordpress/wp-admin"
  echo ""
  echo "Maintenant il faut configurer le certificat SSL via certbot. "
  echo "Si vous avez une backup de wordpress, suivez également les instructions dans la documentations. "
}

info_user(){
  echo "Veuillez saisir les informations suivantes :"
  echo ""

  read -p "Entrez votre nom (ex : Aterrieur ): " name
  read -p "Entrez le nom de domaine (ex : btsinfo.nc): " Alias
  read -p "Entrez votre Adresse Mail: " email

  #-------- On demande les infos pour l'installation secure de mysql --------
  echo ""
  read -p "Entrez le mot de passe root de mysql: " root_pass

  # -------- On demande les informations nécessaire pour configurer un nouvelle user MySql --------
  echo ""
  read -p "Entrez le nom de la base de données: " db_name
  read -p "Entrez le nom de l'utilisateur: " db_user
  read -p "Entrez le mot de passe de l'utilisateur: " db_pass


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
}







upgrade_LAMP(){
# -------- Mise a jour et upgrade du systeme --------
  sudo apt-get update -y
  sudo apt-get upgrade -y
}

usntall_LAMP(){
  # -------- Suppression de LAMP --------
  sudo apt-get remove apache2 -y
  sudo apt-get remove mysql-server -y
  sudo apt-get remove php libapache2-mod-php -y
  sudo apt-get remove php-mysql -y
  sudo apt-get autoremove -y
}

install_lamp(){
  echo "Installation de LAMP en cours..."
  echo ""
  upgrade_LAMP
  check_apache
  check_MySql
  check_PHP
  db_setup
  apache_conf
  directory_lamp
  restart_service
}

install_wordpress_lamp(){
  echo "Installation de LAMP en cours..."
  echo ""
  upgrade_LAMP
  check_apache
  check_MySql
  check_PHP
  db_setup
  apache_conf
  directory
  restart_service
  download_wordpress
  clear_script
  restart_service
  show_info
}


# -------- Menu --------
while true; do
    clear
    echo "Menu"
    echo "1. Installer LAMP"
    echo "2. Installer Wordpress + LAMP"
    echo "3. Supprimer LAMP"
    echo "4. Mettre à jour LAMP"
    echo "5. Quitter"
    echo ""
    read -p "Choisissez une option : " option
    case $option in
        1) info_user
           install_lamp
           exit 0
           ;;
        2) info_user
           install_wordpress_lamp
           exit 0
           ;;
        3) usntall_LAMP
           ;;
        4) upgrade_LAMP
            ;;
        5) exit 0
           ;;
        *) echo "Choix invalide"
           ;;
    esac
done
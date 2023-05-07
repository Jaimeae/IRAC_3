#!/bin/bash

sudo apt install -y mysql-server wget apache2 php php-mysqli unzip
sudo mv 20-mysqli.ini /etc/php/8.1/apache2/conf.d/
sudo service mysql start
sudo rm -r /var/www/html/*
sudo mysql -u root <<-EOF
          CREATE USER 'jaime'@'localhost' IDENTIFIED BY ''; #crea usuario en mysql
          GRANT ALL PRIVILEGES ON * . * TO 'jaime'@'localhost'; #da maximos privilegios al usuario creado
          flush privileges; #reinicia todos los permisos para aplicar cambios
EOF
sudo mysql -u jaime <<-EOF
          create database irac; #crea DB para el login web
          use irac;
          CREATE TABLE usuarios (user VARCHAR(30) PRIMARY KEY UNIQUE,password VARCHAR(100),key VARCHAR(30));
          INSERT INTO usuarios (user, password, key) VALUES ('user1', 'user1', 'INSERTAR');
          INSERT INTO usuarios (user, password, key) VALUES ('user2', 'user2', 'INSERTAR');
EOF
wget https://www.bok.net/Bento4/binaries/Bento4-SDK-1-6-0-639.x86_64-unknown-linux.zip
unzip Bento4-SDK-1-6-0-639.x86_64-unknown-linux.zip
sudo service apache2 start

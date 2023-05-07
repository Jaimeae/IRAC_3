#!/bin/bash

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


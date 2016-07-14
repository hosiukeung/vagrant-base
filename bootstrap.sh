#!/bin/bash

# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo Installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
}

echo "Updating package information"
apt-get -y update >/dev/null 2>&1

install 'Development tools' build-essential curl

install git git

install memcached memcached
install redis redis-server
install RabbitMQ rabbitmq-server

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
install MySQL mysql-server libmysqlclient-dev
mysql -uroot -proot <<SQL
CREATE USER 'test_user'@'localhost';
CREATE DATABASE test_database DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON test_database.* to 'test_user'@'localhost';
SQL

install Node nodejs npm
install Vim vim

update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

echo 'Provision completed'

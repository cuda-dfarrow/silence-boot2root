#! /usr/bin/env bash

export SCRIPT_DIR=$( dirname "${BASH_SOURCE[0]}" )

if [ "$USER" != "root" ]; then
	echo "This script must be run as 'root'"
	exit -1
fi

# Install dependancies
echo
echo "Installing dependencies"
echo "======================="
aptitude -y update
aptitude -y install curl git sudo
aptitude -y install apache2 libapache2-mod-perl2 apache2-dev
aptitude -y install mysql-client mysql-server libmysqlclient-dev

# Install needed perl modules
echo
echo "Installing Perl modules"
echo "======================="
cpan install CPAN
cpan install DBI
cpan install CGI 'CGI::Session' 'DBD::mysql' 'Data::GUID' 'Text::Caml'

# Set up the Apache site configs
echo
echo "Configuring Apache"
echo "======================="
ln -s -f /etc/apache2/mods-available/perl.load /etc/apache2/mods-enabled/perl.load
rm -f /etc/apache2/sites-enabled/*.conf
cp -f $SCRIPT_DIR/silence.conf /etc/apache2/sites-available/
ln -s -f /etc/apache2/sites-available/silence.conf /etc/apache2/sites-enabled/silence.conf

# Set up the files
echo
echo "Setting up www files"
echo "======================="
mkdir -p /var/www/html
rm -rf /var/www/html/*
cp -rfv $SCRIPT_DIR/www/* /var/www/html/
chmod -R +Xr /var/www/html/*

# Configure  sevices
echo
echo "Configuring services"
echo "======================="
systemctl enable apache2
systemctl enable mysql
systemctl restart apache2
systemctl restart mysql

# Configure MySQL
echo
echo "Configuring MySQL"
echo "======================="
mysql --user=root -p < $SCRIPT_DIR/setup.sql

echo "I'm done Simon. You're welcome!"

# now set up the rest
echo
echo "Create user accounts"
echo "======================="
$SCRIPT_DIR/makeUsers.sh

echo
echo "Configure git"
echo "======================="
chown :git $SCRIPT_DIR/makeLocalGit.sh
su -c $SCRIPT_DIR/makeServerGit.sh git
chown :psimon $SCRIPT_DIR/makeLocalGit.sh
su -c $SCRIPT_DIR/makeLocalGit.sh psimon

echo
echo "Plant breadcrumbs and cleanup"
echo "======================="
$SCRIPT_DIR/leaveCrumbs.sh
$SCRIPT_DIR/cleanup.sh
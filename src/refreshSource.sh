#! /usr/bin/env bash
service apache2 stop
rm -rfv /var/www/html/*
cp -rfv www/* /var/www/html/
chmod -R +rX /var/www/html/*
service apache2 start
#!/bin/bash

VERSION=1.0
URL=https://github.com/apognu/zdashboard/archive/$VERSION.tar.gz

wget -O zdashboard-$VERSION.tar.gz $URL
tar xf zdashboard-$VERSION.tar.gz

mkdir -p build/usr/share/zdashboard build/etc/{zdashboard,init.d}
mv zdashboard-$VERSION/* build/usr/share/zdashboard/
cp initscripts/debian.init build/etc/init.d/zdashboard

# Bundle gems in package, ugly but clean for the system...
cd build/usr/share/zdashboard
bundle install --deployment

mv usr/share/zdashboard/config/database.yml etc/zdashboard
mv usr/share/zdashboard/config/ldap.yml etc/zdashboard
mv usr/share/zdashboard/config/initializers/secret_token.rb etc/zdashboard
ln -sf /etc/zdashboard/database.yml usr/share/zdashboard/config/database.yml
ln -sf /etc/zdashboard/ldap.yml usr/share/zdashboard/config/ldap.yml
ln -sf /etc/zdashboard/secret_token.rb usr/share/zdashboard/config/initializers/secret_token.rb


fpm -n zdashboard -v $VERSION -a amd64 -C build -m "<jonathan.raffre@smile.fr>" --after-install zdashboard.postinstall --description "ZDashboard - Zarafa User Management Interface" --url 'https://github.com/apognu/zdashboard' -t deb --config-files etc/zdashboard/ldap.yaml --config-files etc/zdashboard/database.yml --config-files /etc/zdashboard/secret_token.rb -d ruby1.9.1 -s dir etc usr

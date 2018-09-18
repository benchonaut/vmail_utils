#!/bin/bash
if [ -z "$1" ];then echo "NEED DOMAIN AS FIRST ARGUMENT" ; exit 3 ; fi
domain=$1;
vmailpass=$(grep password /etc/postfix/virtual/mysql-domains.cf|cut -d"=" -f2-|cut -d" " -f2- |sed 's/ //g'|tr -d '\n');
#CHECK IF DOMAIN IS REGISTERED IN SYSTEM
echo "SELECT * FROM vmail.\`domains\` WHERE domain='"$domain"'" | mysql -u vmail -p"$vmailpass"|grep -q "$domain" || ( echo DOMAIN NOT REGISTERED IN SYSTEM ; echo "INSERT INTO vmail.\`domains\` (\`domain\`) VALUES ('"$domain"');" | mysql -u vmail -p"$vmailpass"  ; echo "SELECT * FROM vmail.\`domains\` WHERE domain='"$domain"';" | mysql -u vmail -p"$vmailpass" ; exit 3 ) && echo "DOMAIN ALREADY REGISTERED, NOTHING TO DO"

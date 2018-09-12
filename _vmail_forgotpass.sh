#!/bin/bash
if [ -z "$1" ];then echo "NEED DOMAIN AS FIRST ARGUMENT" ; exit 3 ; fi
if [ -z "$2" ];then echo "NEED USERNAME AS SECOND ARGUMENT"; exit 3 ;fi
domain=$1;usertogen=$2; 
vmailpass=$(grep password /etc/postfix/virtual/mysql-domains.cf|cut -d"=" -f2-|cut -d" " -f2- |sed 's/ //g'|tr -d '\n');
#CHECK IF DOMAIN IS REGISTERED IN SYSTEM
echo "SELECT * FROM vmail.\`domains\` WHERE domain='"$domain"'" | mysql -u vmail -p$vmailpass|grep -q "$domain" || ( echo DOMAIN NOT REGISTERED IN SYSTEM ; exit 3 ) && 
  (echo "SELECT * FROM vmail.\`users\` WHERE domain='"$domain"' AND username='"$usertogen"'" |  mysql -u vmail -p$vmailpass  | grep "$usertogen"  || echo USER DOES NOT EXIST && ( if [ -z "$3" ];then  echo "ENTER PASS";read newmailuserpass ; else newmailuserpass="$3" ; fi ; dovestring=$((echo "$newmailuserpass";echo "$newmailuserpass")|doveadm pw -s SHA512-CRYPT |cut -d"}" -f2-); echo "UPDATE vmail.\`users\` SET password = '"$dovestring"' WHERE domain='"$domain"' AND username='"$usertogen"' ;" | mysql -u vmail -p$vmailpass  ; echo "SELECT * FROM vmail.\`users\` WHERE domain='"$domain"' AND username='"$usertogen"'" | mysql -u vmail -p$vmailpass))

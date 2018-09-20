#!/bin/bash
if [ -z "$1" ];then echo "NEED DOMAIN AS FIRST ARGUMENT" ; exit 3 ; fi
if [ -z "$2" ];then echo "NEED USERNAME AS SECOND ARGUMENT, use @ for catchall"; exit 3 ;fi
if [ -z "$3" ];then echo "NEED DESTINATION AS THIRD ARGUMENT"; exit 3 ;fi
domain=$1;usertogen=$2; destination=$3
if [ "$usertogen" == "@" ] ; then echo CATCHALL DETECTED;usertogen="";fi
vmailpass=$(grep password /etc/postfix/virtual/mysql-domains.cf|cut -d"=" -f2-|cut -d" " -f2- |sed 's/ //g'|tr -d '\n');
#CHECK IF DOMAIN IS REGISTERED IN SYSTEM
echo "SELECT * FROM vmail.\`domains\` WHERE domain='"$domain"'" | mysql -u vmail -p"$vmailpass"|grep -q "$domain" || ( echo DOMAIN NOT REGISTERED IN SYSTEM ; exit 3 ) && 
	echo "SELECT * FROM vmail.\`aliases\` WHERE source='"$usertogen"@"$domain"' AND destination='"$destination"'"  | mysql -u vmail -p"$vmailpass"|grep "$usertogen"'@'"$domain"|grep "$destination"  && echo DIRECT ALIAS ALREADY THERE ||
		(echo NO DIRECT ALIAS,GENERATING ; echo "INSERT INTO vmail.\`aliases\` (\`source\`,\`destination\`) VALUES ('"$usertogen"@"$domain"','"$destination"');"| mysql -u vmail -p"$vmailpass" )

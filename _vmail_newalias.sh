#!/bin/bash
if [ -z "$1" ];then echo "NEED DOMAIN AS FIRST ARGUMENT" ; exit 3 ; fi
domain=$1;
vmailpass=$(grep password /etc/postfix/virtual/mysql-domains.cf|cut -d"=" -f2-|cut -d" " -f2- |sed 's/ //g'|tr -d '\n');
#CHECK IF DOMAIN IS REGISTERED IN SYSTEM
echo "SELECT * FROM vmail.\`domains\` WHERE domain='"$domain"'" | mysql -u vmail -p"$vmailpass"|grep -q "$domain" || ( echo DOMAIN NOT REGISTERED IN SYSTEM ; exit 3 ) && 
	echo "SELECT * FROM vmail.\`aliases\` WHERE source='"$usertogen"@"$domain"' AND destination='"$usertogen"@"$domain"'"  | mysql -u vmail -p"$vmailpass"|grep "$usertogen"'@'"$domain"  && echo DIRECT ALIAS ALREADY THERE ||
		(echo NO DIRECT ALIAS,GENERATING ; echo "INSERT INTO vmail.\`aliases\` (\`source\`,\`destination\`) VALUES ('"$usertogen"@"$domain"','"$usertogen"@"$domain"');"| mysql -u vmail -p"$vmailpass" )

#!/bin/bash

STATUS=$(systemctl status nginx | grep "active" | sed 's/.*:\(.*)\).*/\1/')
USUARIO=$(whoami)
DATA=$(date |sed 's/-.*//')

## VALIDAÇÃO OFFLINE NOS LOGS

if [ "$STATUS" == " active (running)" ]; then
	RESULTADO="Servidor ativo e funcionando"
	echo "Serviço: nginx" >> /home/francie/scripts/nginx_online.log
	echo "Usuário: $USUARIO" >> /home/francie/scripts/nginx_online.log
	echo "Data e horário: $DATA" >> /home/francie/scripts/nginx_online.log
	echo "Status do nginx: $RESULTADO" >> /home/francie/scripts/nginx_online.log
	echo " " >> /home/francie/scripts/nginx_online.log
else
	RESULTADO="Servidor inativo!"
	echo "Serviço: nginx" >> /home/francie/scripts/nginx_offline.log
	echo "Usuário: $USUARIO" >> /home/francie/scripts/nginx_offline.log
	echo "Data e horário: $DATA" >> /home/francie/scripts/nginx_offline.log
	echo "Status do nginx: $RESULTADO" >> /home/francie/scripts/nginx_offline.log
	echo " " >> /home/francie/scripts/nginx_offline.log
fi

## VALIDAÇÃO NO ARQUIVO DE STATUS

echo "Serviço: nginx" >> /home/francie/scripts/statusNginx.txt
echo "Usuário: $USUARIO" >> /home/francie/scripts/statusNginx.txt
echo "Data e horário: $DATA" >> /home/francie/scripts/statusNginx.txt
echo "Status do nginx: $RESULTADO" >> /home/francie/scripts/statusNginx.txt
echo " " >> /home/francie/scripts/statusNginx.txt

## VALIDAÇÃO DO STATUS ON-LINE

rm -rf /home/francie/scripts/index.html
touch /home/francie/scripts/index.html
echo -e "<!DOCTYPE html>\n
<html>\n
<head>\n
<meta charset='utf-8'/>
<meta http-equiv="refresh" content="10" />
<title>"Status do nginx!"</title>\n
<style>
    body {
        width: 25em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
        font-size: 25px;
        color: white;
        background: #01080E 90%;
    }
</style>
</head>\n
<body>\n
<h2>\n" >> /home/francie/scripts/index.html
echo -n "Bem-vindo(a) ao nginx!" >> /home/francie/scripts/index.html
echo -en "</h2> \n <p>Serviço: nginx"  >> /home/francie/scripts/index.html
echo -en "</p>\n<p>Usuário: $USUARIO" >> /home/francie/scripts/index.html
echo -en "\n<p> Data e horário: $DATA" >> /home/francie/scripts/index.html
echo -en "</p>\n<p>Status do nginx: $RESULTADO" >> /home/francie/scripts/index.html
echo -en "</body>\n</html>" >> /home/francie/scripts/index.html

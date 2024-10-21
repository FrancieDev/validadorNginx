# validadorNginx

README 
APLICAÇÃO DE MONITORAMENTO DO NGINX

Introdução
NGINX é um servidor web de alta performance, escalabilidade e baixo consumo de recursos, desenvolvido para lidar com um grande número de conexões simultâneas. É frequentemente usado para servir conteúdo estático, como imagens e arquivos HTML.

Este projeto cria um servidor Nginx no Linux e um script de validação do servidor, com mensagens personalizadas, monitorando se o serviço está on-line ou off-line. O projeto faz parte das minhas atividades no programa de estágio na UOL Compass.

Instalação
Neste projeto, criei um subsistema Ubuntu para WSL no Windows. Alguns comandos no Linux podem não funcionar corretamente se o kernel do sistema não estiver atualizado. Portanto, a primeira coisa a ser feita é atualizar o kernel do Linux para WSL instalando o pacote no link abaixo:
https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi

Abra o PowerShell no Windows e digite o comando:

wsl --update

Depois de realizar esta atualização, instale o Linux com o subsistema Ubuntu 20.04 ou superior. Para verificar a lista de subsistemas disponíveis, utilize o comando:

wsl --list --online

A versão escolhida foi a 22.04, então execute o comando:

wsl –install Ubuntu-22.04

Após a instalação, reinicie o computador e o Linux estará pronto para uso. Ao iniciar o Ubuntu pela primeira vez, ele fará as configurações automaticamente. Logo em seguida, informe o nome de usuário desejado e uma senha.
Para executar a instalação do nginx, será preciso logar no Linux como root para ter maior nível de autorização das tarefas que se seguem. Para logar como root, execute o comando e informe uma senha, caso seja solicitada:
sudo su

A instalação do servidor nginx é simples com apenas um comando. Contudo, antes será preciso atualizar os pacotes do sistema executando os comandos na sequência:

apt-get update
apt-get upgrade

Após esta breve atualização, execute o comando para instalar o nginx:

apt-get install nginx

Quando a instalação for bem-sucedida, o nginx já estará funcionando. Abra o navegador de internet, digite localhost na barra de endereços que abrirá a página de boas-vindas do nginx. Também é possível verificar se o servidor nginx está rodando dentro do Linux executando o comando:

systemctl status nginx

A linha Active exibe o status do serviço, sendo “active (running)” para on-line e “inactive (dead)” para off-line. Para criar o script que validará o serviço, precisaremos desta informação e de outras que veremos mais à frente. Primeiramente, crie o arquivo de script do serviço de validação com o nome de scriptServidor.sh (ou outro nome desejado) executando o comando:

nano scriptServidor.sh

Com o editor de texto Nano aberto, comece a escrever o script iniciando a primeira linha do arquivo sempre pela instrução #!/bin/bash para indicar ao sistema que será usado o compilador do bash para executar o script. Logo abaixo, crie uma variável de nome STATUS para armazenar a informação do status on-line do nginx. Use o mesmo comando anterior para verificar o status, porém com os seguintes detalhes para capturar apenas a informação do “active running”, lendo a partir do “:” até o fechamento do “)”:
STATUS=$(systemctl status nginx | grep “active” | sed ‘s/.*:\(.*)\).*/\1/’)

Crie agora uma variável para armazenar a informação do usuário que está logado no sistema:

USUARIO=$(whoami)

E então, crie outra variável para armazenar a data e horário atual do sistema que serão usados para validar e armazenar esses dados nos arquivos de log usando o comando date. Contudo, é importante notar que alguns sistemas Ubuntu podem não estar com os arquivos de configuração de locale em português, exibindo assim a data e horário em inglês ou até mesmo o erro de “Cannot set LC_ALL to default locale” caso tente rodar a data em português. A correção deste problema é opcional, mas caso queira corrigi-lo, feche o nano e volte para a linha de comando e execute os comandos abaixo na sequência:

locale-gen en_US en_US.UTF-8 pt_BR.UTF-8
dpkg-reconfigure locales

Para verificar se deu tudo certo, execute o comando date e veja se a data saiu no formato PT-BR. Deverá exibir algo parecido com:

seg 21 out 2024 07:11:55 -03

Será preciso informar no script esta linha com as informações de data e horário até antes do “-03”. Portanto, abra novamente o arquivo de script no nano e crie na sequência de linhas a seguinte variável:

DATA=$(date | sed ‘s/-.*//’)

Neste momento, vamos precisar criar alguns arquivos para validar o serviço do nginx de modo offline, ou seja, em arquivos de log gravados no disco local. Para isso, feche novamente o nano e volte para a linha de comando. Crie 3 arquivos de log distintos, podendo nomeá-los, por exemplo, como “nginx_online.log” para validar o serviço on-line, “nginx_offline.log” para validar se o serviço está offline e “statusNginx.txt” para validar o serviço tanto on-line como offline, executando os comandos:

nano nginx_online.log
nano nginx_offline.log
nano statusNginx.txt

Salve esses arquivos na mesma parte em que se encontra o arquivo de script que está sendo criado. Agora, retorne ao arquivo do script que está sendo criado no Nano e comece a codificar a parte de validação offline e validação no arquivo de status. Podem ser usados vários métodos para essa validação, mas no caso deste projeto, foi escolhida uma validação utilizando uma estrutura de if and else pela linguagem do bash, conforme pode ser visto no arquivo “scriptServidor.sh” aqui na lista de arquivos do projeto.

Para verificar se a validação está correta, precisamos executar o arquivo de script na linha de comando. Caso tente executar o arquivo e um erro de permissão for exibido, significa que é preciso alterar a permissão do arquivo de script para conseguir executá-lo. Portanto, passe o seguinte comando para alterar esta permissão:

chmod +x scriptServidor.sh

Agora, execute o comando a seguinte para iniciar o script:

./scriptServidor.sh

Não será exibido nada no terminal porque o script foi criado para validar o nginx nos arquivos de log. Por isso, abra o arquivo “nginx_online.log” e “statusNginx.txt” com o comando cat para verificar se os dados de log foram gravados nestes arquivos:

cat nginx_online.log
cat statusNginx.txt

Agora, para executar a parte de validação offline, vamos desativar o serviço do nginx temporariamente executando o comando:
systemctl stop nginx

Logo em seguida, execute o arquivo de script e abra o arquivo de validação “nginx_offline.log” e “statusNginx.txt” para verificar se os dados foram gravados neles através da seguinte sequência de comandos:
./scriptServidor.sh
cat nginx_offline.log

Estando tudo corretamente configurado nesta parte, será preciso agora criar a parte de validação on-line onde será exibida uma página html com o status atual do servidor. Para isso, crie um arquivo html de nome “index.html” com o conteúdo vazio. O arquivo de script será responsável por atualizar o conteúdo o html conforme pode ser visto no arquivo “index.html”. Visto que esta página html será estática, é possível usar um código que atualiza a página em um dado intervalo de tempo. Neste projeto, usei o intervalo de 10 segundos para atualizar a página e o seguinte código logo acima da tag title:

<meta http-equiv="refresh" content="10" />

Por fim, e não menos importante, vamos configurar para que script seja executado automaticamente a cada 5 min, verificando se o nginx está on-line ou offline, conforme o escopo do projeto. Para isso, vamos usar o crontab, uma aplicação no Linux que executa uma dada tarefa de acordo com intervalos de tempo específicos.
Para criar o arquivo crontab, execute o comando:
crontab -e

Será aberto arquivo de texto para que você edite e insira o código para programar a tarefa. Na última linha, digite o seguinte código “*/5 * * * * bash [local do arquivo de script]”. Por exemplo, se você salvou o arquivo de script scriptNginx.sh na pasta /home/script, o código ficará:

*/5 * * * * bash /home/script/scriptNginx.sh

O algarismo “5” indica que o crontab executará o arquivo de script a cada 5 minutos. É possível também configurar para outros intervalos de tempo como horas, minutos ou até datas específicas. Salve e feche o arquivo, assim o crontab já iniciará a programação da tarefa. Finalmente, abra o arquivo index.html e verifique se a atualização do status do servidor está sendo exibida corretamente a cada 5 min. Verifique também pelo terminal se os logs estão sendo gravados corretamente.


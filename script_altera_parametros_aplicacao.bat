@echo off

set location=%~dp0
set /p instance=  Informe a instancia de banco que deve sofrer as alteracoes:
set /p user= Informe o usuario do banco:
set /p password= Informe a senha do usuario informado:
set /p dbname=  Informe o nome do banco:
set /p version= Informe a versao do sistema Quirius:
set /p defaultdir= Informe a pasta base de armazenamento (SEM ULTIMA BARRA):
set /p emailfts=Informe o email do remetente FTS:
set /p ishom= E sistema de homolocacao: (1-sim / 2-nao)
set /p confdoc= Tem conferencia de documentos: (1-sim / 2-nao)
set /p armazxml= Contratou armazenamento de xml de saida: (1-sim / 2-nao)
set /p processnfse= Contratou NFSe: (1-sim / 2-nao)

set displayhom=

if %ishom%==1 (
		set displayhom=_Hom
)

set variables =-v ishom=%ishom% -v emailfts=%emailfts% -v defaultdir=%defaultdir% -v version=%version% -v ishom=%ishom% -v conf=%confdoc% -v armazxml=%armazxml% -v processnfse=%processnfse% -v location=%location% -v displayhom=%displayhom%

sqlcmd -S %COMPUTERNAME%\%instance% -U %user% -P %password% -d %dbname% %variables% -i %location%script_altera_parametros_aplicacao.sql -e

pause

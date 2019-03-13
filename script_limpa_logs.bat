@ECHO OFF
SET location=%~dp0

ECHO *************************************************************
ECHO *********       SCRIPT APAGA LOGS              **************
ECHO *************************************************************
ECHO ****     APAGARA TODOS OS ARQUIVOS *log.txt           *******
ECHO *************************************************************
ECHO ***********   APERTE ENTER PARA CONTINUAR        ************
ECHO *************************************************************
PAUSE>NUL

DEL /F /S /Q %location%*log.txt
IF %ERRORLEVEL% == 0 GOTO finish
ECHO *************************************************************
ECHO *********       ACONTECEU UM ERRO              **************

:finish
ECHO *************************************************************
ECHO *********  FIM DO PROCESSO               ********************
ECHO ******  PRESSIONE QUALQUER TECLA PARA SAIR ...      *********
ECHO *************************************************************
PAUSE>nul

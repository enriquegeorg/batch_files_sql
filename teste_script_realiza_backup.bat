@ECHO OFF
Title %~n0
Mode 80,21 & Color A
SET location=%~dp0

:setdatetime
SET data=%Date: =0%
SET dia=%data:~0,2%
SET mes=%data:~3,2%
SET ano=%data:~6,4%
SET tempo=%Time: =0%
SET hora=%tempo:~0,2%
SET minuto=%tempo:~3,2%

SET bkplocation=%location%Backups\%dia%-%mes%-%ano%

:loop
ECHO *************************************************************
ECHO *********    SCRIPT REALIZA BACKUP APLICACAO    *************
ECHO *************************************************************
ECHO ****   LEMBRE-SE: OS SERVICOS E SITE SERAO PARADOS    *******
ECHO ****   FUNCIONAL PARA VER. 3.X.X.X+                   *******
ECHO *************************************************************
ECHO ***********   1- PRODUCAO 2- HOMOLOGACAO         ************
ECHO *************************************************************
SET /p ishom=**** DIGITE E APERTE ENTER:
ECHO ***********   DIGITE O NOME DO SITE NO IIS       ************
ECHO *************************************************************
SET /p nomeiis=**** DIGITE E APERTE ENTER:

IF %ishom% GEQ 3 CLS & GOTO loop
IF %ishom% LEQ 0 CLS & GOTO loop
IF %ishom%==1 GOTO isprod
IF %ishom%==2 GOTO ishom

PAUSE

:isprod
net stop GovAudService
net stop GovAudCalendar
net stop GovAudAgendador
net stop GovDFeCopy
net stop GovDFeImport
net stop GovDFeNfeUtil
net stop GovDFeNfse
net stop GovDFeVerify
net stop GovDFeEmail
%windir%\system32\inetsrv\appcmd stop sites "%nomeiis%"
ECHO *************************************************************
ECHO *********    CHEQUE MENSAGENS DE ERRO ACIMA     *************
ECHO *********    PROXIMO PASSO: LIMPAR LOGS         *************
ECHO *********    APERTE ENTER PARA EXECUTAR         *************
ECHO *************************************************************
PAUSE>nul
CLS
:limpalogs
IF NOT EXIST %location%script_limpa_logs.bat (
  ECHO *************************************************************
  ECHO *********    INSIRA O SCRIPT LIMPA LOGS          ************
  ECHO *********    APERTE ENTER PARA EXECUTAR NOVAMENTE   *********
  ECHO *************************************************************
  PAUSE>nul
  GOTO limpalogs
)
CALL %location%script_limpa_logs.bat
CLS
ECHO *************************************************************
ECHO *********    PROXIMO PASSO: EXTRAIR PARAMETROS    ***********
ECHO *********    APERTE ENTER PARA EXECUTAR         *************
ECHO *************************************************************
PAUSE>nul
:extrator
IF NOT EXIST %location%extrator_parametros.bat (
  ECHO *************************************************************
  ECHO *********    INSIRA O EXTRATOR DE PARAMETROS     ************
  ECHO *********    APERTE ENTER PARA EXECUTAR NOVAMENTE   *********
  ECHO *************************************************************
  PAUSE>nul
  GOTO extrator
)
CALL %location%extrator_parametros.bat
CLS
IF NOT EXIST %location%\WebService GOTO copy

:ishom
net stop GovAudService_Hom
net stop GovAudCalendar_Hom
net stop GovAudAgendador_Hom
net stop GovDFeCopy_Hom
net stop GovDFeImport_Hom
net stop GovDFeNfeUtil_Hom
net stop GovDFeNfse_Hom
net stop GovDFeVerify_Hom
net stop GovDFeEmail_Hom
%windir%\system32\inetsrv\appcmd stop sites "%nomeiis%"
ECHO *************************************************************
ECHO *********    CHEQUE MENSAGENS DE ERRO ACIMA     *************
ECHO *********    APERTE ENTER PARA EXTRAIR PARAMETROS   *********
ECHO *************************************************************
PAUSE
CLS
:limpalogs
IF NOT EXIST %location%script_limpa_logs.bat (
  ECHO *************************************************************
  ECHO *********    INSIRA O SCRIPT LIMPA LOGS          ************
  ECHO *********    APERTE ENTER PARA EXECUTAR NOVAMENTE   *********
  ECHO *************************************************************
  PAUSE>nul
  GOTO limpalogs
)
CALL %location%script_limpa_logs.bat
CLS
ECHO *************************************************************
ECHO *********    PROXIMO PASSO: EXTRAIR PARAMETROS    ***********
ECHO *********    APERTE ENTER PARA EXECUTAR         *************
ECHO *************************************************************
PAUSE>nul
:extrator
IF NOT EXIST %location%extrator_parametros.bat (
  ECHO *************************************************************
  ECHO *********    INSIRA O EXTRATOR DE PARAMETROS     ************
  ECHO *********    APERTE ENTER PARA EXECUTAR NOVAMENTE   *********
  ECHO *************************************************************
  PAUSE>nul
  GOTO extrator
)
CALL %location%extrator_parametros.bat
CLS

REM IF NOT EXIST %bkplocation% (
REM   MKDIR %bkplocation%
REM )

IF NOT EXIST %location%\WebService GOTO copy

FOR %%D IN (
  Aplicacao
  Servicos
  WebServices
)DO robocopy %location%%%D %bkplocation%\%%D /E /is /it
CD %bkplocation%
ZIP -r -p "%hora%h%minuto%m.zip" "*"
RMDIR /s /q %bkplocation%\Aplicacao
RMDIR /s /q %bkplocation%\Servicos
RMDIR /s /q %bkplocation%\WebServices
RMDIR /s /q %bkplocation%\extrator_parametros
GOTO finish

:copy
FOR %%D IN (
  Aplicacao
  Servicos
)DO robocopy %location%%%D %bkplocation%\%%D /E /is /it
CD %bkplocation%
ZIP -r -p "%hora%h%minuto%m.zip" "*"
RMDIR /s /q %bkplocation%\Aplicacao
RMDIR /s /q %bkplocation%\Servicos
RMDIR /s /q %bkplocation%\extrator_parametros

:finish
ECHO *************************************************************
ECHO *********  FIM DO PROCESSO               ********************
ECHO ******  PRESSIONE QUALQUER TECLA PARA SAIR ...      *********
ECHO *************************************************************
PAUSE>NUL

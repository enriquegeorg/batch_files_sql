@ECHO OFF
Title %~n0
Mode 80,21 & Color A
SET location=%~dp0


ECHO *************************************************************
ECHO *********       SCRIPT COPIA PASTA ADMIN       **************
ECHO *************************************************************
ECHO ****   LEMBRE-SE: CONEXAO DEVE ESTAR PARAMETRIZADA    *******
ECHO *************************************************************
ECHO ***********   APERTE ENTER PARA CONTINUAR        ************
ECHO *************************************************************
PAUSE>NUL

IF NOT EXIST %location%Servicos\Receiver GOTO error
FOR %%D IN (
%location%Servicos\Receiver\QuiriusCopyService\
%location%Servicos\Receiver\QuiriusImportService\
%location%Servicos\Receiver\QuiriusNfeUtilService\
%location%Servicos\Receiver\QuiriusNfseService\
%location%Servicos\Receiver\QuiriusSyncService\
%location%Servicos\Receiver\QuiriusVerifyService\
%location%Servicos\Receiver\QuiriusWinService\
%location%Servicos\Auditor\AuditorService\
%location%Servicos\Auditor\CalendarService\
) DO robocopy "%location%Aplicacao\Admin" %%DAdmin /E /is /it
IF EXIST %location%Ferramentas\AuditorMaintenance robocopy "%location%Aplicacao\Admin" "%location%Ferramentas\AuditorMaintenance\Admin" /E

IF %ERRORLEVEL% LSS 8 GOTO finish
:error
ECHO *************************************************************
ECHO *********       ACONTECEU UM ERRO              **************


:finish
ECHO *************************************************************
ECHO *********  FIM DO PROCESSO               ********************
ECHO ******  PRESSIONE QUALQUER TECLA PARA SAIR ...      *********
ECHO *************************************************************
PAUSE>nul

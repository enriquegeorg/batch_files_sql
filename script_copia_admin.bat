@echo off
set location=%~dp0

for %%D in (
%location%Servicos\Receiver\QuiriusCopyService\
%location%Servicos\Receiver\QuiriusImportService\
%location%Servicos\Receiver\QuiriusNfeUtilService\
%location%Servicos\Receiver\QuiriusNfseService\
%location%Servicos\Receiver\QuiriusSyncService\
%location%Servicos\Receiver\QuiriusVerifyService\
%location%Servicos\Receiver\QuiriusWinService\
) do robocopy "%location%Aplicacao\Admin" %%DAdmin /E

IF %ERRORLEVEL% LSS 8 GOTO finish

ECHO ALGUM ERRO ACONTECEU (VERIFIQUE O LEIA-ME) & GOTO :eof

:finish

ECHO AS PASTAS FORAM COPIADAS COM SUCESSO

PAUSE

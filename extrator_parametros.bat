@echo OFF
Title %~n0
Mode 80,21 & Color A

CHCP 65001
:bdtype
CLS
ECHO *************************************************************
ECHO *********  TIPO DO BANDO DE DADOS         *******************
ECHO *************************************************************
SET /p bdtype= *** 1 - SQL / 2 - ORACLE :
IF %bdtype% GEQ 3 GOTO bdtype
IF %bdtype% LEQ 0 GOTO bdtype
IF %bdtype% == 1 GOTO connectionsql
IF %bdtype% == 2 GOTO connectionora

:connectionora
ECHO *************************************************************
ECHO *********  INSIRA OS DADOS DE CONEXAO     *******************
ECHO *************************************************************
SET /p ip= *** ENDEREÇO DO SERVIDOR (C/ PORTA SE HOUVE):
SET /p user= *** USUARIO DO BANCO:
REM SET /p password= *** SENHA:
Call:InputPassword "*** SENHA" password
CLS
ECHO *************************************************************
ECHO *********  AGUARDE: TESTE DE CONEXAO      *******************
ECHO *************************************************************
ECHO SELECT COUNT(*) FROM ALL_ALL_TABLES | sqlplus %user%/%password%@%ip%
IF ERRORLEVEL 1 (
  ECHO ******************   ERRO      ***************************
  PAUSE>nul
  GOTO connectionora
)
PAUSE>nul
CLS
GOTO stepselect

:connectionsql
ECHO *************************************************************
ECHO *********  INSIRA OS DADOS DE CONEXAO     *******************
ECHO *************************************************************
SET /p ip= *** IP DO SERVIDOR:
SET /p instance= *** INSTANCIA (SE TIVER):
SET /p dbname=  *** NOME DA BASE DE DADOS:
SET /p user= *** USUARIO DO BANCO:
Call:InputPassword "*** SENHA" password
REM SET /p password= *** SENHA:
REM SET ip=qualidade.quirius.com.br
REM SET instance=
REM SET dbname=Governanca_8089
REM SET user=sa
REM SET password=@quirius123
CLS
ECHO *************************************************************
ECHO *********  AGUARDE: TESTE DE CONEXAO      *******************
ECHO *************************************************************
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -Q "use master"
IF ERRORLEVEL 1 (
  ECHO ******************   ERRO      ***************************
  PAUSE>nul
GOTO connectionsql
)
CLS

:stepselect
ECHO *************************************************************
ECHO *********  SELECIONE A ETAPA DA INSTACAO  *******************
ECHO *************************************************************
ECHO ****  1 - TERMINO DA IMPLANTACAO TECNICA       **************
ECHO ****  2 - TERMINO DA PARAMETRIZACAO FUNCIONAL  **************
ECHO ****  3 - GOLIVE                          *******************
ECHO ****  4 - ANTES DA ATUALIZACAO            *******************
ECHO ****  5 - APOS A ATUALIZACAO              *******************
ECHO *************************************************************
ECHO *************************************************************
SET /p etapa=****  ETAPA:

SET location=%~dp0
:loop
IF %etapa% GEQ 6 GOTO valorerrado
IF %etapa% LEQ 0 GOTO valorerrado
IF %etapa% EQU 1 SET etapa=IMPLANTEC
IF %etapa% EQU 2 SET etapa=PARAMFUNC
IF %etapa% EQU 3 SET etapa=GOLIVE
IF %etapa% EQU 4 SET etapa=PREATUALIZ
IF %etapa% EQU 5 SET etapa=POSATUALIZ
GOTO start
:valorerrado
CLS
ECHO *************************************************************
ECHO *********  SELECIONE A ETAPA DA INSTACAO  *******************
ECHO *************************************************************
ECHO ****  1 - TERMINO DA IMPLANTACAO TECNICA       **************
ECHO ****  2 - TERMINO DA PARAMETRIZACAO FUNCIONAL  **************
ECHO ****  3 - GOLIVE                          *******************
ECHO ****  4 - ANTES DA ATUALIZACAO            *******************
ECHO ****  5 - APOS A ATUALIZACAO              *******************
ECHO *************************************************************
ECHO *************************************************************
ECHO *********  VALOR INCONSISTENTE!!!  **************************
ECHO *********  DIGITE NOVAMENTE      ****************************
ECHO *************************************************************
ECHO *************************************************************
SET /p etapa=****  ETAPA:
GOTO loop
:start

:setdatetime
SET data=%Date: =0%
SET dia=%data:~0,2%
SET mes=%data:~3,2%
SET ano=%data:~6,4%
SET tempo=%Time: =0%
SET hora=%tempo:~0,2%
SET minuto=%tempo:~3,2%

REM IF NOT EXIST %location%\extrator_parametros MKDIR %location%\extrator_parametros

SET exlocation=%location%Backups\%dia%-%mes%-%ano%\extrator_parametros
REM ECHO %bkplocation%
REM PAUSE>NUL
IF NOT EXIST %exlocation% (
  MKDIR %exlocation%
)

IF %bdtype% == 1 GOTO querysql
IF %bdtype% == 2 GOTO queryora

:querysql
SET querydfeaplicacao=SELECT CAST(TDFE_PARAMETRO_APLICACAO.COD_PARAMETRO  AS VARCHAR(40)) AS COD_PARAMETRO, 	CAST(TDFE_PARAMETRO.DES_PARAMETRO AS VARCHAR(100)) AS DES_PARAMETRO, 	CAST(TDFE_PARAMETRO_APLICACAO.DES_VALOR AS VARCHAR(120)) AS DES_VALOR FROM TDFE_PARAMETRO_APLICACAO INNER JOIN TDFE_PARAMETRO ON(TDFE_PARAMETRO_APLICACAO.COD_PARAMETRO=TDFE_PARAMETRO.COD_PARAMETRO)
SET querydfeempresa=SELECT CAST(TFRW_EMPRESA.COD_EMPRESA  AS VARCHAR(2)) AS COD_EMPRESA, CAST(TDFE_PARAMETRO_EMPRESA.COD_PARAMETRO  AS VARCHAR(40)) AS COD_PARAMETRO, CAST(TDFE_PARAMETRO.DES_PARAMETRO AS VARCHAR(80)) AS DES_PARAMETRO, CAST(TDFE_PARAMETRO_EMPRESA.DES_VALOR AS VARCHAR(40)) AS DES_VALOR FROM TDFE_PARAMETRO_EMPRESA INNER JOIN TFRW_EMPRESA ON(TDFE_PARAMETRO_EMPRESA.COD_EMPRESA=TFRW_EMPRESA.COD_EMPRESA) INNER JOIN TDFE_PARAMETRO ON(TDFE_PARAMETRO_EMPRESA.COD_PARAMETRO=TDFE_PARAMETRO.COD_PARAMETRO)
SET querydfeestab=SELECT CAST(TDFE_PARAMETRO_ESTABELECIMENTO.COD_EMPRESA AS VARCHAR(10)) AS COD_EMPRESA, CAST(TDFE_PARAMETRO_ESTABELECIMENTO.COD_ESTABELECIMENTO AS VARCHAR(10)) AS COD_ESTABELECIMENTO, CAST(TDFE_PARAMETRO_NIVEL.COD_NIVEL AS VARCHAR(5)) AS COD_NIVEL, CAST(TDFE_PARAMETRO_ESTABELECIMENTO.COD_PARAMETRO AS VARCHAR(40)) AS COD_PARAMETRO, CAST(TDFE_PARAMETRO.DES_PARAMETRO AS VARCHAR(80)) AS DES_PARAMETRO, 	CAST(TDFE_PARAMETRO_ESTABELECIMENTO.DES_VALOR AS VARCHAR(40)) AS DES_VALOR FROM TDFE_PARAMETRO_ESTABELECIMENTO INNER JOIN TDFE_PARAMETRO ON(TDFE_PARAMETRO_ESTABELECIMENTO.COD_PARAMETRO=TDFE_PARAMETRO.COD_PARAMETRO) LEFT JOIN TDFE_PARAMETRO_NIVEL ON (TDFE_PARAMETRO_NIVEL.DES_TABLE='TDFE_PARAMETRO_ESTABELECIMENTO' AND TDFE_PARAMETRO.COD_NIVEL=TDFE_PARAMETRO_NIVEL.COD_NIVEL)
SET querydfeconstr=SELECT DISTINCT(CAST(TDFE_ODBC_CONNECTION_STRING.CONNECTION_STRING AS VARCHAR(244))) AS CONNECTION_STRING, CAST(TDFE_ODBC_CONNECTION_STRING.ID_ODBC_CONNECTION_STRING AS VARCHAR(5)) AS ID_CONNECTION, CAST(TDFE_ODBC_ESTABELECIMENTO.COD_ESTABELECIMENTO AS VARCHAR(5)) AS COD_ESTAB,	CAST(TDFE_ODBC_ESTABELECIMENTO.COD_EMPRESA AS VARCHAR(5)) AS COD_EMPRESA FROM TDFE_ODBC_CONNECTION_STRING INNER JOIN TDFE_ODBC_ESTABELECIMENTO ON(TDFE_ODBC_CONNECTION_STRING.ID_ODBC_CONNECTION_STRING=TDFE_ODBC_ESTABELECIMENTO.ID_ODBC_CONNECTION_STRING) ORDER BY COD_EMPRESA, COD_ESTAB
SET querydfeodbc=SELECT CAST(TDFE_ODBC.COD_EMPRESA AS VARCHAR(5)) AS COD_EMPRESA, CAST(TDFE_ODBC.COD_ODBC AS VARCHAR(30)) AS COD_ODBC, CAST(TDFE_ODBC.QUERY AS varchar(4020)) AS QUERY FROM TDFE_ODBC
SET queryaudaplicacao=SELECT CAST(TAUD_PARAMETRO_APLICACAO.COD_PARAMETRO  AS VARCHAR(40)) AS COD_PARAMETRO, CAST(TAUD_PARAMETRO.DES_PARAMETRO AS VARCHAR(100)) AS DES_PARAMETRO, CAST(TAUD_PARAMETRO_APLICACAO.DES_VALOR AS VARCHAR(200)) AS DES_VALOR  FROM TAUD_PARAMETRO_APLICACAO INNER JOIN TAUD_PARAMETRO ON(TAUD_PARAMETRO_APLICACAO.COD_PARAMETRO=TAUD_PARAMETRO.COD_PARAMETRO)
SET queryaudestab=SELECT CAST(TAUD_PARAMETRO_ESTABELECIMENTO.COD_EMPRESA  AS VARCHAR(10)) AS COD_EMPRESA, CAST(TAUD_PARAMETRO_ESTABELECIMENTO.COD_ESTABELECIMENTO  AS VARCHAR(10)) AS COD_ESTABELECIMENTO, CAST(TAUD_PARAMETRO_ESTABELECIMENTO.COD_PARAMETRO  AS VARCHAR(40)) AS COD_PARAMETRO, CAST(TAUD_PARAMETRO.DES_PARAMETRO AS VARCHAR(80)) AS DES_PARAMETRO, CAST(TAUD_PARAMETRO_ESTABELECIMENTO.DES_VALOR AS VARCHAR(40)) AS DES_VALOR FROM TAUD_PARAMETRO_ESTABELECIMENTO INNER JOIN TAUD_PARAMETRO ON(TAUD_PARAMETRO_ESTABELECIMENTO.COD_PARAMETRO=TAUD_PARAMETRO.COD_PARAMETRO)

SET queryteste=SELECT CAST_ODBC AS VARC33HAR(30)) AS COD_ODBC, REPLACE(REPLA345CE(CAST(TDFE_ODBC.QUERY AS VARCHAR(500)), CHAR(5), ' ' ),CHAR(4), ' ' ) AS TESTE FROM TDFE_ODBC

ECHO *************************************************************
ECHO *********       EXECUTANDO... AGUARDE     *******************
ECHO *************************************************************

sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -Q  "%querydfeaplicacao%" -b -s " " -o %exlocation%\TDFE_PARAMETRO_APLICACAO_%ano%%mes%%dia%_%hora%%minuto%_%etapa%.txt
IF ERRORLEVEL 1 (
  ECHO *************************************************************
  ECHO ******  ERRO NA EXTRACAO: TDFE_PARAMETRO_APLICACAO   ********
  PAUSE>nul |set/p = ******  APERTE ENTER PARA CONTINUAR !!               ********
)
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -Q  "%querydfeempresa%" -b -s " " -o %exlocation%\TDFE_PARAMETRO_EMPRESA_%ano%%mes%%dia%_%hora%%minuto%_%etapa%.txt
IF ERRORLEVEL 1 (
  ECHO *************************************************************
  ECHO ******  ERRO NA EXTRACAO: TDFE_PARAMETRO_EMPRESA     ********
  PAUSE>nul |set/p = ******  APERTE ENTER PARA CONTINUAR !!               ********
)
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -Q "%querydfeestab%" -b -s " " -o %exlocation%\TDFE_PARAMETRO_ESTABELECIMENTO_%ano%%mes%%dia%_%hora%%minuto%_%etapa%.txt
IF ERRORLEVEL 1 (
  ECHO *************************************************************
  ECHO ******  ERRO NA EXTRACAO: TDFE_PARAMETRO_ESTABELECIMENTO   **
  PAUSE>nul |set/p = ******  APERTE ENTER PARA CONTINUAR !!               ********
)
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -Q "%querydfeconstr%" -b -s " " -o %exlocation%\TDFE_ODBC_ESTABELECIMENTO_%ano%%mes%%dia%_%hora%%minuto%_%etapa%.txt
IF ERRORLEVEL 1 (
  ECHO *************************************************************
  ECHO ******  ERRO NA EXTRACAO: TDFE_ODBC_ESTABELECIMENTO   *******
  PAUSE>nul |set/p = ******  APERTE ENTER PARA CONTINUAR !!               ********
)
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -Q "%querydfeodbc%" -b -s " " -b -o %exlocation%\TDFE_ODBC_%ano%%mes%%dia%_%hora%%minuto%_%etapa%.txt
IF ERRORLEVEL 1 (
  ECHO *************************************************************
  ECHO ******  ERRO NA EXTRACAO: TDFE_ODBC                   *******
  PAUSE>nul |set/p = ******  APERTE ENTER PARA CONTINUAR !!               ********
)
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -Q "%queryaudaplicacao%" -b -s " " -o %exlocation%\TAUD_PARAMETRO_APLICACAO_%ano%%mes%%dia%_%hora%%minuto%_%etapa%.txt
IF ERRORLEVEL 1 (
  ECHO *************************************************************
  ECHO ******  ERRO NA EXTRACAO: TAUD_PARAMETRO_APLICACAO    *******
  PAUSE>nul |set/p = ******  APERTE ENTER PARA CONTINUAR !!               ********
)
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -Q "%queryaudestab%" -b -s " " -o %exlocation%\TAUD_PARAMETRO_ESTABELECIMENTO_%ano%%mes%%dia%_%hora%%minuto%_%etapa%.txt
IF ERRORLEVEL 1 (
  ECHO *************************************************************
  ECHO ******  ERRO NA EXTRACAO: TAUD_PARAMETRO_ESTABELECIMENTO  ***
  PAUSE>nul |set/p = ******  APERTE ENTER PARA CONTINUAR !!               ********
)

GOTO finish

:queryora
ECHO *************************************************************
ECHO *********  FUNCAO NAO IMPLEMENTADA        *******************
ECHO *************************************************************
REM SET querydfeaplicacao=SELECT TO_CHAR(TDFE_PARAMETRO_APLICACAO.COD_PARAMETRO (40)) AS COD_PARAMETRO, 	TO_CHAR(TDFE_PARAMETRO.DES_PARAMETRO(100)) AS DES_PARAMETRO, 	TO_CHAR(TDFE_PARAMETRO_APLICACAO.DES_VALOR(120)) AS DES_VALOR FROM TDFE_PARAMETRO_APLICACAO INNER JOIN TDFE_PARAMETRO ON(TDFE_PARAMETRO_APLICACAO.COD_PARAMETRO=TDFE_PARAMETRO.COD_PARAMETRO)
REM SET querydfeempresa=SELECT TO_CHAR(TFRW_EMPRESA.COD_EMPRESA (2)) AS COD_EMPRESA, TO_CHAR(TDFE_PARAMETRO_EMPRESA.COD_PARAMETRO (40)) AS COD_PARAMETRO, TO_CHAR(TDFE_PARAMETRO.DES_PARAMETRO(80)) AS DES_PARAMETRO, TO_CHAR(TDFE_PARAMETRO_EMPRESA.DES_VALOR(40)) AS DES_VALOR FROM TDFE_PARAMETRO_EMPRESA INNER JOIN TFRW_EMPRESA ON(TDFE_PARAMETRO_EMPRESA.COD_EMPRESA=TFRW_EMPRESA.COD_EMPRESA) INNER JOIN TDFE_PARAMETRO ON(TDFE_PARAMETRO_EMPRESA.COD_PARAMETRO=TDFE_PARAMETRO.COD_PARAMETRO)
REM SET querydfeestab=SELECT TO_CHAR(TDFE_PARAMETRO_ESTABELECIMENTO.COD_EMPRESA (10)) AS COD_EMPRESA, TO_CHAR(TDFE_PARAMETRO_ESTABELECIMENTO.COD_ESTABELECIMENTO(10)) AS COD_ESTABELECIMENTO, TO_CHAR(TDFE_PARAMETRO_ESTABELECIMENTO.COD_PARAMETRO (40)) AS COD_PARAMETRO, TO_CHAR(TDFE_PARAMETRO.DES_PARAMETRO(80)) AS DES_PARAMETRO, TO_CHAR(TDFE_PARAMETRO_ESTABELECIMENTO.DES_VALOR(40)) AS DES_VALOR FROM TDFE_PARAMETRO_ESTABELECIMENTO INNER JOIN TDFE_PARAMETRO ON(TDFE_PARAMETRO_ESTABELECIMENTO.COD_PARAMETRO=TDFE_PARAMETRO.COD_PARAMETRO)
REM SET querydfeconstr=SELECT DISTINCT(TO_CHAR(TDFE_ODBC_CONNECTION_STRING.CONNECTION_STRING(244))) AS CONNECTION_STRING, TO_CHAR(TDFE_ODBC_CONNECTION_STRING.ID_ODBC_CONNECTION_STRING(5)) AS ID_CONNECTION, TO_CHAR(TDFE_ODBC_ESTABELECIMENTO.COD_ESTABELECIMENTO(5)) AS COD_ESTAB,	TO_CHAR(TDFE_ODBC_ESTABELECIMENTO.COD_EMPRESA(5)) AS COD_EMPRESA FROM TDFE_ODBC_CONNECTION_STRING INNER JOIN TDFE_ODBC_ESTABELECIMENTO ON(TDFE_ODBC_CONNECTION_STRING.ID_ODBC_CONNECTION_STRING=TDFE_ODBC_ESTABELECIMENTO.ID_ODBC_CONNECTION_STRING) ORDER BY COD_EMPRESA, COD_ESTAB
REM SET querydfeodbc=SELECT TO_CHAR(TDFE_ODBC.COD_EMPRESA(5)) AS COD_EMPRESA, TO_CHAR(TDFE_ODBC.COD_ODBC(30)) AS COD_ODBC, TO_CHAR(TDFE_ODBC.QUERY(4020)) AS QUERY FROM TDFE_ODBC
REM SET queryaudaplicacao=SELECT TO_CHAR(TAUD_PARAMETRO_APLICACAO.COD_PARAMETRO (40)) AS COD_PARAMETRO, TO_CHAR(TAUD_PARAMETRO.DES_PARAMETRO(100)) AS DES_PARAMETRO, TO_CHAR(TAUD_PARAMETRO_APLICACAO.DES_VALOR(200)) AS DES_VALOR  FROM TAUD_PARAMETRO_APLICACAO INNER JOIN TAUD_PARAMETRO ON(TAUD_PARAMETRO_APLICACAO.COD_PARAMETRO=TAUD_PARAMETRO.COD_PARAMETRO)
REM SET queryaudestab=SELECT TO_CHAR(TAUD_PARAMETRO_ESTABELECIMENTO.COD_EMPRESA (10)) AS COD_EMPRESA, TO_CHAR(TAUD_PARAMETRO_ESTABELECIMENTO.COD_ESTABELECIMENTO (10)) AS COD_ESTABELECIMENTO, TO_CHAR(TAUD_PARAMETRO_ESTABELECIMENTO.COD_PARAMETRO (40)) AS COD_PARAMETRO, TO_CHAR(TAUD_PARAMETRO.DES_PARAMETRO(80)) AS DES_PARAMETRO, TO_CHAR(TAUD_PARAMETRO_ESTABELECIMENTO.DES_VALOR(40)) AS DES_VALOR FROM TAUD_PARAMETRO_ESTABELECIMENTO INNER JOIN TAUD_PARAMETRO ON(TAUD_PARAMETRO_ESTABELECIMENTO.COD_PARAMETRO=TAUD_PARAMETRO.COD_PARAMETRO)

:finish
ECHO *************************************************************
ECHO *********  FIM DO PROCESSO               ********************
ECHO ******  VERIFIQUE SE HA MENSAGENS DE ERROS ACIMA    *********
ECHO ******  PRESSIONE QUALQUER TECLA PARA SAIR ...      *********
ECHO *************************************************************
PAUSE>nul

:InputPassword
SET "psCommand=powershell -Command "$pword = read-host '%1' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
      [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
        for /f "usebackq delims=" %%p in (`%psCommand%`) do set %2=%%p
)
GOTO :eof

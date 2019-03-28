@echo OFF
Title %~n0
Mode 80,21 & Color A

CHCP 65001

SET location=%~dp0
SET prereq=0
IF EXIST %location%\Ferramentas\Extrator\queryoracle.sql  SET prereq=1
IF EXIST %location%\Ferramentas\Extrator\querysql.sql  SET prereq=%prereq%2
IF %prereq%==12 GOTO bdtype
ECHO *************************************************************
ECHO *****     VERIFIQUE OS PRE-REQUISITOS DO EXTRATOR    ********
ECHO *****     E INICIE O EXECUTAVEL NOVAMENTE            ********
ECHO *************************************************************
PAUSE>nul
EXIT

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
ECHO ****  4 - PRE-ATUALIZACAO                 *******************
ECHO ****  5 - POS-ATUALIZACAO                 *******************
ECHO *************************************************************
ECHO *************************************************************
SET /p etapa=****  ETAPA:


:loop
IF %etapa% GEQ 6 GOTO valorerrado
IF %etapa% LEQ 0 GOTO valorerrado
IF %etapa% EQU 1 SET etapa=1.IMPLANTEC
IF %etapa% EQU 2 SET etapa=2.PARAMFUNC
IF %etapa% EQU 3 SET etapa=3.GOLIVE
IF %etapa% EQU 4 SET etapa=4.PREATUALIZACAO
IF %etapa% EQU 5 SET etapa=5.POSATUALIZACAO
GOTO start
:valorerrado
CLS
ECHO *************************************************************
ECHO *********  SELECIONE A ETAPA DA INSTACAO  *******************
ECHO *************************************************************
ECHO ****  1 - TERMINO DA IMPLANTACAO TECNICA       **************
ECHO ****  2 - TERMINO DA PARAMETRIZACAO FUNCIONAL  **************
ECHO ****  3 - GOLIVE                          *******************
ECHO ****  4 - PRE-ATUALIZACAO                 *******************
ECHO ****  5 - POS-ATUALIZACAO                 *******************
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
SET makelocation1=%location%Backups
IF NOT EXIST %makelocation1% (
  MKDIR %makelocation1%
)
SET makelocation2=%makelocation1%\%dia%-%mes%-%ano%
IF NOT EXIST %makelocation2% (
  MKDIR %makelocation2%
)
REM SET makelocation3=%makelocation1%\%dia%-%mes%-%ano%\extrator_parametros
REM IF NOT EXIST %makelocation3% (
REM   MKDIR %makelocation3%
REM )
SET makelocation4=%makelocation2%\%etapa%
IF NOT EXIST %makelocation4% (
  MKDIR %makelocation4%
)
SET exlocation=%makelocation4%
REM ECHO %bkplocation%
REM PAUSE>NUL

IF %bdtype% == 1 GOTO querysql
IF %bdtype% == 2 GOTO queryora

:querysql

REM SET queryteste=SELECT CAST_ODBC AS VARC33HAR(30)) AS COD_ODBC, REPLACE(REPLA345CE(CAST(TDFE_ODBC.QUERY AS VARCHAR(500)), CHAR(5), ' ' ),CHAR(4), ' ' ) AS TESTE FROM TDFE_ODBC

ECHO *************************************************************
ECHO *********       EXECUTANDO... AGUARDE     *******************
ECHO *************************************************************

SET tabela=querydfeaplicacao
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% %variables% -i %location%Ferramentas\Extrator\querysql.sql -b -s " " -o %exlocation%\TDFE_PARAMETRO_APLICACAO.txt
IF ERRORLEVEL 1 (
  ECHO *************************************************************
  ECHO ******  ERRO NA EXTRACAO: TDFE_PARAMETRO_APLICACAO   ********
  PAUSE>nul |set/p = ******  APERTE ENTER PARA CONTINUAR !!               ********
)
SET tabela=querydfeempresa
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% %variables% -i %location%Ferramentas\Extrator\querysql.sql -b -s " " -o %exlocation%\TDFE_PARAMETRO_EMPRESA.txt
IF ERRORLEVEL 1 (
  ECHO *************************************************************
  ECHO ******  ERRO NA EXTRACAO: TDFE_PARAMETRO_EMPRESA     ********
  PAUSE>nul |set/p = ******  APERTE ENTER PARA CONTINUAR !!               ********
)
SET tabela=querydfeestab
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% %variables% -i %location%Ferramentas\Extrator\querysql.sql -b -s " " -o %exlocation%\TDFE_PARAMETRO_ESTABELECIMENTO.txt
IF ERRORLEVEL 1 (
  ECHO *************************************************************
  ECHO ******  ERRO NA EXTRACAO: TDFE_PARAMETRO_ESTABELECIMENTO   **
  PAUSE>nul |set/p = ******  APERTE ENTER PARA CONTINUAR !!               ********
)
SET tabela=querydfeconstr
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% %variables% -i %location%Ferramentas\Extrator\querysql.sql -b -s " " -o %exlocation%\TDFE_ODBC_ESTABELECIMENTO.txt
IF ERRORLEVEL 1 (
  ECHO *************************************************************
  ECHO ******  ERRO NA EXTRACAO: TDFE_ODBC_ESTABELECIMENTO   *******
  PAUSE>nul |set/p = ******  APERTE ENTER PARA CONTINUAR !!               ********
)
SET tabela=querydfeodbc
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% %variables% -i %location%Ferramentas\Extrator\querysql.sql -b -s " " -b -o %exlocation%\TDFE_ODBC.txt
IF ERRORLEVEL 1 (
  ECHO *************************************************************
  ECHO ******  ERRO NA EXTRACAO: TDFE_ODBC                   *******
  PAUSE>nul |set/p = ******  APERTE ENTER PARA CONTINUAR !!               ********
)
SET tabela=queryaudaplicacao
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% %variables% -i %location%Ferramentas\Extrator\querysql.sql -b -s " " -o %exlocation%\TAUD_PARAMETRO_APLICACAO.txt
IF ERRORLEVEL 1 (
  ECHO *************************************************************
  ECHO ******  ERRO NA EXTRACAO: TAUD_PARAMETRO_APLICACAO    *******
  PAUSE>nul |set/p = ******  APERTE ENTER PARA CONTINUAR !!               ********
)
SET tabela=queryaudestab
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% %variables% -i %location%Ferramentas\Extrator\querysql.sql  -b -s " " -o %exlocation%\TAUD_PARAMETRO_ESTABELECIMENTO.txt
IF ERRORLEVEL 1 (
  ECHO *************************************************************
  ECHO ******  ERRO NA EXTRACAO: TAUD_PARAMETRO_ESTABELECIMENTO  ***
  PAUSE>nul |set/p = ******  APERTE ENTER PARA CONTINUAR !!               ********
)
SET tabela=msgaplicacao
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% %variables% -i %location%Ferramentas\Extrator\querysql.sql -b -s " " -o %exlocation%\TDFE_GRUPO_DISTRIBUICAO.txt
IF ERRORLEVEL 1 (
  ECHO *************************************************************
  ECHO ******  ERRO NA EXTRACAO: TDFE_GRUPO_DISTRIBUICAO    ********
  PAUSE>nul |set/p = ******  APERTE ENTER PARA CONTINUAR !!               ********
)

GOTO finish

:queryora
ECHO *************************************************************
ECHO *********       EXECUTANDO... AGUARDE     *******************
ECHO *************************************************************
SET querydfeaplicacao=%exlocation%\TDFE_PARAMETRO_APLICACAO.txt
SET querydfeempresa=%exlocation%\TDFE_PARAMETRO_EMPRESA.txt
SET querydfeestab=%exlocation%\TDFE_PARAMETRO_ESTABELECIMENTO.txt
SET querydfeconstr=%exlocation%\TDFE_ODBC_ESTABELECIMENTO.txt
SET querydfeodbc=%exlocation%\TDFE_ODBC.txt
SET queryaudaplicacao=%exlocation%\TAUD_PARAMETRO_APLICACAO.txt
SET queryaudestab=%exlocation%\TAUD_PARAMETRO_ESTABELECIMENTO.txt
SET msgaplicacao=%exlocation%\TDFE_GRUPO_DISTRIBUICAO.txt
ECHO EXIT | sqlplus %user%/%password%@%ip% @%location%Ferramentas\Extrator\queryoracle.sql '%querydfeaplicacao%' '%querydfeempresa%' '%querydfeestab%' '%querydfeconstr%' '%querydfeodbc%' '%queryaudaplicacao%' '%queryaudestab%' '%msgaplicacao%'

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

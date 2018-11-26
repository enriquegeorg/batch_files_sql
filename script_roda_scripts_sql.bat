@echo off

set location=%~dp0
set /p ip=  Informe o ip de banco que deve sofrer as alteracoes:
set /p instance=  Informe a instancia de banco que deve sofrer as alteracoes (Se tiver):
set /p dbname=  Informe o nome do banco:
set /p user= Informe o usuario do banco:
set /p password= Informe a senha do usuario informado:
set logslocation=%location%Database\SqlServer\Logs

IF NOT EXIST %logslocation% (
  mkdir %logslocation%
  GOTO start
) ELSE (
  echo "Diretorio de logs ja existente - continuando ..."
  timeout 5 /nobreak
)

FOR /R "%logslocation%" %%G IN (*.txt) DO (
set lastlog=%%~nG
)
GOTO %lastlog%
REM IF "%lastlog%" NEQ "" (
REM  GOTO %lastlog%
REM )

:start
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -i %location%\Database\SqlServer\00_Estrutura_Platypus.sql -b -r1 2> %location%Database\SqlServer\Logs\00_Estrutura_Platypus.txt
IF NOT ERRORLEVEL 1 (
  GOTO 00_Estrutura_Platypus
) ELSE (
  ECHO EXECUTE O ARQUIVO 00_Estrutura_Platypus MANUALMENTE e rode este arquivo novamente
  PAUSE>nul |set/p =PRESSIONE QUALQUER TECLA PARA SAIR ...
  EXIT
)
:00_Estrutura_Platypus
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -i %location%Database\SqlServer\01_Estrutura_Receiver.sql -b -r1 2> %location%Database\SqlServer\Logs\01_Estrutura_Receiver.txt
IF NOT ERRORLEVEL 1 (
  GOTO 01_Estrutura_Receiver
) ELSE (
  ECHO EXECUTE O ARQUIVO 01_Estrutura_Receiver MANUALMENTE e rode este arquivo novamente
  PAUSE>nul |set/p =PRESSIONE QUALQUER TECLA PARA SAIR ...
  EXIT
)
:01_Estrutura_Receiver
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -i %location%Database\SqlServer\02_Estrutura_Auditor.sql -b -r1 2> %location%Database\SqlServer\Logs\02_Estrutura_Auditor.txt
IF NOT ERRORLEVEL 1 (
  GOTO 02_Estrutura_Auditor
) ELSE (
  ECHO EXECUTE O ARQUIVO 02_Estrutura_Auditor MANUALMENTE e rode este arquivo novamente
  PAUSE>nul |set/p =PRESSIONE QUALQUER TECLA PARA SAIR ...
  EXIT
)
:02_Estrutura_Auditor
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -i %location%Database\SqlServer\03_Carga_Platypus.sql -b -r1 2> %location%Database\SqlServer\Logs\03_Carga_Platypus.txt
IF NOT ERRORLEVEL 1 (
    GOTO 03_Carga_Platypus
) ELSE (
  ECHO EXECUTE O ARQUIVO 03_Carga_Platypus MANUALMENTE e rode este arquivo novamente
  PAUSE>nul |set/p =PRESSIONE QUALQUER TECLA PARA SAIR ...
  EXIT
)
:03_Carga_Platypus
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -i %location%Database\SqlServer\04_Carga_Receiver_1.sql -b -r1 2> %location%Database\SqlServer\Logs\04_Carga_Receiver_1.txt
IF NOT ERRORLEVEL 1 (
    GOTO 04_Carga_Receiver_1
) ELSE (
  ECHO EXECUTE O ARQUIVO 04_Carga_Receiver_1 MANUALMENTE e rode este arquivo novamente
  PAUSE>nul |set/p =PRESSIONE QUALQUER TECLA PARA SAIR ...
  EXIT
)
:04_Carga_Receiver_1
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -i %location%Database\SqlServer\04_Carga_Receiver_2.sql -b -r1 2> %location%Database\SqlServer\Logs\04_Carga_Receiver_2.txt
IF NOT ERRORLEVEL 1 (
    GOTO 04_Carga_Receiver_2
) ELSE (
  ECHO EXECUTE O ARQUIVO 04_Carga_Receiver_2 MANUALMENTE e rode este arquivo novamente
  PAUSE>nul |set/p =PRESSIONE QUALQUER TECLA PARA SAIR ...
  EXIT
)
:04_Carga_Receiver_2
 sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -i %location%Database\SqlServer\05_Carga_Auditor_1.sql -b -r1 2> %location%Database\SqlServer\Logs\05_Carga_Auditor_1.txt
IF NOT ERRORLEVEL 1 (
   GOTO 05_Carga_Auditor_1
) ELSE (
  ECHO EXECUTE O ARQUIVO 05_Carga_Auditor_1 MANUALMENTE e rode este arquivo novamente
  PAUSE>nul |set/p =PRESSIONE QUALQUER TECLA PARA SAIR ...
  EXIT
)
:05_Carga_Auditor_1
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -i %location%Database\SqlServer\05_Carga_Auditor_2.sql -b -r1 2> %location%Database\SqlServer\Logs\05_Carga_Auditor_2.txt
IF NOT ERRORLEVEL 1 (
   GOTO 05_Carga_Auditor_2
) ELSE (
  ECHO EXECUTE O ARQUIVO 05_Carga_Auditor_2 MANUALMENTE e rode este arquivo novamente
  PAUSE>nul |set/p =PRESSIONE QUALQUER TECLA PARA SAIR ...
  EXIT
)
:05_Carga_Auditor_2
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -i %location%Database\SqlServer\05_Carga_Auditor_3.sql -b -r1 2> %location%Database\SqlServer\Logs\05_Carga_Auditor_3.txt
IF NOT ERRORLEVEL 1 (
   GOTO 05_Carga_Auditor_3
) ELSE (
  ECHO EXECUTE O ARQUIVO 05_Carga_Auditor_3 MANUALMENTE e rode este arquivo novamente
  PAUSE>nul |set/p =PRESSIONE QUALQUER TECLA PARA SAIR ...
  EXIT
)
:05_Carga_Auditor_3
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -i %location%Database\SqlServer\05_Carga_Auditor_4.sql -b -r1 2> %location%Database\SqlServer\Logs\05_Carga_Auditor_4.txt
IF NOT ERRORLEVEL 1 (
   GOTO 05_Carga_Auditor_4
) ELSE (
  ECHO EXECUTE O ARQUIVO 05_Carga_Auditor_4 MANUALMENTE e rode este arquivo novamente
  PAUSE>nul |set/p =PRESSIONE QUALQUER TECLA PARA SAIR ...
  EXIT
)
:05_Carga_Auditor_4
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -i %location%Database\SqlServer\06_Estrutura_InteligenciaFiscal.sql -b -r1 2> %location%Database\SqlServer\Logs\06_Estrutura_InteligenciaFiscal.txt
IF NOT ERRORLEVEL 1 (
   GOTO 06_Estrutura_InteligenciaFiscal
) ELSE (
  ECHO EXECUTE O ARQUIVO 06_Estrutura_InteligenciaFiscal MANUALMENTE e rode este arquivo novamente
  PAUSE>nul |set/p =PRESSIONE QUALQUER TECLA PARA SAIR ...
  EXIT
)
:06_Estrutura_InteligenciaFiscal
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -i %location%Database\SqlServer\07_Carga_InteligenciaFiscal.sql -b -r1 2> %location%Database\SqlServer\Logs\07_Carga_InteligenciaFiscal.txt
IF NOT ERRORLEVEL 1 (
   GOTO 07_Carga_InteligenciaFiscal
) ELSE (
  ECHO EXECUTE O ARQUIVO 07_Carga_InteligenciaFiscal MANUALMENTE e rode este arquivo novamente
  PAUSE>nul |set/p =PRESSIONE QUALQUER TECLA PARA SAIR ...
  EXIT
)
:07_Carga_InteligenciaFiscal
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -i %location%Database\SqlServer\08_Desabilita_Regras_Auditoria_Diaria.sql -b -r1 2> %location%Database\SqlServer\Logs\08_Desabilita_Regras_Auditoria_Diaria.txt
IF NOT ERRORLEVEL 1 (
   GOTO 08_Desabilita_Regras_Auditoria_Diaria
) ELSE (
  ECHO EXECUTE O ARQUIVO 08_Desabilita_Regras_Auditoria_Diaria MANUALMENTE e rode este arquivo novamente
  PAUSE>nul |set/p =PRESSIONE QUALQUER TECLA PARA SAIR ...
  EXIT
)
:08_Desabilita_Regras_Auditoria_Diaria
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -i %location%Database\SqlServer\09_Estrutura_SaldoTerceiros.sql -b -r1 2> %location%Database\SqlServer\Logs\09_Estrutura_SaldoTerceiros.txt
IF NOT ERRORLEVEL 1 (
   GOTO 09_Estrutura_SaldoTerceiros
) ELSE (
  ECHO EXECUTE O ARQUIVO 09_Estrutura_SaldoTerceiros MANUALMENTE e rode este arquivo novamente
  PAUSE>nul |set/p =PRESSIONE QUALQUER TECLA PARA SAIR ...
  EXIT
)
:09_Estrutura_SaldoTerceiros
sqlcmd -S %ip%\%instance% -U %user% -P %password% -d %dbname% -i %location%Database\SqlServer\10_Estrutura_Gov_Cadastros.sql -b -r1 2> %location%Database\SqlServer\Logs\10_Estrutura_Gov_Cadastros.txt
IF NOT ERRORLEVEL 1 (
   PAUSE
) ELSE (
  ECHO EXECUTE O ARQUIVO 10_Estrutura_Gov_Cadastros MANUALMENTE e rode este arquivo novamente
)
PAUSE>nul |set/p =FINALIZADO PROCESSO DE EXECUCAO DOS SCRIPTS...
EXIT

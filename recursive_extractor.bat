@ECHO OFF

ECHO *************************************************************
ECHO *********     7ZIP DEVE ESTA INSTALADO    *******************
ECHO *************************************************************
PAUSE>NUL
SET PATH=%PATH%;C:\Program Files\7-Zip\
REM echo %PATH%
REM 7z
IF ERRORLEVEL 1 (
  ECHO ************   7ZIP N INSTALADO    ************************
  PAUSE>nul
)

SET /p SOURCE=LOCAL AONDE ESTAO OS ZIPS:
SET /p DEST=LOCAL QUE DEVEM IR OS ARQUIVOS EXTRAIDOS:

SET WORK=%SOURCE%\WORK
IF EXIST %WORK% GOTO unzip
MKDIR %WORK%

:unzip
PAUSE>ECHO INICIAR PROCESSO...
@ECHO ON
7z -Y e %SOURCE% -o %DEST% -r
DEL /Q /F %WORK%\*.zip
XCOPY /Y /F %DEST%\*.zip %WORK%
DEL /Q /F %DEST%\*.zip
DIR %WORK%\*.zip /A-D
IF ERRORLEVEL 1 GOTO done

:unzip2
7z -Y e %WORK% -o %DEST% -r
DEL /Q /F %WORK%\*.zip
XCOPY /Y /F %DEST%\*.zip %WORK%
DEL /Q /F %DEST%\*.zip

DIR "%WORK%\*.zip" /A-D
IF ERRORLEVEL 1 GOTO done
GOTO unzip2

:done
ECHO *************************************************************
ECHO *********  FIM DO PROCESSO               ********************
ECHO *************************************************************
PAUSE>nul

REM GOTO :EOF

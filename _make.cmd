@ECHO OFF

CALL _rm.cmd

SET PATH=%PATH%;\bin\;\bin\64tass-1.60.3243\;\bin\jdk-25.0.1\bin\;\bin\WinVICE-3.2-x86-r34842\

java -jar \bin\prog8c\prog8c-12.3.4-all.jar -asmlist -ignorefootguns -target c64 ./src/main.p8
REM java -jar \bin\prog8c\prog8c-12.3.2-library_BASICSAFE-all.jar -asmlist -ignorefootguns -target c64 ./src/main.p8
IF NOT "%ERRORLEVEL%"=="0" GOTO :END

disasm64.exe -imain.bin -omain.dis

MOVE main.bin .\build\asm

petcat -w2 -o .\build\start.prg -- .\src\start.bas

REM c1541 < .\dev\c1541.att

DIR .\build\asm

CALL _exec.cmd

:END


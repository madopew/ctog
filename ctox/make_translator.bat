@echo off
echo generating lex...
flex c_lexer.l
if %errorlevel% neq 0 exit /b %errorlevel%
echo lex generated.
echo generating parser...
bison -d c_parser.y
if %errorlevel% neq 0 exit /b %errorlevel%
echo parser generated.
echo compiling translator...
gcc -Wall -std=c11 c_parser.tab.c lex.yy.c -o translator.exe
if %errorlevel% neq 0 exit /b %errorlevel%
echo translator compiled.
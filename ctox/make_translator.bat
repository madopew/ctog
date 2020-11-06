@echo off
echo generating parser...
bison -d c_parser.y
if %errorlevel% neq 0 exit /b %errorlevel%
echo parser generated.
echo generating lex...
flex c_lexer.l
if %errorlevel% neq 0 exit /b %errorlevel%
echo lex generated.
@echo off
echo generating lex...
flex c_lexer.l
echo lex generated.
echo generating parser...
bison -d c_parser.y
echo parser generated.
echo compiling translator...
gcc -Wall -std=c11 c_parser.tab.c lex.yy.c -o translator.exe
echo translator compiled.
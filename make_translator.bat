@echo off
flex c_lexer.l
bison -d c_parser.y
gcc -Wall -std=c99 c_parser.tab.c lex.yy.c -o translator.exe
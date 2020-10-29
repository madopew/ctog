D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			([Ee][+-]?{D}+)
P           ([Pp][+-]?{D}+)
FS			(f|F|l|L)
IS          ((u|U)|(u|U)?(l|L|ll|LL)|(l|L|ll|LL)(u|U))

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "c_parser.tab.h"
%}

%option noyywrap
%option nounput

%%

#.*             {/*skip preprocessor*/}

(\/\*[^*\/]*\*\/)|(\/\/.*)      {/*skip comments*/}

"auto"			{ yylval = strdup(yytext); return AUTO; }
"_Bool"			{ yylval = strdup(yytext); return(BOOL); }
"break"			{ yylval = strdup(yytext); return BREAK; }
"case"			{ yylval = strdup(yytext); return CASE; }
"char"			{ yylval = strdup(yytext); return CHAR; }
"_Complex"		{ yylval = strdup(yytext); return(COMPLEX); }
"const"			{ yylval = strdup(yytext); return CONST; }
"continue"		{ yylval = strdup(yytext); return CONTINUE; }
"default"		{ yylval = strdup(yytext); return DEFAULT; }
"do"			{ yylval = strdup(yytext); return DO; }
"double"		{ yylval = strdup(yytext); return DOUBLE; }
"else"			{ yylval = strdup(yytext); return ELSE; }
"enum"			{ yylval = strdup(yytext); return ENUM; }
"extern"		{ yylval = strdup(yytext); return EXTERN; }
"float"			{ yylval = strdup(yytext); return FLOAT; }
"for"			{ yylval = strdup(yytext); return FOR; }
"goto"			{ yylval = strdup(yytext); return GOTO; }
"if"			{ yylval = strdup(yytext); return IF; }
"_Imaginary"	{ yylval = strdup(yytext); return(IMAGINARY); }
"inline"		{ yylval = strdup(yytext); return(INLINE); }
"int"			{ yylval = strdup(yytext); return INT; }
"long"			{ yylval = strdup(yytext); return LONG; }
"register"		{ yylval = strdup(yytext); return REGISTER; }
"restrict"		{ yylval = strdup(yytext); return(RESTRICT); }
"return"		{ yylval = strdup(yytext); return RETURN; }
"short"			{ yylval = strdup(yytext); return SHORT; }
"signed"		{ yylval = strdup(yytext); return SIGNED; }
"sizeof"		{ yylval = strdup(yytext); return SIZEOF; }
"static"		{ yylval = strdup(yytext); return STATIC; }
"struct"		{ yylval = strdup(yytext); return STRUCT; }
"switch"		{ yylval = strdup(yytext); return SWITCH; }
"typedef"		{ yylval = strdup(yytext); return TYPEDEF; }
"union"			{ yylval = strdup(yytext); return UNION; }
"unsigned"		{ yylval = strdup(yytext); return UNSIGNED; }
"void"			{ yylval = strdup(yytext); return VOID; }
"volatile"		{ yylval = strdup(yytext); return VOLATILE; }
"while"			{ yylval = strdup(yytext); return WHILE; }

{L}({L}|{D})*		{ yylval = strdup(yytext); return IDENTIFIER; }

0[xX]{H}+{IS}?		        { yylval = strdup(yytext); return CONSTANT; }
0[0-7]*{IS}?		        { yylval = strdup(yytext); return CONSTANT; }
[1-9]{D}*{IS}?		        { yylval = strdup(yytext); return CONSTANT; }
L?'(\\.|[^\\'\n])+'	        { yylval = strdup(yytext); return CONSTANT; }
{D}+{E}{FS}?		        { yylval = strdup(yytext); return CONSTANT; }
{D}*"."{D}+{E}?{FS}?	    { yylval = strdup(yytext); return CONSTANT; }
{D}+"."{D}*{E}?{FS}?	    { yylval = strdup(yytext); return CONSTANT; }
0[xX]{H}+{P}{FS}?	        { yylval = strdup(yytext); return CONSTANT; }
0[xX]{H}*"."{H}+{P}{FS}?    { yylval = strdup(yytext); return CONSTANT; }
0[xX]{H}+"."{H}*{P}{FS}?    { yylval = strdup(yytext); return CONSTANT; }
L?\"(\\.|[^\\"\n])*\"	    { yylval = strdup(yytext); return STRING_LITERAL; }

"..."			{ yylval = strdup(yytext); return ELLIPSIS; }
">>="			{ yylval = strdup(yytext); return RIGHT_ASSIGN; }
"<<="			{ yylval = strdup(yytext); return LEFT_ASSIGN; }
"+="			{ yylval = strdup(yytext); return ADD_ASSIGN; }
"-="			{ yylval = strdup(yytext); return SUB_ASSIGN; }
"*="			{ yylval = strdup(yytext); return MUL_ASSIGN; }
"/="			{ yylval = strdup(yytext); return DIV_ASSIGN; }
"%="			{ yylval = strdup(yytext); return MOD_ASSIGN; }
"&="			{ yylval = strdup(yytext); return AND_ASSIGN; }
"^="			{ yylval = strdup(yytext); return XOR_ASSIGN; }
"|="			{ yylval = strdup(yytext); return OR_ASSIGN; }
">>"			{ yylval = strdup(yytext); return RIGHT_OP; }
"<<"			{ yylval = strdup(yytext); return LEFT_OP; }
"++"			{ yylval = strdup(yytext); return INC_OP; }
"--"			{ yylval = strdup(yytext); return DEC_OP; }
"->"			{ yylval = strdup(yytext); return PTR_OP; }
"&&"			{ yylval = strdup(yytext); return AND_OP; }
"||"			{ yylval = strdup(yytext); return OR_OP; }
"<="			{ yylval = strdup(yytext); return LE_OP; }
">="			{ yylval = strdup(yytext); return GE_OP; }
"=="			{ yylval = strdup(yytext); return EQ_OP; }
"!="			{ yylval = strdup(yytext); return NE_OP; }
";"			    { return ';'; }
"{"		        { return '{'; }
"}"		        { return '}'; }
","			    { return ','; }
":"			    { return ':'; }
"="			    { return '='; }
"("			    { return '('; }
")"			    { return ')'; }
"["		        { return '['; }
"]"     		{ return ']'; }
"."			    { return '.'; }
"&"			    { return '&'; }
"!"			    { return '!'; }
"~"			    { return '~'; }
"-"			    { return '-'; }
"+"		    	{ return '+'; }
"*"		    	{ return '*'; }
"/"		    	{ return '/'; }
"%"		    	{ return '%'; }
"<"		    	{ return '<'; }
">"		    	{ return '>'; }
"^"		    	{ return '^'; }
"|"			    { return '|'; }
"?"			    { return '?'; }

[ \t\v\n\f]		{ /* ignore white spaces */  }
.			    { /* ignore bad chars */ }

%%
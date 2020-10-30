%e  1019
%p  2807
%n  371
%k  284
%a  1213
%o  1117

O   [0-7]
D   [0-9]
NZ  [1-9]
L   [a-zA-Z_]
A   [a-zA-Z_0-9]
H   [a-fA-F0-9]
HP  (0[xX])
E   ([Ee][+-]?{D}+)
P   ([Pp][+-]?{D}+)
FS  (f|F|l|L)
IS  (((u|U)(l|L|ll|LL)?)|((l|L|ll|LL)(u|U)?))
CP  (u|U|L)
SP  (u8|u|U|L)
ES  (\\(['"\?\\abfnrtv]|[0-7]{1,3}|x[a-fA-F0-9]+))
WS  [ \t\v\n\f]

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "c_parser.tab.h"

extern void yyerror(const char *);
static void comment(void);

#define COPYVALUE yylval = strdup(yytext)
%}

%option noyywrap
%option nounput

%%

#.*             {/*skip preprocessor*/}

"/*"            {comment();}
"//".*          {/* consume // comment*/}

"auto"			{ COPYVALUE; return AUTO; }
"break"			{ COPYVALUE; return BREAK; }
"case"			{ COPYVALUE; return CASE; }
"char"			{ COPYVALUE; return CHAR; }
"const"			{ COPYVALUE; return CONST; }
"continue"		{ COPYVALUE; return CONTINUE; }
"default"		{ COPYVALUE; return DEFAULT; }
"do"			{ COPYVALUE; return DO; }
"double"		{ COPYVALUE; return DOUBLE; }
"else"			{ COPYVALUE; return ELSE; }
"enum"			{ COPYVALUE; return ENUM; }
"extern"		{ COPYVALUE; return EXTERN; }
"float"			{ COPYVALUE; return FLOAT; }
"for"			{ COPYVALUE; return FOR; }
"goto"			{ COPYVALUE; return GOTO; }
"if"			{ COPYVALUE; return IF; }
"inline"		{ COPYVALUE; return INLINE; }
"int"			{ COPYVALUE; return INT; }
"long"			{ COPYVALUE; return LONG; }
"register"		{ COPYVALUE; return REGISTER; }
"restrict"		{ COPYVALUE; return RESTRICT; }
"return"		{ COPYVALUE; return RETURN; }
"short"			{ COPYVALUE; return SHORT; }
"signed"		{ COPYVALUE; return SIGNED; }
"sizeof"		{ COPYVALUE; return SIZEOF; }
"static"		{ COPYVALUE; return STATIC; }
"struct"		{ COPYVALUE; return STRUCT; }
"switch"		{ COPYVALUE; return SWITCH; }
"typedef"		{ COPYVALUE; return TYPEDEF; }
"union"			{ COPYVALUE; return UNION; }
"unsigned"		{ COPYVALUE; return UNSIGNED; }
"void"			{ COPYVALUE; return VOID; }
"volatile"		{ COPYVALUE; return VOLATILE; }
"while"			{ COPYVALUE; return WHILE; }
"_Alignas"      { COPYVALUE; return ALIGNAS; }
"_Alignof"      { COPYVALUE; return ALIGNOF; }
"_Atomic"       { COPYVALUE; return ATOMIC; }
"_Bool"			{ COPYVALUE; return BOOL; }
"_Complex"		{ COPYVALUE; return COMPLEX; }
"_Generic"      { COPYVALUE; return GENERIC; }
"_Imaginary"	{ COPYVALUE; return IMAGINARY; }
"_Noreturn"     { COPYVALUE; return NORETURN; }
"_Static_assert" { COPYVALUE; return STATIC_ASSERT; }
"_Thread_local" { COPYVALUE; return THREAD_LOCAL; }
"__func__"      { COPYVALUE; return FUNC_NAME; }

{L}{A}*					            { COPYVALUE; return IDENTIFIER; }
{HP}{H}+{IS}?				        { COPYVALUE; return I_CONSTANT; }
{NZ}{D}*{IS}?				        { COPYVALUE; return I_CONSTANT; }
"0"{O}*{IS}?				        { COPYVALUE; return I_CONSTANT; }
{CP}?"'"([^'\\\n]|{ES})+"'"		    { COPYVALUE; return I_CONSTANT; }
{D}+{E}{FS}?				        { COPYVALUE; return F_CONSTANT; }
{D}*"."{D}+{E}?{FS}?			    { COPYVALUE; return F_CONSTANT; }
{D}+"."{E}?{FS}?			        { COPYVALUE; return F_CONSTANT; }
{HP}{H}+{P}{FS}?			        { COPYVALUE; return F_CONSTANT; }
{HP}{H}*"."{H}+{P}{FS}?			    { COPYVALUE; return F_CONSTANT; }
{HP}{H}+"."{P}{FS}?			        { COPYVALUE; return F_CONSTANT; }
({SP}?\"([^"\\\n]|{ES})*\"{WS}*)+	{ COPYVALUE; return STRING_LITERAL; }

"..."			{ COPYVALUE; return ELLIPSIS; }
">>="			{ COPYVALUE; return RIGHT_ASSIGN; }
"<<="			{ COPYVALUE; return LEFT_ASSIGN; }
"+="			{ COPYVALUE; return ADD_ASSIGN; }
"-="			{ COPYVALUE; return SUB_ASSIGN; }
"*="			{ COPYVALUE; return MUL_ASSIGN; }
"/="			{ COPYVALUE; return DIV_ASSIGN; }
"%="			{ COPYVALUE; return MOD_ASSIGN; }
"&="			{ COPYVALUE; return AND_ASSIGN; }
"^="			{ COPYVALUE; return XOR_ASSIGN; }
"|="			{ COPYVALUE; return OR_ASSIGN; }
">>"			{ COPYVALUE; return RIGHT_OP; }
"<<"			{ COPYVALUE; return LEFT_OP; }
"++"			{ COPYVALUE; return INC_OP; }
"--"			{ COPYVALUE; return DEC_OP; }
"->"			{ COPYVALUE; return PTR_OP; }
"&&"			{ COPYVALUE; return AND_OP; }
"||"			{ COPYVALUE; return OR_OP; }
"<="			{ COPYVALUE; return LE_OP; }
">="			{ COPYVALUE; return GE_OP; }
"=="			{ COPYVALUE; return EQ_OP; }
"!="			{ COPYVALUE; return NE_OP; }
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

{WS}+		    { /* ignore white spaces */  }
.			    { /* discard bad chars */ }

%%

static void comment(void)
{
    int c;
    while ((c = input()) != 0)
        if (c == '*')
        {
            while ((c = input()) == '*')
                ;

            if (c == '/')
                return;

            if (c == 0)
                break;
        }
    yyerror("unterminated comment");
}
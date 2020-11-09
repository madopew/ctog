%define api.value.type {char *}

%token 	IDENTIFIER I_CONSTANT F_CONSTANT STRING_LITERAL FUNC_NAME SIZEOF
%token	PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token	AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token	SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token	XOR_ASSIGN OR_ASSIGN

%token	TYPEDEF EXTERN STATIC AUTO REGISTER INLINE
%token	CONST RESTRICT VOLATILE
%token	BOOL CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE VOID
%token	COMPLEX IMAGINARY 
%token	STRUCT UNION ENUM ELLIPSIS

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%token	ALIGNAS ALIGNOF ATOMIC GENERIC NORETURN STATIC_ASSERT THREAD_LOCAL

%expect 2

%start program_unit

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

extern int yylineno;

int yylex();
void yyerror(char *);

char *concatn(int n, ...);
void freen(int n, ...);
char *createfunc(char *, char *, char *);
void addfunccall(char *, char *);
char *createexp(char *);
char *createdecl(char *);
char *createifelse(char *, char *, char *);
char *createswitch(char *, char *);
char *createcycle(int, char *, char *);

char *currentcalls = NULL;

#define EXPS "<expression"
#define EXPE "</expression>"
#define HASC "hascalls = \"true\">"
#define DHAC "hascalls = \"false\">"
#define TEXS "<text>"
#define TEXE "</text>"

#define DECS "<declaration"
#define DECE "</declaration>"

#define FUNS "<function>"
#define FUNE "</function>"
#define PROS "<prototype>"
#define PROE "</prototype>"
#define BODS "<body>"
#define BODE "</body>"
#define NBOD "<body/>"

#define CALS "<funccall>"
#define CALE "</funccall>"
#define NAMS "<name>"
#define NAME "</name>"
#define ARGS "<arguments>"
#define ARGE "</arguments>"
#define NARG "<arguments/>"

#define IFSS "<if>"
#define IFSE "</if>"
#define CONS "<condition>"
#define CONE "</condition>"
#define IFBS "<ifbody>"
#define IFBE "</ifbody>"
#define NIFB "<ifbody/>"
#define ELBS "<elsebody>"
#define ELBE "</elsebody>"
#define NELB "<elsebody/>"

#define SWIS "<switch>"
#define SWIE "</switch>"
#define LABS "<labelstatement>"
#define LABE "</labelstatement>"

#define GOTS "<goto>"
#define GOTE "</gote>"
#define CONT "<continue/>"
#define BREA "<break/>"
#define RETS "<return>"
#define RETE "</return>"
#define NRET "<return/>"

#define CYCS "<cycle"
#define PREC "pre = \"true\">"
#define POSC "pre = \"false\">"
#define CYCE "</cycle>"
%}

%locations

%%

primary_expression
	: IDENTIFIER 			{$$ = concatn(1, $1); free($1);}		
	| constant 				{$$ = concatn(1, $1); free($1);}
	| string 				{$$ = concatn(1, $1); free($1);}
	| '(' expression ')'	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| generic_selection		{$$ = concatn(1, $1); free($1);}
	;

constant
	: I_CONSTANT		{ $$ = concatn(1, $1); free($1);}	
	| F_CONSTANT		{ $$ = concatn(1, $1); free($1);}
	;

string
	: STRING_LITERAL	{ $$ = concatn(1, $1); free($1);}
	| FUNC_NAME			{ $$ = concatn(1, $1); free($1);}
	;

generic_selection
	: GENERIC '(' assignment_expression ',' generic_assoc_list ')'	{$$ = concatn(6, $1, $2, $3, $4, $5, $6); freen(6, $1, $2, $3, $4, $5, $6);}
	;

generic_assoc_list
	: generic_association							{$$ = concatn(1, $1); free($1);}
	| generic_assoc_list ',' generic_association	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

generic_association
	: type_name ':' assignment_expression			{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| DEFAULT ':' assignment_expression				{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

postfix_expression
	: primary_expression                                    {$$ = concatn(1, $1); free($1);}
	| postfix_expression '[' expression ']'					{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| postfix_expression '(' ')'							{$$ = concatn(3, $1, $2, $3); addfunccall($1, NULL); freen(3, $1, $2, $3);}
	| postfix_expression '(' argument_expression_list ')'	{$$ = concatn(4, $1, $2, $3, $4); addfunccall($1, $3); freen(4, $1, $2, $3, $4);}
	| postfix_expression '.' IDENTIFIER						{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| postfix_expression PTR_OP IDENTIFIER					{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| postfix_expression INC_OP								{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| postfix_expression DEC_OP								{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| '(' type_name ')' '{' initializer_list '}'			{$$ = concatn(6, $1, $2, $3, $4, $5, $6); freen(6, $1, $2, $3, $4, $5, $6);}
	| '(' type_name ')' '{' initializer_list ',' '}'		{$$ = concatn(7, $1, $2, $3, $4, $5, $6, $7); freen(7, $1, $2, $3, $4, $5, $6, $7);}
	;

argument_expression_list
	: assignment_expression									{$$ = concatn(1, $1); free($1);}
	| argument_expression_list ',' assignment_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

unary_expression
	: postfix_expression				{$$ = concatn(1, $1); free($1);}
	| INC_OP unary_expression			{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| DEC_OP unary_expression			{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| unary_operator cast_expression	{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| SIZEOF unary_expression			{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| SIZEOF '(' type_name ')'			{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| ALIGNOF '(' type_name ')'			{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	;

unary_operator
	: '&'	{ $$ = concatn(1, $1); free($1);}
	| '*' 	{ $$ = concatn(1, $1); free($1);}
	| '+' 	{ $$ = concatn(1, $1); free($1);}
	| '-' 	{ $$ = concatn(1, $1); free($1);}
	| '~' 	{ $$ = concatn(1, $1); free($1);}
	| '!' 	{ $$ = concatn(1, $1); free($1);}
	;

cast_expression
	: unary_expression						{$$ = concatn(1, $1); free($1);}
	| '(' type_name ')' cast_expression		{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	;

multiplicative_expression
	: cast_expression									{$$ = concatn(1, $1); free($1);}
	| multiplicative_expression '*' cast_expression		{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| multiplicative_expression '/' cast_expression		{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| multiplicative_expression '%' cast_expression		{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

additive_expression
	: multiplicative_expression								{$$ = concatn(1, $1); free($1);}
	| additive_expression '+' multiplicative_expression		{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| additive_expression '-' multiplicative_expression		{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

shift_expression
	: additive_expression								{ $$ = concatn(1, $1); free($1);}
	| shift_expression LEFT_OP additive_expression		{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| shift_expression RIGHT_OP additive_expression		{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

relational_expression
	: shift_expression								{ $$ = concatn(1, $1); free($1);}
	| relational_expression '<' shift_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| relational_expression '>' shift_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| relational_expression LE_OP shift_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| relational_expression GE_OP shift_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

equality_expression
	: relational_expression								{ $$ = concatn(1, $1); free($1);}
	| equality_expression EQ_OP relational_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| equality_expression NE_OP relational_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

and_expression
	: equality_expression						{ $$ = concatn(1, $1); free($1);}
	| and_expression '&' equality_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

exclusive_or_expression
	: and_expression								{ $$ = concatn(1, $1); free($1);}
	| exclusive_or_expression '^' and_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

inclusive_or_expression
	: exclusive_or_expression								{ $$ = concatn(1, $1); free($1);}
	| inclusive_or_expression '|' exclusive_or_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

logical_and_expression
	: inclusive_or_expression									{ $$ = concatn(1, $1); free($1);}
	| logical_and_expression AND_OP inclusive_or_expression		{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

logical_or_expression
	: logical_and_expression								{ $$ = concatn(1, $1); free($1);}
	| logical_or_expression OR_OP logical_and_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

conditional_expression
	: logical_or_expression												{ $$ = concatn(1, $1); free($1);}
	| logical_or_expression '?' expression ':' conditional_expression	{$$ = concatn(5, $1, $2, $3, $4, $5); freen(5, $1, $2, $3, $4, $5);}
	;

assignment_expression
	: conditional_expression										{ $$ = concatn(1, $1); free($1);}
	| unary_expression assignment_operator assignment_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

assignment_operator
	: '='			{ $$ = concatn(1, $1); free($1);}
	| MUL_ASSIGN	{ $$ = concatn(1, $1); free($1);}
	| DIV_ASSIGN	{ $$ = concatn(1, $1); free($1);}
	| MOD_ASSIGN	{ $$ = concatn(1, $1); free($1);}
	| ADD_ASSIGN	{ $$ = concatn(1, $1); free($1);}
	| SUB_ASSIGN	{ $$ = concatn(1, $1); free($1);}
	| LEFT_ASSIGN	{ $$ = concatn(1, $1); free($1);}
	| RIGHT_ASSIGN	{ $$ = concatn(1, $1); free($1);}
	| AND_ASSIGN	{ $$ = concatn(1, $1); free($1);}
	| XOR_ASSIGN	{ $$ = concatn(1, $1); free($1);}
	| OR_ASSIGN		{ $$ = concatn(1, $1); free($1);}
	;

expression
	: assignment_expression					{ $$ = concatn(1, $1); free($1);}
	| expression ',' assignment_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

constant_expression
	: conditional_expression	{ $$ = concatn(1, $1); free($1);}
	;

declaration
	: declaration_specifiers ';'						{$$ = concatn(1, $1); freen(2, $1, $2);}
	| declaration_specifiers init_declarator_list ';'	{$$ = concatn(2, $1, $2); freen(3, $1, $2, $3);}
	| static_assert_declaration							{ $$ = concatn(1, $1); free($1);}
	;

declaration_specifiers
	: storage_class_specifier declaration_specifiers	{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| storage_class_specifier							{ $$ = concatn(1, $1); free($1);}
	| type_specifier declaration_specifiers				{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| type_specifier									{ $$ = concatn(1, $1); free($1);}
	| type_qualifier declaration_specifiers				{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| type_qualifier									{ $$ = concatn(1, $1); free($1);}
	| function_specifier declaration_specifiers			{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| function_specifier								{ $$ = concatn(1, $1); free($1);}
	| alignment_specifier declaration_specifiers		{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| alignment_specifier								{$$ = concatn(1, $1); free($1);}
	;

init_declarator_list
	: init_declarator								{ $$ = concatn(1, $1); free($1);}	
	| init_declarator_list ',' init_declarator		{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

init_declarator
	: declarator '=' initializer	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| declarator					{ $$ = concatn(1, $1); free($1);}		
	;

storage_class_specifier
	: TYPEDEF		{ $$ = concatn(1, $1); free($1);}
	| EXTERN		{ $$ = concatn(1, $1); free($1);}
	| STATIC		{ $$ = concatn(1, $1); free($1);}
	| THREAD_LOCAL  { $$ = concatn(1, $1); free($1);}
	| AUTO			{ $$ = concatn(1, $1); free($1);}
	| REGISTER		{ $$ = concatn(1, $1); free($1);}
	;

type_specifier
	: VOID							{ $$ = concatn(1, $1); free($1);}
	| CHAR							{ $$ = concatn(1, $1); free($1);}
	| SHORT							{ $$ = concatn(1, $1); free($1);}
	| INT							{ $$ = concatn(1, $1); free($1);}
	| LONG							{ $$ = concatn(1, $1); free($1);}
	| FLOAT							{ $$ = concatn(1, $1); free($1);}
	| DOUBLE						{ $$ = concatn(1, $1); free($1);}
	| SIGNED						{ $$ = concatn(1, $1); free($1);}
	| UNSIGNED						{ $$ = concatn(1, $1); free($1);}
	| BOOL							{ $$ = concatn(1, $1); free($1);}
	| COMPLEX						{ $$ = concatn(1, $1); free($1);}
	| IMAGINARY						{ $$ = concatn(1, $1); free($1);}
	| atomic_type_specifier			{ $$ = concatn(1, $1); free($1);}
	| struct_or_union_specifier		{ $$ = concatn(1, $1); free($1);}
	| enum_specifier				{ $$ = concatn(1, $1); free($1);}
	;

struct_or_union_specifier
	: struct_or_union '{' struct_declaration_list '}'				{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| struct_or_union IDENTIFIER '{' struct_declaration_list '}'	{$$ = concatn(5, $1, $2, $3, $4, $5); freen(5, $1, $2, $3, $4, $5);}
	| struct_or_union IDENTIFIER									{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	;

struct_or_union
	: STRUCT	{ $$ = concatn(1, $1); free($1);}
	| UNION		{ $$ = concatn(1, $1); free($1);}
	;

struct_declaration_list
	: struct_declaration							{ $$ = concatn(1, $1); free($1);}
	| struct_declaration_list struct_declaration	{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	;

struct_declaration
	: specifier_qualifier_list ';'							{$$ = concatn(1, $1); freen(2, $1, $2);}
	| specifier_qualifier_list struct_declarator_list ';'	{$$ = concatn(2, $1, $2); freen(3, $1, $2, $3);}
	| static_assert_declaration								{ $$ = concatn(1, $1); free($1);}
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list		{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| type_specifier								{ $$ = concatn(1, $1); free($1);}
	| type_qualifier specifier_qualifier_list		{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| type_qualifier								{ $$ = concatn(1, $1); free($1);}
	;

struct_declarator_list
	: struct_declarator								{ $$ = concatn(1, $1); free($1);}
	| struct_declarator_list ',' struct_declarator	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

struct_declarator							
	: ':' constant_expression				{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| declarator ':' constant_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| declarator							{ $$ = concatn(1, $1); free($1);}
	;

enum_specifier
	: ENUM '{' enumerator_list '}'					{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| ENUM '{' enumerator_list ',' '}'				{$$ = concatn(5, $1, $2, $3, $4, $5); freen(5, $1, $2, $3, $4, $5);}
	| ENUM IDENTIFIER '{' enumerator_list '}'		{$$ = concatn(5, $1, $2, $3, $4, $5); freen(5, $1, $2, $3, $4, $5);}
	| ENUM IDENTIFIER '{' enumerator_list ',' '}'	{$$ = concatn(6, $1, $2, $3, $4, $5, $6); freen(6, $1, $2, $3, $4, $5, $6);}
	| ENUM IDENTIFIER								{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	;

enumerator_list
	: enumerator						{ $$ = concatn(1, $1); free($1);}
	| enumerator_list ',' enumerator	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

enumerator
	: IDENTIFIER '=' constant_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| IDENTIFIER							{ $$ = concatn(1, $1); free($1);}
	;

atomic_type_specifier
	: ATOMIC '(' type_name ')'				{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	;

type_qualifier
	: CONST			{ $$ = concatn(1, $1); free($1);}
	| RESTRICT		{ $$ = concatn(1, $1); free($1);}
	| VOLATILE		{ $$ = concatn(1, $1); free($1);}
	| ATOMIC		{ $$ = concatn(1, $1); free($1);}
	;

function_specifier
	: INLINE		{ $$ = concatn(1, $1); free($1);}
	| NORETURN		{ $$ = concatn(1, $1); free($1);}
	;

alignment_specifier
	: ALIGNAS '(' type_name ')'				{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| ALIGNAS '(' constant_expression ')'	{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	;

declarator
	: pointer direct_declarator		{$$ = concatn(2, $1, $2); freen(2, $1, $2);}	
	| direct_declarator				{ $$ = concatn(1, $1); free($1);}
	;


direct_declarator
	: IDENTIFIER																	{ $$ = concatn(1, $1); free($1);}
	| '(' declarator ')'															{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| direct_declarator '[' ']'														{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| direct_declarator '[' '*' ']'													{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| direct_declarator '[' STATIC type_qualifier_list assignment_expression ']'	{$$ = concatn(6, $1, $2, $3, $4, $5, $6); freen(6, $1, $2, $3, $4, $5, $6);}
	| direct_declarator '[' STATIC assignment_expression ']'						{$$ = concatn(5, $1, $2, $3, $4, $5); freen(5, $1, $2, $3, $4, $5);}
	| direct_declarator '[' type_qualifier_list '*' ']'								{$$ = concatn(5, $1, $2, $3, $4, $5); freen(5, $1, $2, $3, $4, $5);}
	| direct_declarator '[' type_qualifier_list STATIC assignment_expression ']'	{$$ = concatn(6, $1, $2, $3, $4, $5, $6); freen(6, $1, $2, $3, $4, $5, $6);}
	| direct_declarator '[' type_qualifier_list assignment_expression ']'			{$$ = concatn(5, $1, $2, $3, $4, $5); freen(5, $1, $2, $3, $4, $5);}
	| direct_declarator '[' type_qualifier_list ']'									{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| direct_declarator '[' assignment_expression ']'								{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| direct_declarator '(' parameter_type_list ')'									{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| direct_declarator '(' ')'														{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| direct_declarator '(' identifier_list ')'										{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	;

pointer
	: '*' type_qualifier_list pointer   {$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| '*' type_qualifier_list           {$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| '*' pointer                       {$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| '*'                               {$$ = concatn(1, $1); free($1);}
	;

type_qualifier_list
	: type_qualifier                        { $$ = concatn(1, $1); free($1);}
	| type_qualifier_list type_qualifier	{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	;


parameter_type_list
	: parameter_list ',' ELLIPSIS	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| parameter_list				{ $$ = concatn(1, $1); free($1);}
	;

parameter_list
	: parameter_declaration						{ $$ = concatn(1, $1); free($1);}
	| parameter_list ',' parameter_declaration	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

parameter_declaration
	: declaration_specifiers declarator				{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| declaration_specifiers abstract_declarator	{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| declaration_specifiers						{ $$ = concatn(1, $1); free($1);}
	;

identifier_list
	: IDENTIFIER						{ $$ = concatn(1, $1); free($1);}
	| identifier_list ',' IDENTIFIER	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

type_name
	: specifier_qualifier_list abstract_declarator	{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| specifier_qualifier_list						{ $$ = concatn(1, $1); free($1);}
	;

abstract_declarator
	: pointer direct_abstract_declarator	{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| pointer								{ $$ = concatn(1, $1); free($1);}
	| direct_abstract_declarator			{ $$ = concatn(1, $1); free($1);}
	;

direct_abstract_declarator	
	: '(' abstract_declarator ')'																{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| '[' ']'																					{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| '[' '*' ']'																				{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| '[' STATIC type_qualifier_list assignment_expression ']'									{$$ = concatn(5, $1, $2, $3, $4, $5); freen(5, $1, $2, $3, $4, $5);}
	| '[' STATIC assignment_expression ']'														{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| '[' type_qualifier_list STATIC assignment_expression ']'									{$$ = concatn(5, $1, $2, $3, $4, $5); freen(5, $1, $2, $3, $4, $5);}
	| '[' type_qualifier_list assignment_expression ']'											{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| '[' type_qualifier_list ']'																{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| '[' assignment_expression ']'																{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| direct_abstract_declarator '[' ']'														{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| direct_abstract_declarator '[' '*' ']'													{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| direct_abstract_declarator '[' STATIC type_qualifier_list assignment_expression ']'		{$$ = concatn(6, $1, $2, $3, $4, $5, $6); freen(6, $1, $2, $3, $4, $5, $6);}
	| direct_abstract_declarator '[' STATIC assignment_expression ']'							{$$ = concatn(5, $1, $2, $3, $4, $5); freen(5, $1, $2, $3, $4, $5);}
	| direct_abstract_declarator '[' type_qualifier_list assignment_expression ']'				{$$ = concatn(5, $1, $2, $3, $4, $5); freen(5, $1, $2, $3, $4, $5);}
	| direct_abstract_declarator '[' type_qualifier_list STATIC assignment_expression ']'		{$$ = concatn(6, $1, $2, $3, $4, $5, $6); freen(6, $1, $2, $3, $4, $5, $6);}
	| direct_abstract_declarator '[' type_qualifier_list ']'									{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| direct_abstract_declarator '[' assignment_expression ']'									{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| '(' ')'																					{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| '(' parameter_type_list ')'																{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| direct_abstract_declarator '(' ')'														{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| direct_abstract_declarator '(' parameter_type_list ')'									{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	;

initializer
	: '{' initializer_list '}'			{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| '{' initializer_list ',' '}'		{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| assignment_expression				{$$ = concatn(1, $1);free($1);}
	;

initializer_list
	: designation initializer						{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| initializer									{$$ = concatn(1, $1); free($1);}
	| initializer_list ',' designation initializer	{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| initializer_list ',' initializer				{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

designation
	: designator_list '='							{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	;

designator_list
	: designator							{$$ = concatn(1, $1); free($1);}
	| designator_list designator			{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	;

designator
	: '[' constant_expression ']'		{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| '.' IDENTIFIER					{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	;

static_assert_declaration
	: STATIC_ASSERT '(' constant_expression ',' STRING_LITERAL ')' ';' {$$ = concatn(6, $1, $2, $3, $4, $5, $6);freen(7, $1, $2, $3, $4, $5, $6, $7);}
	;

statement
	: labeled_statement			{ $$ = concatn(1, $1); free($1);}
	| compound_statement        { $$ = concatn(1, $1); free($1);}
	| expression_statement      {$$ = createexp($1); free($1);}
	| selection_statement       { $$ = concatn(1, $1); free($1);}
	| iteration_statement		{$$ = concatn(1, $1); free($1);}
	| jump_statement			{ $$ = concatn(1, $1); free($1);}
	;

labeled_statement
	: IDENTIFIER ':' statement					{$$ = concatn(4, LABS, $1, LABE, $3); freen(3, $1, $2, $3);}								
	| CASE constant_expression ':' statement	{$$ = concatn(4, LABS, $2, LABE, $4); freen(4, $1, $2, $3, $4);}
	| DEFAULT ':' statement						{$$ = concatn(4, LABS, $1, LABE, $3); freen(3, $1, $2, $3);}
	;

compound_statement  
	: '{' '}'                       {$$ = concatn(1, ""); freen(2, $1, $2);}
	| '{' block_item_list '}'       {$$ = concatn(1, $2); freen(3, $1, $2, $3);}
	;

block_item_list
	: block_item                    { $$ = concatn(1, $1); free($1);}
	| block_item_list block_item    {$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	;

block_item
	: declaration   { $$ = createdecl($1); free($1);}
	| statement     { $$ = concatn(1, $1); free($1);}
	;

expression_statement
	: ';'				{$$ = concatn(1, ""); free($1);}
	| expression ';'	{ $$ = concatn(1, $1); freen(2, $1, $2);}
	;

selection_statement
	: IF '(' expression ')' statement ELSE statement 	{$$ = createifelse($3, $5, $7); freen(7, $1, $2, $3, $4, $5, $6, $7);}
	| IF '(' expression ')' statement					{$$ = createifelse($3, $5, NULL); freen(5, $1, $2, $3, $4, $5);}
	| SWITCH '(' expression ')' statement				{$$ = createswitch($3, $5); freen(5, $1, $2, $3, $4, $5);}
	;

iteration_statement
	: WHILE '(' expression ')' statement											{$$ = createcycle(1, $3, $5); freen(5, $1, $2, $3, $4, $5);}
	| DO statement WHILE '(' expression ')' ';'										{$$ = createcycle(0, $5, $2); freen(7, $1, $2, $3, $4, $5, $6, $7);}
	| FOR '(' expression_statement expression_statement ')' statement				{char *cond = concatn(4, $3, ";", $4, ";"); $$ = createcycle(1, cond, $6); freen(7, $1, $2, $3, $4, $5, $6, cond);}
	| FOR '(' expression_statement expression_statement expression ')' statement	{char *cond = concatn(5, $3, ";", $4, ";", $5); $$ = createcycle(1, cond, $7); freen(8, $1, $2, $3, $4, $5, $6, $7, cond);}
	| FOR '(' declaration expression_statement ')' statement						{char *cond = concatn(4, $3, ";", $4, ";"); $$ = createcycle(1, cond, $6); freen(7, $1, $2, $3, $4, $5, $6, cond);}
	| FOR '(' declaration expression_statement expression ')' statement				{char *cond = concatn(5, $3, ";", $4, ";", $5); $$ = createcycle(1, cond, $7); freen(8, $1, $2, $3, $4, $5, $6, $7, cond);}
	;

jump_statement
	: GOTO IDENTIFIER ';'		{$$ = concatn(3, GOTS, $2, GOTE); freen(3, $1, $2, $3);}
	| CONTINUE ';'				{$$ = concatn(1, CONT); freen(2, $1, $2);}
	| BREAK ';'					{$$ = concatn(1, BREA); freen(2, $1, $2);}
	| RETURN ';'				{$$ = concatn(1, NRET); freen(2, $1, $2);}
	| RETURN expression ';'		{$$ = concatn(3, RETS, $2, RETE); freen(3, $1, $2, $3);}
	;

program_unit
	: translation_unit		{fprintf(stderr, "%s\n", "no error occurred");$$ = concatn(3, "<program>", $1, "</program>");printf("%s", $$); freen(2, $1, $$);}
	;

translation_unit
	: external_declaration						{$$ = concatn(1, $1); free($1);}
	| translation_unit external_declaration		{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	;

external_declaration
	: function_definition	{ $$ = concatn(1, $1); free($1);}
	| declaration			{ $$ = createdecl($1); free($1);}
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement		
	| declaration_specifiers declarator compound_statement      				{$$ = createfunc($1, $2, $3); freen(3, $1, $2, $3);}            
	;

declaration_list
	: declaration						{$$ = createdecl($1);free($1);}
	| declaration_list declaration		{$$ = concatn(4, $1, DECS, $2, DECE); freen(2, $1, $2);}
	;

%%

char *createcycle(int precondition, char *condition, char *body) {
	char *toreturn;
	if(strlen(body) > 0) {
		if(precondition)
			toreturn = concatn(9, CYCS, PREC, CONS, condition, CONE, BODS, body, BODE, CYCE);
		else
			toreturn = concatn(9, CYCS, POSC, CONS, condition, CONE, BODS, body, BODE, CYCE);
	} else {
		if(precondition)
			toreturn = concatn(7, CYCS, PREC, CONS, condition, CONE, NBOD, CYCE);
		else
			toreturn = concatn(7, CYCS, POSC, CONS, condition, CONE, NBOD, CYCE);
	}
	return toreturn;
}

char *createswitch(char *condition, char *body) {
	return concatn(6, SWIS, CONS, condition, CONE, body, SWIE);
}

char *createifelse(char *condition, char *ifbody, char *elsebody) {
	char *toreturn;
	if(elsebody && strlen(elsebody) > 0) {
		if(strlen(ifbody) > 0)
			toreturn = concatn(11, IFSS, CONS, condition, CONE, IFBS, ifbody, IFBE, ELBS, elsebody, ELBE, IFSE);
		else
			toreturn = concatn(9, IFSS, CONS, condition, CONE, NIFB, ELBS, elsebody, ELBE, IFSE);
	} else {
		if(strlen(ifbody) > 0)
			toreturn = concatn(9, IFSS, CONS, condition, CONE, IFBS, ifbody, IFBE, NELB, IFSE);
		else
			toreturn = concatn(7, IFSS, CONS, condition, CONE, NIFB, NELB, IFSE);
	}
	return toreturn;
}

char *createdecl(char *decl) {
	char *toreturn = NULL;
	if(currentcalls) {
		toreturn = concatn(7, DECS, HASC, currentcalls, TEXS, decl, TEXE, DECE);
		free(currentcalls);
		currentcalls = NULL;
	} else {
		toreturn = concatn(6, DECS, DHAC, TEXS, decl, TEXE, DECE);
	}
	return toreturn;
}

char *createexp(char *exp) {
	char *toreturn = NULL;
	if(strlen(exp) > 0) {
		if(currentcalls) {
			toreturn = concatn(7, EXPS, HASC, currentcalls, TEXS, exp, TEXE, EXPE);
			free(currentcalls);
			currentcalls = NULL;
		} else {
			toreturn = concatn(6, EXPS, DHAC, TEXS, exp, TEXE, EXPE);
		}
	} else {
		toreturn = concatn(1, "");
	}
	return toreturn;
}

void addfunccall(char *funcname, char *args) {
	if(currentcalls) {
		if(args)
			currentcalls = concatn(9, currentcalls, CALS, NAMS, funcname, NAME, ARGS,  args, ARGE, CALE);
		else
			currentcalls = concatn(7, currentcalls, CALS, NAME, funcname, NAME, NARG, CALE);
	} else {
		if(args)
			currentcalls = concatn(8, CALS, NAMS, funcname, NAME, ARGS, args, ARGE, CALE);
		else
			currentcalls = concatn(6, CALS, NAMS, funcname, NAME, NARG, CALE);
	}
}

char *createfunc(char *specifiers, char *prototype, char *body) {
	char *toreturn;
	if(strlen(body) > 0)
		toreturn = concatn(9, FUNS, PROS, specifiers, prototype, PROE, BODS, body, BODE, FUNE);
	else
		toreturn = concatn(7, FUNS, PROS, specifiers, prototype, PROE, NBOD, FUNE);
	return toreturn;
}

char *concatn(int n, ...) {
    size_t flen = 0;
    va_list ap;
    va_start(ap, n);
    int i;
    for(i = 0; i < n; i++) {
        flen += strlen(va_arg(ap, char *));
    }
    va_end(ap);
    char *dest = (char *)calloc(flen + n, sizeof(char));
	if(!dest) {
		fflush(stdout);
    	fprintf(stderr, "%s\n", "an error occurred, while trying to allocate memory");
    	exit(1);
	}
    flen = 0;
    va_start(ap, n);
    for(i = 0; i < n; i++) {
        char *tmp = va_arg(ap, char *);
        strcpy(dest + flen, tmp);
        flen += strlen(tmp);
        if(i != n - 1) {
            dest[flen] = ' ';
            flen++;
        }
    }
    va_end(ap);
    return dest;
}

void freen(int n, ...) {
    va_list ap;
    va_start(ap, n);
    for(int i = 0; i < n; i++) {
        char *tmp = va_arg(ap, char *);
        free(tmp);
    }
    va_end(ap);
}

void yyerror(char *str) {
	fflush(stdout);
    fprintf(stderr, "%s on line %d\n", str, yylineno);
    exit(1);
}

int main() {
	freopen("./ctox.output.xml", "w", stdout);
    return yyparse();
}

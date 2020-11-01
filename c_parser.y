%define api.value.type { char *}

%token	IDENTIFIER I_CONSTANT F_CONSTANT STRING_LITERAL FUNC_NAME SIZEOF
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

#define YYDEBUG 1
extern int yydebug;

int yylex();
void yyerror(char *);
char *concatn(int n, ...);
void freen(int n, ...);
char *createfunc(char *, char *, char *);
void addfunccall(char *, char *);
char *createexp(char *);
char *createifelse(char *, char *, char *);

char *currentcalls = NULL;

#define EXPS "<expression"
#define EXPE "</expression>"
#define HASC "hascalls = \"true\">"
#define DHAC "hascalls = \"false\">"
#define TEXS "<text>"
#define TEXE "</text>"

#define DECS "<declaration>"
#define DECE "</declaration>"

#define FUNS "<function>"
#define FUNE "</function>"
#define PROS "<prototype>"
#define PROE "</prototype>"
#define BODS "<body>"
#define BODE "</body>"

#define CALS "<funccall>"
#define CALE "</funccall>"
#define NAMS "<name>"
#define NAME "</name>"
#define ARGS "<arguments>"
#define ARGE "</arguments>"

#define IFSS "<if>"
#define IFSE "</if>"
#define CONS "<condition>"
#define CONE "</condition>"
#define IFBS "<ifbody>"
#define IFBE "</ifbody>"
#define ELBS "<elsebody>"
#define ELBE "</elsebody>"
%}

%%

primary_expression
	: IDENTIFIER 			{$$ = strdup($1); free($1);}		
	| constant 				{$$ = strdup($1); free($1);}
	| string 				{$$ = strdup($1); free($1);}
	| '(' expression ')'	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| generic_selection		{$$ = strdup($1); free($1);}
	;

constant
	: I_CONSTANT		{ $$ = strdup($1); free($1);}	
	| F_CONSTANT		{ $$ = strdup($1); free($1);}
	;

string
	: STRING_LITERAL	{ $$ = strdup($1); free($1);}
	| FUNC_NAME			{ $$ = strdup($1); free($1);}
	;

generic_selection
	: GENERIC '(' assignment_expression ',' generic_assoc_list ')'
	;

generic_assoc_list
	: generic_association							{$$ = strdup($1); free($1);}
	| generic_assoc_list ',' generic_association
	;

generic_association
	: type_name ':' assignment_expression
	| DEFAULT ':' assignment_expression
	;

postfix_expression
	: primary_expression                                    {$$ = strdup($1); free($1);}
	| postfix_expression '[' expression ']'
	| postfix_expression '(' ')'
	| postfix_expression '(' argument_expression_list ')'	{$$ = concatn(4, $1, $2, $3, $4); addfunccall($1, $3); freen(4, $1, $2, $3, $4);}
	| postfix_expression '.' IDENTIFIER
	| postfix_expression PTR_OP IDENTIFIER
	| postfix_expression INC_OP
	| postfix_expression DEC_OP
	| '(' type_name ')' '{' initializer_list '}'
	| '(' type_name ')' '{' initializer_list ',' '}'
	;

argument_expression_list
	: assignment_expression									{$$ = strdup($1); free($1);}
	| argument_expression_list ',' assignment_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

unary_expression
	: postfix_expression				{$$ = strdup($1); free($1);}
	| INC_OP unary_expression			{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| DEC_OP unary_expression			{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| unary_operator cast_expression	{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| SIZEOF unary_expression			{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| SIZEOF '(' type_name ')'			{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| ALIGNOF '(' type_name ')'			{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	;

unary_operator
	: '&'	{ $$ = strdup($1); free($1);}
	| '*' 	{ $$ = strdup($1); free($1);}
	| '+' 	{ $$ = strdup($1); free($1);}
	| '-' 	{ $$ = strdup($1); free($1);}
	| '~' 	{ $$ = strdup($1); free($1);}
	| '!' 	{ $$ = strdup($1); free($1);}
	;

cast_expression
	: unary_expression						{$$ = strdup($1); free($1);}
	| '(' type_name ')' cast_expression		{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	;

multiplicative_expression
	: cast_expression									{$$ = strdup($1); free($1);}
	| multiplicative_expression '*' cast_expression		{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| multiplicative_expression '/' cast_expression		{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| multiplicative_expression '%' cast_expression		{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

additive_expression
	: multiplicative_expression								{$$ = strdup($1); free($1);}
	| additive_expression '+' multiplicative_expression		{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| additive_expression '-' multiplicative_expression		{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

shift_expression
	: additive_expression								{ $$ = strdup($1); free($1);}
	| shift_expression LEFT_OP additive_expression		{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| shift_expression RIGHT_OP additive_expression		{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

relational_expression
	: shift_expression								{ $$ = strdup($1); free($1);}
	| relational_expression '<' shift_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| relational_expression '>' shift_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| relational_expression LE_OP shift_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| relational_expression GE_OP shift_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

equality_expression
	: relational_expression								{ $$ = strdup($1); free($1);}
	| equality_expression EQ_OP relational_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| equality_expression NE_OP relational_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

and_expression
	: equality_expression						{ $$ = strdup($1); free($1);}
	| and_expression '&' equality_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

exclusive_or_expression
	: and_expression								{ $$ = strdup($1); free($1);}
	| exclusive_or_expression '^' and_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

inclusive_or_expression
	: exclusive_or_expression								{ $$ = strdup($1); free($1);}
	| inclusive_or_expression '|' exclusive_or_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

logical_and_expression
	: inclusive_or_expression									{ $$ = strdup($1); free($1);}
	| logical_and_expression AND_OP inclusive_or_expression		{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

logical_or_expression
	: logical_and_expression								{ $$ = strdup($1); free($1);}
	| logical_or_expression OR_OP logical_and_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

conditional_expression
	: logical_or_expression												{ $$ = strdup($1); free($1);}
	| logical_or_expression '?' expression ':' conditional_expression	{$$ = concatn(5, $1, $2, $3, $4, $5); freen(5, $1, $2, $3, $4, $5);}
	;

assignment_expression
	: conditional_expression										{ $$ = strdup($1); free($1);}
	| unary_expression assignment_operator assignment_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

assignment_operator
	: '='			{ $$ = strdup($1); free($1);}
	| MUL_ASSIGN	{ $$ = strdup($1); free($1);}
	| DIV_ASSIGN	{ $$ = strdup($1); free($1);}
	| MOD_ASSIGN	{ $$ = strdup($1); free($1);}
	| ADD_ASSIGN	{ $$ = strdup($1); free($1);}
	| SUB_ASSIGN	{ $$ = strdup($1); free($1);}
	| LEFT_ASSIGN	{ $$ = strdup($1); free($1);}
	| RIGHT_ASSIGN	{ $$ = strdup($1); free($1);}
	| AND_ASSIGN	{ $$ = strdup($1); free($1);}
	| XOR_ASSIGN	{ $$ = strdup($1); free($1);}
	| OR_ASSIGN		{ $$ = strdup($1); free($1);}
	;

expression
	: assignment_expression					{ $$ = strdup($1); free($1);}
	| expression ',' assignment_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

constant_expression
	: conditional_expression	{ $$ = strdup($1); free($1);}
	;

declaration
	: declaration_specifiers ';'						{$$ = concatn(3, DECS, $1, DECE); freen(2, $1, $2);}
	| declaration_specifiers init_declarator_list ';'	{$$ = concatn(4, DECS, $1, $2, DECE); freen(3, $1, $2, $3);}
	| static_assert_declaration							{ $$ = strdup($1); free($1);}
	;

declaration_specifiers
	: storage_class_specifier declaration_specifiers	{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| storage_class_specifier							{ $$ = strdup($1); free($1);}
	| type_specifier declaration_specifiers				{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| type_specifier									{ $$ = strdup($1); free($1);}
	| type_qualifier declaration_specifiers				{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| type_qualifier									{ $$ = strdup($1); free($1);}
	| function_specifier declaration_specifiers			{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| function_specifier								{ $$ = strdup($1); free($1);}
	| alignment_specifier declaration_specifiers
	| alignment_specifier
	;

init_declarator_list
	: init_declarator								{ $$ = strdup($1); free($1);}	
	| init_declarator_list ',' init_declarator		{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

init_declarator
	: declarator '=' initializer	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| declarator					{ $$ = strdup($1); free($1);}		
	;

storage_class_specifier
	: TYPEDEF		{ $$ = strdup($1); free($1);}
	| EXTERN		{ $$ = strdup($1); free($1);}
	| STATIC		{ $$ = strdup($1); free($1);}
	| THREAD_LOCAL  { $$ = strdup($1); free($1);}
	| AUTO			{ $$ = strdup($1); free($1);}
	| REGISTER		{ $$ = strdup($1); free($1);}
	;

type_specifier
	: VOID							{ $$ = strdup($1); free($1);}
	| CHAR							{ $$ = strdup($1); free($1);}
	| SHORT							{ $$ = strdup($1); free($1);}
	| INT							{ $$ = strdup($1); free($1);}
	| LONG							{ $$ = strdup($1); free($1);}
	| FLOAT							{ $$ = strdup($1); free($1);}
	| DOUBLE						{ $$ = strdup($1); free($1);}
	| SIGNED						{ $$ = strdup($1); free($1);}
	| UNSIGNED						{ $$ = strdup($1); free($1);}
	| BOOL							{ $$ = strdup($1); free($1);}
	| COMPLEX						{ $$ = strdup($1); free($1);}
	| IMAGINARY						{ $$ = strdup($1); free($1);}
	| atomic_type_specifier			{ $$ = strdup($1); free($1);}
	| struct_or_union_specifier		{ $$ = strdup($1); free($1);}
	| enum_specifier				{ $$ = strdup($1); free($1);}
	;

struct_or_union_specifier
	: struct_or_union '{' struct_declaration_list '}'				{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| struct_or_union IDENTIFIER '{' struct_declaration_list '}'	{$$ = concatn(5, $1, $2, $3, $4, $5); freen(5, $1, $2, $3, $4, $5);}
	| struct_or_union IDENTIFIER									{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	;

struct_or_union
	: STRUCT	{ $$ = strdup($1); free($1);}
	| UNION		{ $$ = strdup($1); free($1);}
	;

struct_declaration_list
	: struct_declaration							{ $$ = strdup($1); free($1);}
	| struct_declaration_list struct_declaration	{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	;

struct_declaration
	: specifier_qualifier_list ';'							{$$ = strdup($1); freen(2, $1, $2);}
	| specifier_qualifier_list struct_declarator_list ';'	{$$ = concatn(2, $1, $2); freen(3, $1, $2, $3);}
	| static_assert_declaration								{ $$ = strdup($1); free($1);}
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list		{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| type_specifier								{ $$ = strdup($1); free($1);}
	| type_qualifier specifier_qualifier_list		{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| type_qualifier								{ $$ = strdup($1); free($1);}
	;

struct_declarator_list
	: struct_declarator								{ $$ = strdup($1); free($1);}
	| struct_declarator_list ',' struct_declarator	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

struct_declarator							
	: ':' constant_expression				{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| declarator ':' constant_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| declarator							{ $$ = strdup($1); free($1);}
	;

enum_specifier
	: ENUM '{' enumerator_list '}'					{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| ENUM '{' enumerator_list ',' '}'				{$$ = concatn(5, $1, $2, $3, $4, $5); freen(5, $1, $2, $3, $4, $5);}
	| ENUM IDENTIFIER '{' enumerator_list '}'		{$$ = concatn(5, $1, $2, $3, $4, $5); freen(5, $1, $2, $3, $4, $5);}
	| ENUM IDENTIFIER '{' enumerator_list ',' '}'	{$$ = concatn(6, $1, $2, $3, $4, $5, $6); freen(6, $1, $2, $3, $4, $5, $6);}
	| ENUM IDENTIFIER								{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	;

enumerator_list
	: enumerator						{ $$ = strdup($1); free($1);}
	| enumerator_list ',' enumerator	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

enumerator
	: IDENTIFIER '=' constant_expression	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| IDENTIFIER							{ $$ = strdup($1); free($1);}
	;

atomic_type_specifier
	: ATOMIC '(' type_name ')'
	;

type_qualifier
	: CONST			{ $$ = strdup($1); free($1);}
	| RESTRICT		{ $$ = strdup($1); free($1);}
	| VOLATILE		{ $$ = strdup($1); free($1);}
	| ATOMIC		{ $$ = strdup($1); free($1);}
	;

function_specifier
	: INLINE		{ $$ = strdup($1); free($1);}
	| NORETURN		{ $$ = strdup($1); free($1);}
	;

alignment_specifier
	: ALIGNAS '(' type_name ')'
	| ALIGNAS '(' constant_expression ')'
	;

declarator
	: pointer direct_declarator		{$$ = concatn(2, $1, $2); freen(2, $1, $2);}	
	| direct_declarator				{ $$ = strdup($1); free($1);}
	;


direct_declarator
	: IDENTIFIER																	{ $$ = strdup($1); free($1);}
	| '(' declarator ')'
	| direct_declarator '[' ']'
	| direct_declarator '[' '*' ']'
	| direct_declarator '[' STATIC type_qualifier_list assignment_expression ']'
	| direct_declarator '[' STATIC assignment_expression ']'
	| direct_declarator '[' type_qualifier_list '*' ']'
	| direct_declarator '[' type_qualifier_list STATIC assignment_expression ']'
	| direct_declarator '[' type_qualifier_list assignment_expression ']'
	| direct_declarator '[' type_qualifier_list ']'
	| direct_declarator '[' assignment_expression ']'
	| direct_declarator '(' parameter_type_list ')'									{$$ = concatn(4, $1, $2, $3, $4); freen(4, $1, $2, $3, $4);}
	| direct_declarator '(' ')'
	| direct_declarator '(' identifier_list ')'
	;

pointer
	: '*' type_qualifier_list pointer   {$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| '*' type_qualifier_list           {$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| '*' pointer                       {$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| '*'                               {$$ = strdup($1); free($1);}
	;

type_qualifier_list
	: type_qualifier                        { $$ = strdup($1); free($1);}
	| type_qualifier_list type_qualifier	{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	;


parameter_type_list
	: parameter_list ',' ELLIPSIS	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	| parameter_list				{ $$ = strdup($1); free($1);}
	;

parameter_list
	: parameter_declaration						{ $$ = strdup($1); free($1);}
	| parameter_list ',' parameter_declaration	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

parameter_declaration
	: declaration_specifiers declarator				{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| declaration_specifiers abstract_declarator	{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| declaration_specifiers						{ $$ = strdup($1); free($1);}
	;

identifier_list
	: IDENTIFIER						{ $$ = strdup($1); free($1);}
	| identifier_list ',' IDENTIFIER	{$$ = concatn(3, $1, $2, $3); freen(3, $1, $2, $3);}
	;

type_name
	: specifier_qualifier_list abstract_declarator
	| specifier_qualifier_list						{ $$ = strdup($1); free($1);}
	;

abstract_declarator
	: pointer direct_abstract_declarator	{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	| pointer								{ $$ = strdup($1); free($1);}
	| direct_abstract_declarator			{ $$ = strdup($1); free($1);}
	;

direct_abstract_declarator
	: '(' abstract_declarator ')'
	| '[' ']'
	| '[' '*' ']'
	| '[' STATIC type_qualifier_list assignment_expression ']'
	| '[' STATIC assignment_expression ']'
	| '[' type_qualifier_list STATIC assignment_expression ']'
	| '[' type_qualifier_list assignment_expression ']'
	| '[' type_qualifier_list ']'
	| '[' assignment_expression ']'
	| direct_abstract_declarator '[' ']'
	| direct_abstract_declarator '[' '*' ']'
	| direct_abstract_declarator '[' STATIC type_qualifier_list assignment_expression ']'
	| direct_abstract_declarator '[' STATIC assignment_expression ']'
	| direct_abstract_declarator '[' type_qualifier_list assignment_expression ']'
	| direct_abstract_declarator '[' type_qualifier_list STATIC assignment_expression ']'
	| direct_abstract_declarator '[' type_qualifier_list ']'
	| direct_abstract_declarator '[' assignment_expression ']'
	| '(' ')'
	| '(' parameter_type_list ')'
	| direct_abstract_declarator '(' ')'
	| direct_abstract_declarator '(' parameter_type_list ')'
	;

initializer
	: '{' initializer_list '}'
	| '{' initializer_list ',' '}'
	| assignment_expression
	;

initializer_list
	: designation initializer
	| initializer
	| initializer_list ',' designation initializer
	| initializer_list ',' initializer
	;

designation
	: designator_list '='
	;

designator_list
	: designator
	| designator_list designator
	;

designator
	: '[' constant_expression ']'
	| '.' IDENTIFIER
	;

static_assert_declaration
	: STATIC_ASSERT '(' constant_expression ',' STRING_LITERAL ')' ';'
	;

statement
	: labeled_statement
	| compound_statement        { $$ = strdup($1); free($1);}
	| expression_statement      {$$ = createexp($1); free($1);}
	| selection_statement       
	| iteration_statement
	| jump_statement
	;

labeled_statement
	: IDENTIFIER ':' statement					
	| CASE constant_expression ':' statement
	| DEFAULT ':' statement
	;

compound_statement  
	: '{' '}'                       {freen(2, $1, $2);}
	| '{' block_item_list '}'       {$$ = strdup($2);}
	;

block_item_list
	: block_item                    { $$ = strdup($1); free($1);}
	| block_item_list block_item    {$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	;

block_item
	: declaration   { $$ = strdup($1); free($1);}
	| statement     { $$ = strdup($1); free($1);}
	;

expression_statement
	: ';'				{free($1);}
	| expression ';'	{ $$ = strdup($1); free($1);}
	;

selection_statement
	: IF '(' expression ')' statement ELSE statement 	{$$ = createifelse($3, $5, $7); freen(7, $1, $2, $3, $4, $5, $6, $7);}
	| IF '(' expression ')' statement					{$$ = createifelse($3, $5, NULL); freen(5, $1, $2, $3, $4, $5);}
	| SWITCH '(' expression ')' statement
	;

iteration_statement
	: WHILE '(' expression ')' statement
	| DO statement WHILE '(' expression ')' ';'
	| FOR '(' expression_statement expression_statement ')' statement
	| FOR '(' expression_statement expression_statement expression ')' statement
	| FOR '(' declaration expression_statement ')' statement
	| FOR '(' declaration expression_statement expression ')' statement
	;

jump_statement
	: GOTO IDENTIFIER ';'
	| CONTINUE ';'
	| BREAK ';'
	| RETURN ';'
	| RETURN expression ';'
	;

program_unit
	: translation_unit		{$$ = concatn(3, "<program>", $1, "</program>");printf("%s", $$); free($1); free($$);}
	;

translation_unit
	: external_declaration						{$$ = strdup($1); free($1);}
	| translation_unit external_declaration		{$$ = concatn(2, $1, $2); freen(2, $1, $2);}
	;

external_declaration
	: function_definition	{ $$ = strdup($1); free($1);}
	| declaration			{ $$ = strdup($1); free($1);}
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement
	| declaration_specifiers declarator compound_statement      				{$$ = createfunc($1, $2, $3); freen(3, $1, $2, $3);}            
	;

declaration_list
	: declaration
	| declaration_list declaration
	;

%%

char *createifelse(char *condition, char *ifbody, char *elsebody) {
	if(!elsebody)
		return concatn(11, IFSS, CONS, condition, CONE, IFBS, ifbody, IFBE, ELBS, elsebody, ELBE, IFSE);
	return concatn(8, IFSS, CONS, condition, CONE, IFBS, ifbody, IFBE, IFSE);
}

char *createexp(char *exp) {
	char *toreturn = NULL;
	if(currentcalls) {
		toreturn = concatn(7, EXPS, HASC, currentcalls, TEXS, exp, TEXE, EXPE);
		free(currentcalls);
		currentcalls = NULL;
	} else {
		toreturn = concatn(6, EXPS, DHAC, TEXS, exp, TEXE, EXPE);
	}
	return toreturn;
}

void addfunccall(char *funcname, char *args) {
	if(currentcalls)
		currentcalls = concatn(9, currentcalls, CALS, NAMS, funcname, NAME, ARGS,  args, ARGE, CALE);
	else 
		currentcalls = concatn(8, CALS, NAMS, funcname, NAME, ARGS,  args, ARGE, CALE);
}

char *createfunc(char *specifiers, char *prototype, char *body) {
	char *toreturn = concatn(9, FUNS, PROS, specifiers, prototype, PROE, BODS, body, BODE, FUNE);
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

void yyerror(char *msg) {
	fflush(stdout);
    fprintf(stderr, "Parser error: %s\n", msg);
    exit(1);
}

int main() {
	yydebug = 0;
    return yyparse();
}
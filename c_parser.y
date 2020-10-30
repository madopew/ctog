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

int yylex();
void yyerror(char *);
char *concatn(int n, ...);
char *createfunc(char *, char *, char *);
char *createfunccall(char *, char *);

#define EXPS "<expression>"
#define EXPE "</expression>"
#define SUBS "<sub>"
#define SUBE "</sub>"

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

%}

%%

primary_expression
	: IDENTIFIER 			/*auto*/		
	| constant 				/*auto*/
	| string 				/*auto*/
	| '(' expression ')'	{ $$ = concatn(3, "(", $2, ")");}
	| generic_selection		/*auto*/
	;

constant
	: I_CONSTANT		/*auto*/	
	| F_CONSTANT		/*auto*/
	;

string
	: STRING_LITERAL	/*auto*/
	| FUNC_NAME			/*auto*/
	;

generic_selection
	: GENERIC '(' assignment_expression ',' generic_assoc_list ')'
	;

generic_assoc_list
	: generic_association							/*auto*/
	| generic_assoc_list ',' generic_association
	;

generic_association
	: type_name ':' assignment_expression
	| DEFAULT ':' assignment_expression
	;

postfix_expression
	: primary_expression                                    /*auto*/
	| postfix_expression '[' expression ']'
	| postfix_expression '(' ')'
	| postfix_expression '(' argument_expression_list ')'	{$$ = createfunccall($1, $3);}
	| postfix_expression '.' IDENTIFIER
	| postfix_expression PTR_OP IDENTIFIER
	| postfix_expression INC_OP
	| postfix_expression DEC_OP
	| '(' type_name ')' '{' initializer_list '}'
	| '(' type_name ')' '{' initializer_list ',' '}'
	;

argument_expression_list
	: assignment_expression									/*auto*/
	| argument_expression_list ',' assignment_expression	{$$ = concatn(3, $1, ",", $3);}
	;

unary_expression
	: postfix_expression				/*auto*/
	| INC_OP unary_expression			{$$ = concatn(2, $1, $2);}
	| DEC_OP unary_expression			{$$ = concatn(2, $1, $2);}
	| unary_operator cast_expression	{$$ = concatn(2, $1, $2);}
	| SIZEOF unary_expression			{$$ = concatn(2, $1, $2);}
	| SIZEOF '(' type_name ')'			{$$ = concatn(4, $1, "(", $3, ")");}
	| ALIGNOF '(' type_name ')'
	;

unary_operator
	: '&'	{$$ = "&";}
	| '*' 	{$$ = "*";}
	| '+' 	{$$ = "+";}
	| '-' 	{$$ = "-";}
	| '~' 	{$$ = "~";}
	| '!' 	{$$ = "!";}
	;

cast_expression
	: unary_expression						/*auto*/
	| '(' type_name ')' cast_expression		{$$ = concatn(4, "(", $2, ")", $4);}
	;

multiplicative_expression
	: cast_expression									/*auto*/
	| multiplicative_expression '*' cast_expression		{$$ = concatn(3, $1, "*", $3);}
	| multiplicative_expression '/' cast_expression		{$$ = concatn(3, $1, "/", $3);}
	| multiplicative_expression '%' cast_expression		{$$ = concatn(3, $1, "%", $3);}
	;

additive_expression
	: multiplicative_expression								/*auto*/
	| additive_expression '+' multiplicative_expression		{$$ = concatn(3, $1, "+", $3);}
	| additive_expression '-' multiplicative_expression		{$$ = concatn(3, $1, "-", $3);}
	;

shift_expression
	: additive_expression								/*auto*/
	| shift_expression LEFT_OP additive_expression		{$$ = concatn(3, $1, $2, $3);}
	| shift_expression RIGHT_OP additive_expression		{$$ = concatn(3, $1, $2, $3);}
	;

relational_expression
	: shift_expression								/*auto*/
	| relational_expression '<' shift_expression	{$$ = concatn(3, $1, "<", $3);}
	| relational_expression '>' shift_expression	{$$ = concatn(3, $1, ">", $3);}
	| relational_expression LE_OP shift_expression	{$$ = concatn(3, $1, $2, $3);}
	| relational_expression GE_OP shift_expression	{$$ = concatn(3, $1, $2, $3);}
	;

equality_expression
	: relational_expression								/*auto*/
	| equality_expression EQ_OP relational_expression	{$$ = concatn(3, $1, $2, $3);}
	| equality_expression NE_OP relational_expression	{$$ = concatn(3, $1, $2, $3);}
	;

and_expression
	: equality_expression						/*auto*/
	| and_expression '&' equality_expression	{$$ = concatn(3, $1, "&", $3);}
	;

exclusive_or_expression
	: and_expression								/*auto*/
	| exclusive_or_expression '^' and_expression	{$$ = concatn(3, $1, "^", $3);}
	;

inclusive_or_expression
	: exclusive_or_expression								/*auto*/
	| inclusive_or_expression '|' exclusive_or_expression	{$$ = concatn(3, $1, "|", $3);}
	;

logical_and_expression
	: inclusive_or_expression									/*auto*/
	| logical_and_expression AND_OP inclusive_or_expression		{$$ = concatn(3, $1, $2, $3);}
	;

logical_or_expression
	: logical_and_expression								/*auto*/
	| logical_or_expression OR_OP logical_and_expression	{$$ = concatn(3, $1, $2, $3);}
	;

conditional_expression
	: logical_or_expression												/*auto*/
	| logical_or_expression '?' expression ':' conditional_expression	{$$ = concatn(5, $1, "?", $3, ":", $5);}
	;

assignment_expression
	: conditional_expression										/*auto*/
	| unary_expression assignment_operator assignment_expression	{$$ = concatn(3, $1, $2, $3);}
	;

assignment_operator
	: '='			{$$ = "=";}
	| MUL_ASSIGN	/*auto*/
	| DIV_ASSIGN	/*auto*/
	| MOD_ASSIGN	/*auto*/
	| ADD_ASSIGN	/*auto*/
	| SUB_ASSIGN	/*auto*/
	| LEFT_ASSIGN	/*auto*/
	| RIGHT_ASSIGN	/*auto*/
	| AND_ASSIGN	/*auto*/
	| XOR_ASSIGN	/*auto*/
	| OR_ASSIGN		/*auto*/
	;

expression
	: assignment_expression					/*auto*/
	| expression ',' assignment_expression	{$$ = concatn(3, $1, ",", $3);}
	;

constant_expression
	: conditional_expression	/*auto*/
	;

declaration
	: declaration_specifiers ';'						{$$ = concatn(3, DECS, $1, DECE);}
	| declaration_specifiers init_declarator_list ';'	{$$ = concatn(4, DECS, $1, $2, DECE);}
	| static_assert_declaration							/*auto*/
	;

declaration_specifiers
	: storage_class_specifier declaration_specifiers	{$$ = concatn(2, $1, $2);}
	| storage_class_specifier							/*auto*/
	| type_specifier declaration_specifiers				{$$ = concatn(2, $1, $2);}
	| type_specifier									/*auto*/
	| type_qualifier declaration_specifiers				{$$ = concatn(2, $1, $2);}
	| type_qualifier									/*auto*/
	| function_specifier declaration_specifiers			{$$ = concatn(2, $1, $2);}
	| function_specifier								/*auto*/
	| alignment_specifier declaration_specifiers
	| alignment_specifier
	;

init_declarator_list
	: init_declarator								/*auto*/	
	| init_declarator_list ',' init_declarator		{$$ = concatn(3, $1, ",", $3);}
	;

init_declarator
	: declarator '=' initializer	{$$ = concatn(3, $1, "=", $3);}
	| declarator					/*auto*/		
	;

storage_class_specifier
	: TYPEDEF		/*auto*/
	| EXTERN		/*auto*/
	| STATIC		/*auto*/
	| THREAD_LOCAL  /*auto*/
	| AUTO			/*auto*/
	| REGISTER		/*auto*/
	;

type_specifier
	: VOID							/*auto*/
	| CHAR							/*auto*/
	| SHORT							/*auto*/
	| INT							/*auto*/
	| LONG							/*auto*/
	| FLOAT							/*auto*/
	| DOUBLE						/*auto*/
	| SIGNED						/*auto*/
	| UNSIGNED						/*auto*/
	| BOOL							/*auto*/
	| COMPLEX						/*auto*/
	| IMAGINARY						/*auto*/
	| atomic_type_specifier			/*auto*/
	| struct_or_union_specifier		/*auto*/
	| enum_specifier				/*auto*/
	;

struct_or_union_specifier
	: struct_or_union '{' struct_declaration_list '}'				{$$ = concatn(4, $1, "{", $3, "}");}
	| struct_or_union IDENTIFIER '{' struct_declaration_list '}'	{$$ = concatn(5, $1, $2, "{", $4, "}");}
	| struct_or_union IDENTIFIER									{$$ = concatn(2, $1, $2);}
	;

struct_or_union
	: STRUCT	/*auto*/
	| UNION		/*auto*/
	;

struct_declaration_list
	: struct_declaration							/*auto*/
	| struct_declaration_list struct_declaration	{$$ = concatn(2, $1, $2);}
	;

struct_declaration
	: specifier_qualifier_list ';'							{$$ = strdup($1);}
	| specifier_qualifier_list struct_declarator_list ';'	{$$ = concatn(2, $1, $2);}
	| static_assert_declaration								/*auto*/
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list		{$$ = concatn(2, $1, $2);}
	| type_specifier								/*auto*/
	| type_qualifier specifier_qualifier_list		{$$ = concatn(2, $1, $2);}
	| type_qualifier								/*auto*/
	;

struct_declarator_list
	: struct_declarator								/*auto*/
	| struct_declarator_list ',' struct_declarator	{$$ = concatn(3, $1, ",", $3);}
	;

struct_declarator							
	: ':' constant_expression				{$$ = concatn(2, ":", $2);}
	| declarator ':' constant_expression	{$$ = concatn(3, $1, ":", $3);}
	| declarator							/*auto*/
	;

enum_specifier
	: ENUM '{' enumerator_list '}'					{$$ = concatn(4, $1, "{", $3, "}");}
	| ENUM '{' enumerator_list ',' '}'				{$$ = concatn(4, $1, "{", $3, ", }");}
	| ENUM IDENTIFIER '{' enumerator_list '}'		{$$ = concatn(5, $1, $2, "{", $4, "}");}
	| ENUM IDENTIFIER '{' enumerator_list ',' '}'	{$$ = concatn(5, $1, $2, "{", $4, ", }");}
	| ENUM IDENTIFIER								{$$ = concatn(2, $1, $2);}
	;

enumerator_list
	: enumerator						/*auto*/
	| enumerator_list ',' enumerator	{$$ = concatn(3, $1, ",", $3);}
	;

enumerator
	: IDENTIFIER '=' constant_expression	{$$ = concatn(3, $1, "=", $3);}
	| IDENTIFIER							/*auto*/
	;

atomic_type_specifier
	: ATOMIC '(' type_name ')'
	;

type_qualifier
	: CONST			/*auto*/
	| RESTRICT		/*auto*/
	| VOLATILE		/*auto*/
	| ATOMIC		/*auto*/
	;

function_specifier
	: INLINE		/*auto*/
	| NORETURN		/*auto*/
	;

alignment_specifier
	: ALIGNAS '(' type_name ')'
	| ALIGNAS '(' constant_expression ')'
	;

declarator
	: pointer direct_declarator		{$$ = concatn(2, $1, $2);}	
	| direct_declarator				/*auto*/
	;


direct_declarator
	: IDENTIFIER																	/*auto*/
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
	| direct_declarator '(' parameter_type_list ')'									{$$ = concatn(4, $1, "(", $3, ")");}
	| direct_declarator '(' ')'
	| direct_declarator '(' identifier_list ')'
	;

pointer
	: '*' type_qualifier_list pointer   {$$ = concatn(3, "*", $2, $3);}
	| '*' type_qualifier_list           {$$ = concatn(2, "*", $2);}
	| '*' pointer                       {$$ = concatn(2, "*", $2);}
	| '*'                               {$$ = "*";}
	;

type_qualifier_list
	: type_qualifier                        /*auto*/
	| type_qualifier_list type_qualifier	{$$ = concatn(2, $1, $2);}
	;


parameter_type_list
	: parameter_list ',' ELLIPSIS	{$$ = concatn(3, $1, ",", $3);}
	| parameter_list				/*auto*/
	;

parameter_list
	: parameter_declaration						/*auto*/
	| parameter_list ',' parameter_declaration	{$$ = concatn(3, $1, ",", $3);}
	;

parameter_declaration
	: declaration_specifiers declarator				{$$ = concatn(2, $1, $2);}
	| declaration_specifiers abstract_declarator	{$$ = concatn(2, $1, $2);}
	| declaration_specifiers						/*auto*/
	;

identifier_list
	: IDENTIFIER						/*auto*/
	| identifier_list ',' IDENTIFIER	{$$ = concatn(3, $1, ",", $3);}
	;

type_name
	: specifier_qualifier_list abstract_declarator
	| specifier_qualifier_list						/*auto*/
	;

abstract_declarator
	: pointer direct_abstract_declarator	{$$ = concatn(2, $1, $2);}
	| pointer								/*auto*/
	| direct_abstract_declarator			/*auto*/
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
	| compound_statement        /*auto*/
	| expression_statement      {$$ = concatn(3, EXPS, $1, EXPE);}
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
	: '{' '}'                       {/*empty block skipped*/}
	| '{' block_item_list '}'       {$$ = strdup($2);}
	;

block_item_list
	: block_item                    /*auto*/
	| block_item_list block_item    {$$ = concatn(2, $1, $2);}
	;

block_item
	: declaration   /*auto*/
	| statement     /*auto*/
	;

expression_statement
	: ';'				{/*empty expression skipped*/}
	| expression ';'	/*auto*/
	;

selection_statement
	: IF '(' expression ')' statement ELSE statement
	| IF '(' expression ')' statement
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
	: translation_unit		{$$ = concatn(3, "<program>", $1, "</program>");printf("%s", $$);}
	;

translation_unit
	: external_declaration						{$$ = strdup($1);}
	| translation_unit external_declaration		{$$ = concatn(2, $1, $2);}
	;

external_declaration
	: function_definition	/*auto*/
	| declaration			/*auto*/
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement
	| declaration_specifiers declarator compound_statement      				{$$ = createfunc($1, $2, $3);}            
	;

declaration_list
	: declaration
	| declaration_list declaration
	;

%%

char *createfunccall(char *funcname, char *args) {
	return concatn(8, CALS, NAMS, funcname, NAME, ARGS,  args, ARGE, CALE);
}

char *createfunc(char *specifiers, char *prototype, char *body) {
	return concatn(9, FUNS, PROS, specifiers, prototype, PROE, BODS, body, BODE, FUNE);
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

void yyerror(char *msg) {
	fflush(stdout);
    fprintf(stderr, "Parser error: %s\n", msg);
    exit(1);
}

int main() {
    return yyparse();
}
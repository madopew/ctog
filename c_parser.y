%define api.value.type { char *}

%token IDENTIFIER CONSTANT STRING_LITERAL SIZEOF
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME

%token TYPEDEF EXTERN STATIC AUTO REGISTER INLINE RESTRICT
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token BOOL COMPLEX IMAGINARY
%token STRUCT UNION ENUM ELLIPSIS

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%start translation_unit


%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

int yylex();
void yyerror(char *);
char *concatn(int n, ...);
char *createfunc(char *, char *, char *);
char *createproto(char *, char *);

#define EXPS "<expression>"
#define EXPE "</expression>"

#define DECS "<declaration>"
#define DECE "</declaration>"

#define FUNS "<function>"
#define FUNE "</function>"
#define SPES "<specifier>"
#define SPEE "</specifier>"
#define PROS "<prototype>"
#define PROE "</prototype>"
#define NAMS "<name>"
#define NAME "</name>"
#define PARS "<parameters>"
#define PARE "</parameters>"
#define PARAMS "<param>"
#define PARAME "</param>"
#define BODS "<body>"
#define BODE "</body>"

%}

%%

primary_expression
	: IDENTIFIER 			/*auto*/		
	| CONSTANT 				/*auto*/
	| STRING_LITERAL 		/*auto*/
	| '(' expression ')'	{ $$ = concatn(3, "(", $2, ")");}
	;

postfix_expression
	: primary_expression                                    /*auto*/
	| postfix_expression '[' expression ']'
	| postfix_expression '(' ')'
	| postfix_expression '(' argument_expression_list ')'
	| postfix_expression '.' IDENTIFIER
	| postfix_expression PTR_OP IDENTIFIER
	| postfix_expression INC_OP
	| postfix_expression DEC_OP
	| '(' type_name ')' '{' initializer_list '}'
	| '(' type_name ')' '{' initializer_list ',' '}'
	;

argument_expression_list
	: assignment_expression
	| argument_expression_list ',' assignment_expression
	;

unary_expression
	: postfix_expression				/*auto*/
	| INC_OP unary_expression			{$$ = concatn(2, $1, $2);}
	| DEC_OP unary_expression			{$$ = concatn(2, $1, $2);}
	| unary_operator cast_expression	{$$ = concatn(2, $1, $2);}
	| SIZEOF unary_expression			{$$ = concatn(2, $1, $2);}
	| SIZEOF '(' type_name ')'			{$$ = concatn(4, $1, "(", $3, ")");}
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
	;

declaration_specifiers
	: storage_class_specifier							/*auto*/
	| storage_class_specifier declaration_specifiers	{$$ = concatn(2, $1, $2);}
	| type_specifier									/*auto*/
	| type_specifier declaration_specifiers				{$$ = concatn(2, $1, $2);}
	| type_qualifier									/*auto*/
	| type_qualifier declaration_specifiers				{$$ = concatn(2, $1, $2);}
	| function_specifier								/*auto*/
	| function_specifier declaration_specifiers			{$$ = concatn(2, $1, $2);}
	;

init_declarator_list
	: init_declarator								/*auto*/	
	| init_declarator_list ',' init_declarator		{$$ = concatn(3, $1, ",", $3);}
	;

init_declarator
	: declarator					/*auto*/		
	| declarator '=' initializer	{$$ = concatn(3, $1, "=", $3);}
	;

storage_class_specifier
	: TYPEDEF		/*auto*/
	| EXTERN		/*auto*/
	| STATIC		/*auto*/
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
	| struct_or_union_specifier		/*auto*/
	| enum_specifier				/*auto*/
	| TYPE_NAME						/*auto*/
	;

struct_or_union_specifier
	: struct_or_union IDENTIFIER '{' struct_declaration_list '}'	{$$ = concatn(5, $1, $2, "{", $4, "}");}
	| struct_or_union '{' struct_declaration_list '}'				{$$ = concatn(4, $1, "{", $3, "}");}
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
	: specifier_qualifier_list struct_declarator_list ';'	{$$ = concatn(2, $1, $2);}
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
	: declarator							/*auto*/
	| ':' constant_expression				{$$ = concatn(2, ":", $2);}
	| declarator ':' constant_expression	{$$ = concatn(3, $1, ":", $3);}
	;

enum_specifier
	: ENUM '{' enumerator_list '}'					{$$ = concatn(4, $1, "{", $3, "}");}
	| ENUM IDENTIFIER '{' enumerator_list '}'		{$$ = concatn(5, $1, $2, "{", $4, "}");}
	| ENUM '{' enumerator_list ',' '}'				{$$ = concatn(4, $1, "{", $3, ", }");}
	| ENUM IDENTIFIER '{' enumerator_list ',' '}'	{$$ = concatn(5, $1, $2, "{", $4, ", }");}
	| ENUM IDENTIFIER								{$$ = concatn(2, $1, $2);}
	;

enumerator_list
	: enumerator						/*auto*/
	| enumerator_list ',' enumerator	{$$ = concatn(3, $1, ",", $3);}
	;

enumerator
	: IDENTIFIER							/*auto*/
	| IDENTIFIER '=' constant_expression	{$$ = concatn(3, $1, "=", $3);}
	;

type_qualifier
	: CONST			/*auto*/
	| RESTRICT		/*auto*/
	| VOLATILE		/*auto*/
	;

function_specifier
	: INLINE		/*auto*/
	;

declarator
	: pointer direct_declarator		{$$ = concatn(2, $1, $2);}	
	| direct_declarator				/*auto*/
	;


direct_declarator
	: IDENTIFIER																	/*auto*/
	| '(' declarator ')'
	| direct_declarator '[' type_qualifier_list assignment_expression ']'
	| direct_declarator '[' type_qualifier_list ']'
	| direct_declarator '[' assignment_expression ']'
	| direct_declarator '[' STATIC type_qualifier_list assignment_expression ']'
	| direct_declarator '[' type_qualifier_list STATIC assignment_expression ']'
	| direct_declarator '[' type_qualifier_list '*' ']'
	| direct_declarator '[' '*' ']'
	| direct_declarator '[' ']'
	| direct_declarator '(' parameter_type_list ')'									{$$ = createproto($1, $3);}
	| direct_declarator '(' identifier_list ')'
	| direct_declarator '(' ')'
	;

pointer
	: '*'                               {$$ = "*";}
	| '*' type_qualifier_list           {$$ = concatn(2, "*", $2);}
	| '*' pointer                       {$$ = concatn(2, "*", $2);}
	| '*' type_qualifier_list pointer   {$$ = concatn(3, "*", $2, $3);}
	;

type_qualifier_list
	: type_qualifier                        /*auto*/
	| type_qualifier_list type_qualifier
	;


parameter_type_list
	: parameter_list				/*auto*/
	| parameter_list ',' ELLIPSIS	{$$ = concatn(3, $1, ",", $3);}
	;

parameter_list
	: parameter_declaration						/*auto*/
	| parameter_list ',' parameter_declaration	{$$ = concatn(2, $1, $3);}
	;

parameter_declaration
	: declaration_specifiers declarator				{$$ = concatn(4, PARAMS, $1, $2, PARAME);}
	| declaration_specifiers abstract_declarator
	| declaration_specifiers
	;

identifier_list
	: IDENTIFIER
	| identifier_list ',' IDENTIFIER
	;

type_name
	: specifier_qualifier_list
	| specifier_qualifier_list abstract_declarator
	;

abstract_declarator
	: pointer
	| direct_abstract_declarator
	| pointer direct_abstract_declarator
	;

direct_abstract_declarator
	: '(' abstract_declarator ')'
	| '[' ']'
	| '[' assignment_expression ']'
	| direct_abstract_declarator '[' ']'
	| direct_abstract_declarator '[' assignment_expression ']'
	| '[' '*' ']'
	| direct_abstract_declarator '[' '*' ']'
	| '(' ')'
	| '(' parameter_type_list ')'
	| direct_abstract_declarator '(' ')'
	| direct_abstract_declarator '(' parameter_type_list ')'
	;

initializer
	: assignment_expression
	| '{' initializer_list '}'
	| '{' initializer_list ',' '}'
	;

initializer_list
	: initializer
	| designation initializer
	| initializer_list ',' initializer
	| initializer_list ',' designation initializer
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
	: ';'
	| expression ';'
	;

selection_statement
	: IF '(' expression ')' statement
	| IF '(' expression ')' statement ELSE statement
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

translation_unit
	: external_declaration
	| translation_unit external_declaration
	;

external_declaration
	: function_definition	{printf($1);}
	| declaration
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

char *createproto(char *name, char *parameters) {
	return concatn(6, NAMS, name, NAME, PARS, parameters, PARE);
}

char *createfunc(char *specifiers, char *prototype, char *body) {
	return concatn(11, FUNS, SPES, specifiers, SPEE, PROS, prototype, PROE, BODS, body, BODE, FUNE);
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
    fprintf(stderr, "Parser error: %s\n", msg);
    exit(1);
}

int main() {
    return yyparse();
}
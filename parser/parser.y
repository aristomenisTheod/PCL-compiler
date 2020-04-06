%{
#include <cstdio>
#include "lexer.hpp"
%}

%token T_program "program"
%token T_null "nil"
%token T_booleanId "boolean"
%token T_integerId "integer"
%token T_realId "real"
%token T_characterId "char"
%token T_array "array"
%token T_of "of"
%token T_and "and"
%token T_not "not"
%token T_or "or"
%token T_div "div"
%token T_mod "mod"
%token T_begin "begin"
%token T_end "end"
%token T_new "new"
%token T_dispose "dispose"
%token T_if "if"
%token T_then "then"
%token T_else "else"
%token T_while "while"
%token T_do "do"
%token T_forward "forward"
%token T_function "function"
%token T_procedure "procedure"
%token T_var "var"
%token T_result "result"
%token T_return "return"
%token T_goto "goto"
%token T_label "label"
%token T_true "true"
%token T_false "false"
%token T_character
%token T_integer
%token T_real
%token T_string
%token T_ge ">="
%token T_le "<="
%token T_dif "<>"
%token T_set ":="
%token T_name

%nonassoc '=' '>' '<' "<=" ">=" "<>"
%left '+' '-' "or"
%left '*' '/' "div" "mod" "and"
%precedence "not" PLUS MINUS
%precedence '^'
%precedence '@'
%nonassoc "then"
%nonassoc "else"

%%

program:
	"program" T_name ';' body '.'
;

body:
	local block
;

local:
	/* nothing */
	| "var" ids ':' type ';' var_multiple local
	| "label" ids ';' local
	| header ';' body ';' local
	| "forward" header ';' local
;

var_multiple:
	/* nothing */
	| ids ':' type ';' var_multiple
;

ids:
	T_name
	| T_name ',' ids
;

header:
	"procedure" T_name '(' ')'
	| "procedure" T_name '(' formal more_formal ')'
	| "function" T_name '(' ')' ':' type
	| "function" T_name '(' formal more_formal ')' ':' type
;

more_formal:
	/* nothing */
	| ';' formal more_formal
;
formal:
	ids ':' type
	| "var" ids ':' type
;

type:
	"integer"
	| "real"
	| "boolean"
	| "char"
	| "array" "of" type
	| "array" '[' T_integer ']' "of" type
	| '^' type
;

block:
	"begin" stmt_list "end"
;

stmt_list:
	stmt
	| stmt ';' stmt_list
;

stmt:
	/* nothing */
	| l_value ":=" expr
	| block
	| call
	| "if" expr "then" stmt
	| "if" expr "then" stmt "else" stmt
	| "while" expr "do" stmt
	| T_name ':' stmt
	| "goto" T_name
	| "return"
	| "new" l_value
	| "new" '[' expr ']' l_value
	| "dispose" l_value
	| "dispose" '[' ']' l_value
;

expr:
	l_value
	| r_value
;

l_value:
	T_name
	| "result"
	| T_string
	| l_value '[' expr ']'
	| expr '^'
	| '(' l_value ')'
;

r_value:
	T_integer
	| "true"
	| "false"
	| T_real
	| T_character
	| '(' r_value ')'
	| "nil"
	| call
	| '@' l_value_less
	| "not" expr
	| '+' expr %prec PLUS
	| '-' expr %prec MINUS
	| expr '+' expr
	| expr '-' expr
	| expr '*' expr
	| expr '/' expr
	| expr "div" expr
	| expr "mod" expr
	| expr "or" expr
	| expr "and" expr
	| expr '=' expr
	| expr "<>" expr
	| expr '<' expr
	| expr "<=" expr
	| expr '>' expr
	| expr ">=" expr
;

l_value_less:
	T_name
	| "result"
	| T_string
	| l_value_less '[' expr ']'
	| '(' l_value ')'
;

call:
	T_name '(' ')'
	| T_name '(' call_args ')'
;

call_args:
	expr
	| expr ',' call_args
;

%%

int main(){
	int result = yyparse();
	printf("Exit Code:%i\n", result);
	if(result == 0) printf("Success.\n");
	return result;
}

%{
#include <cstdio>
#include "lexer.hpp"
%}

%token T_if "if"
%token T_then "then"
%token T_else "else"
%token T_while "while"
%token T_do "do"
%token T_forward "forward"
%token T_function "function"
%token T_procedure "procedure"
%token T_program "program"
%token T_var "var"
%token T_result "result"
%token T_return "return"
%token T_goto "goto"
%token T_label "label"
%token T_new "new"
%token T_dispose "dispose"
%token T_begin "begin"
%token T_end "end"
%token T_div "div"
%token T_mod "mod"
%token T_and "and"
%token T_not "not"
%token T_or "or"
%token T_array "array"
%token T_of "of"
%token T_booleanId "boolean"
%token T_integerId "integer"
%token T_realId "real"
%token T_characterId "character"
%token T_null "nil"
%token T_boolean
%token T_integer
%token T_real
%token T_character
%token T_string
%token T_name

%nonassoc '=' '>' '<' "<=" ">=" "<>"
%left '+' '-' "or"
%left '*' '/' "div" "mod" "and"
%nonassoc "not"
%nonassoc PLUS MINUS
%nonassoc '^'
%nonassoc '@'
%nonassoc "then"
%nonassoc "else"

%%

program:
    "program" T_name ';' body '.'
;

body:
    /* nothing */
    | local block
;

local:
    /* nothing */
    | "var" T_name ids ':' type ';' local
    | "label" T_name ids ';' local
    | header ';' body ';' local
    | "forward" header ';' local
;

header:
    "procedure" T_name '(' formal ')'
    | "function" T_name '(' formal ')' ':' type
;

formal:
    /* nothing */
    | "var" T_name ids ':' type
    | T_name ids ':' type
;

ids:
    /* nothing */
    | ',' T_name ids
;

type:
    "integer"
    | "boolean"
    | "character"
    | "real"
    | '^' type
    | "array" "of" type
    | "array" '[' T_integer ']' "of" type
;

block:
    "begin" stmt_list "end"
;

stmt_list:
    /* nothing */
    | stmt ';' stmt_list
;

stmt:
    l_value ":=" expr
    | "if" expr "then" stmt_block
    | "if" expr "then" stmt_block "else" stmt_block
    | "while" expr "do" stmt_block
    | T_name ':' stmt
    | "goto" T_name
    | "return"
    | "new" l_value
    | "new" '[' expr ']' l_value
    | "dispose" l_value
    | "dispose" '[' expr ']' l_value
    | call
;

call:
    T_name '(' ')'
    | T_name '(' call_args ')'
;

call_args:
     expr
    | expr ',' call_args
;

stmt_block:
    stmt
    | "begin" stmt_list "end"
;

expr:
    l_value
    | r_value
    | mem
;

mem:
    '@' l_value
    | '@' '(' expr '^' ')'
    | expr '^'
    | '(' '@' l_value ')' '^'

l_value:
    T_name
    | "result"
    | T_string
    | l_value '[' expr ']'
    | '(' l_value ')'
;

r_value:
    T_integer
    | T_character
    | T_real
    | '(' r_value ')'
    | "nil"
    | call
    | T_boolean
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

%%

int main(){
    int result = yyparse();
    if(result == 0) printf("Success.\n");
    return result;
}

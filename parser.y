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
    "program" T_name ';' body '.'                           {printf("program\n");}
;

body:
    local block                                             {printf("body\n");}
;

local:
    /* nothing */                                           {printf("local: empty\n");}
    | "var" ids ':' type ';' var_multiple local             {printf("local: var\n");}
    | "label" ids ';' local                                 {printf("local: label\n");}
    | header ';' body ';' local                             {printf("local: header body\n");}
    | "forward" header ';' local                            {printf("local: forward\n");}
;

var_multiple:
    /* nothing */                                           {printf("var_multiple: nothing\n");}
    | ids ':' type ';' var_multiple                         {printf("var_multiple: more\n");}
;

ids:
    T_name                                                  {printf("ids: one\n");}
    | T_name ',' ids                                        {printf("ids: more\n");}
;

header:
    "procedure" T_name '(' ')'                              {printf("header: procedure\n");}
    | "procedure" T_name '(' formal more_formal ')'         {printf("header: procedure ()\n");}
    | "function" T_name '(' ')' ':' type                    {printf("header: function\n");}
    | "function" T_name '(' formal more_formal ')' ':' type {printf("header: function ()\n");}
;

more_formal:
    /* nothing */                                           {printf("more_formal: nothing\n");}
    | ';' formal more_formal                                {printf("more_formal: more\n");}
;
formal:
    ids ':' type                                            {printf("formal: no var\n");}
    | "var" ids ':' type                                    {printf("formal: var\n");}
;

type:
    "integer"                                               {printf("integer\n");}
    | "real"                                                {printf("type: real\n");}
    | "boolean"                                             {printf("type: boolean\n");}
    | "char"                                                {printf("type: char\n");}
    | "array" "of" type                                     {printf("type: array\n");}
    | "array" '[' T_integer ']' "of" type                   {printf("type: array[]\n");}
    | '^' type                                              {printf("type: ^\n");}
;

block:
    "begin" stmt_list "end"                                 {printf("block\n");}
;

stmt_list:
    stmt                                                    {printf("stmt_list: one\n");}
    | stmt ';' stmt_list                                    {printf("stmt_list: more\n");}
;

stmt:
    /* nothing */                                           {printf("stmt: empty\n");}
    | l_value ":=" expr                                     {printf("stmt: :=\n");}
    | block                                                 {printf("stmt: block\n");}
    | call                                                  {printf("stmt: call\n");}
    | "if" expr "then" stmt                                 {printf("stmt: if\n");}
    | "if" expr "then" stmt "else" stmt                     {printf("stmt: if/else\n");}
    | "while" expr "do" stmt                                {printf("stmt: while\n");}
    | T_name ':' stmt                                       {printf("stmt: T_name:\n");}
    | "goto" T_name                                         {printf("stmt: goto\n");}
    | "return"                                              {printf("stmt: return\n");}
    | "new" l_value                                         {printf("stmt: new\n");}
    | "new" '[' expr ']' l_value                            {printf("stmt: new[]\n");}
    | "dispose" l_value                                     {printf("stmt: dispose\n");}
    | "dispose" '[' ']' l_value                             {printf("stmt: dispose[]\n");}
;

expr:
    l_value                                                 {printf("expr: l_value\n");}
    | r_value                                               {printf("expr: r_value\n");}
;

l_value:
    T_name                                                  {printf("l_value: T_name\n");}
    | "result"                                              {printf("l_value: result\n");}
    | T_string                                              {printf("l_value: T_string\n");}
    | l_value '[' expr ']'                                  {printf("l_value: []\n");}
    | expr '^'                                              {printf("l_value: ^\n");}
    | '(' l_value ')'                                       {printf("l_value: (l)\n");}
;

r_value:
    T_integer                                               {printf("r_value: T_integer\n");}
    | "true"                                                {printf("r_value: true\n");}
    | "false"                                               {printf("r_value: false\n");}
    | T_real                                                {printf("r_value:T_real\n");}
    | T_character                                           {printf("r_value:T_character\n");}
    | '(' r_value ')'                                       {printf("r_value: (r)\n");}
    | "nil"                                                 {printf("r_value: nil\n");}
    | call                                                  {printf("r_value: call\n");}
    | '@' l_value_less                                      {printf("r_value: @\n");}
    | "not" expr                                            {printf("r_value: not\n");}
    | '+' expr %prec PLUS                                   {printf("r_value: plus\n");}
    | '-' expr %prec MINUS                                  {printf("r_value: Nimus\n");}
    | expr '+' expr                                         {printf("r_value: +\n");}
    | expr '-' expr                                         {printf("r_value: -\n");}
    | expr '*' expr                                         {printf("r_value: *\n");}
    | expr '/' expr                                         {printf("r_value: /\n");}
    | expr "div" expr                                       {printf("r_value: div\n");}
    | expr "mod" expr                                       {printf("r_value: mod\n");}
    | expr "or" expr                                        {printf("r_value: or\n");}
    | expr "and" expr                                       {printf("r_value: and\n");}
    | expr '=' expr                                         {printf("r_value: =\n");}
    | expr "<>" expr                                        {printf("r_value: <>\n");}
    | expr '<' expr                                         {printf("r_value: <\n");}
    | expr "<=" expr                                        {printf("r_value: <=\n");}
    | expr '>' expr                                         {printf("r_value: >\n");}
    | expr ">=" expr                                        {printf("r_value: >=\n");}
;

l_value_less:
    T_name                                                  {printf("l_value_less: T_name\n");}
    | "result"                                              {printf("l_value_less: result\n");}
    | T_string                                              {printf("l_value_less: T_string\n");}
    | l_value_less '[' expr ']'                             {printf("l_value_less: []\n");}
    | '(' l_value ')'                                       {printf("l_value_less: ()\n");}
;

call:
    T_name '(' ')'                                          {printf("call: empty\n");}
    | T_name '(' call_args ')'                              {printf("call: with args\n");}
;

call_args:
    expr                                                    {printf("call_args: one\n");}
    | expr ',' call_args                                    {printf("call_args: more\n");}
;

%%

int main(){
    int result = yyparse();
    printf("Exit Code:%i\n", result);
    if(result == 0) printf("Success.\n");
    return result;
}

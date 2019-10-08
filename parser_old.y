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
%token T_dif "<>"
%token T_ge ">="
%token T_le "<="
%token T_set ":="

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
    "program" T_name ';' body '.'                   {printf("program name ; body .\n");}
;

body:
    /* nothing */                                   {printf("body: nothing\n");}
    | local block                                   {printf("body:local block\n");}
;

local:
    /* nothing */                                   {printf("local: nothing\n");}
    | "var" T_name ids ':' type ';' local           {printf("local: var\n");} /* lathos. den ekfrazei tiw pollew metablites pou exei sth glwssa */
    | "label" T_name ids ';' local                  {printf("local: label\n");}
    | header ';' body ';' local                     {printf("local: header\n");}
    | "forward" header ';' local                    {printf("local: forward\n");}
;

header:
    "procedure" T_name '(' formal ')'               {printf("header: procedure\n");}
    | "function" T_name '(' formal ')' ':' type     {printf("header: function\n");}
;

formal:
    /* nothing */                                   {printf("formal: nothing\n");}
    | "var" T_name ids ':' type                     {printf("formal: var\n");}
    | T_name ids ':' type                           {printf("formal: no var\n");}
;

ids:
    /* nothing */                                   {printf("ids: nothing\n");}
    | ',' T_name ids                                {printf("ids: more\n");}
;

type:
    "integer"                                       {printf("type: integer\n");}
    | "boolean"                                     {printf("type: boolean\n");}
    | "character"                                   {printf("type: character\n");}
    | "real"                                        {printf("type: real\n");}
    | '^' type                                      {printf("type: ^\n");}
    | "array" "of" type                             {printf("type: array no size\n");}
    | "array" '[' T_integer ']' "of" type           {printf("type: array with size\n");}
;

block:
    "begin" stmt_list "end"                         {printf("block: begin end\n");}
;

stmt_list: /* wrong! last stmt doesn't have ";" */
    /* nothing */                                   {printf("stmt list: nothing\n");}
    | stmt ';' stmt_list                            {printf("stmt list: stmt+list\n");}
;

stmt:
    l_value ":=" expr                               {printf("stmt: :=\n");}
    | "if" expr "then" stmt_block                   {printf("stmt: if \n");}
    | "if" expr "then" stmt_block "else" stmt_block {printf("stmt: else \n");}
    | "while" expr "do" stmt_block                  {printf("stmt: while \n");}
    | T_name ':' stmt                               {printf("stmt: flag \n");}
    | "goto" T_name                                 {printf("stmt: goto \n");}
    | "return"                                      {printf("stmt: return \n");}
    | "new" l_value                                 {printf("stmt: new \n");}
    | "new" '[' expr ']' l_value                    {printf("stmt: new with expr \n");}
    | "dispose" l_value                             {printf("stmt: dispose\n");}
    | "dispose" '[' expr ']' l_value                {printf("stmt: dispose with expr \n");}
    | "new" l_mem                                   {printf("stmt: newm \n");}
    | "new" '[' expr ']' l_mem                      {printf("stmt: new with expr m\n");}
    | "dispose" l_mem                               {printf("stmt: disposem\n");}
    | "dispose" '[' expr ']' l_mem                  {printf("stmt: dispose with expr m\n");}
    | call                                          {printf("stmt: call\n");}
;

call:
    T_name '(' ')'                                  {printf("call: no args\n");}
    | T_name '(' call_args ')'                      {printf("call: with args\n");}
;

call_args:
     expr                                           {printf("call args: one\n");}
    | expr ',' call_args                            {printf("call args: more\n");}
;

stmt_block:
    stmt                                            {printf("stmt_block: stmt\n");}
    | "begin" stmt_list "end"                       {printf("stmt_block: begin end\n");}
;

expr:
    l_value                                         {printf("expr: l_value\n");}
    | r_value                                       {printf("expr: r_value\n");}
    | mem                                           {printf("expr: mem\n");}
;

mem:
    r_mem                                           {printf("mem: r_mem\n");}
    | l_mem                                         {printf("mem: l_mem\n");}
;

l_mem:
    expr '^'                                        {printf("mem: ^\n");}
    | '(' '@' l_value ')' '^'                       {printf("mem: ^ with ()\n");}
;

r_mem:
    '@' l_value                                     {printf("mem: @lval\n");}
    | '@' '(' expr '^' ')'                          {printf("mem: @ with ())\n");}
;
l_value:
    T_name                                          {printf("l_value: Tname\n");}
    | "result"                                      {printf("l_value: result\n");}
    | T_string                                      {printf("l_value: Tstring\n");}
    | l_value '[' expr ']'                          {printf("l_value: []\n");}
    | '(' l_value ')'                               {printf("l_value: ()\n");}
;

r_value:
    T_integer                                       {printf("r_value: Tinteger\n");}
    | T_character                                   {printf("r_value: Tcharacter\n");}
    | T_real                                        {printf("r_value: Treal\n");}
    | T_boolean                                     {printf("r_value: Tbool\n");}
    | '(' r_value ')'                               {printf("r_value: ())\n");}
    | "nil"                                         {printf("r_value: nil\n");}
    | call                                          {printf("r_value: call\n");}
    | "not" expr                                    {printf("r_value: not\n");}
    | '+' expr %prec PLUS                           {printf("r_value: plus\n");}
    | '-' expr %prec MINUS                          {printf("r_value: Nimus\n");}
    | expr '+' expr                                 {printf("r_value: +\n");}
    | expr '-' expr                                 {printf("r_value: -\n");}
    | expr '*' expr                                 {printf("r_value: *\n");}
    | expr '/' expr                                 {printf("r_value: /\n");}
    | expr "div" expr                               {printf("r_value: div\n");}
    | expr "mod" expr                               {printf("r_value: mod\n");}
    | expr "or" expr                                {printf("r_value: or\n");}
    | expr "and" expr                               {printf("r_value: and\n");}
    | expr '=' expr                                 {printf("r_value: =\n");}
    | expr "<>" expr                                {printf("r_value: <>\n");}
    | expr '<' expr                                 {printf("r_value: <\n");}
    | expr "<=" expr                                {printf("r_value: <=\n");}
    | expr '>' expr                                 {printf("r_value: >\n");}
    | expr ">=" expr                                {printf("r_value: >=\n");}
;

%%

int main(){
    int result = yyparse();
    printf("Exit Code:%i\n", result);
    if(result == 0) printf("Success.\n");
    return result;
}

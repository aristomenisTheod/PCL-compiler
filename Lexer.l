%option noyywrap

%{
#include "parser.hpp"
#include "lexer.hpp"
%}

Name [A-Za-z]
Dig [0-9]
White [ \t\n\r]
Op ">="|"<="|"<>"|"="|">"|"<"|"/"|"+"|"-"|"*"|"^"|"@"
Sep ":="|";"|"."|"("|")"|":"|","|"["|"]"
Char [\x20\x21\x23-\x26\x28-\x5b\x5d-\x7e]|"\n"|"\t"|"\r"|"\0"|"\\"|"\'"|"\""

%%

program                             { return T_program; }
nil                                 { return T_null; }
true|false                          { return T_boolean; }
boolean                             { return T_booleanId; }
integer                             { return T_integerId; }
real                                { return T_realId; }
array                               { return T_array; }
of                                  { return T_of; }
and                                 { return T_and; }
not                                 { return T_not; }
or                                  { return T_or; }
div                                 { return T_div; }
mod                                 { return T_mod; }
begin                               { return T_begin; }
end                                 { return T_end; }
new                                 { return T_new; }
dispose                             { return T_dispose; }
if                                  { return T_if; }
then                                { return T_then; }
else                                { return T_else; }
while                               { return T_while; }
do                                  { return T_do; }
forward                             { return T_forward; }
function                            { return T_function; }
procedure                           { return T_procedure; }
var                                 { return T_var; }
result                              { return T_result; }
return                              { return T_return; }
goto                                { return T_goto; }
label                               { return T_label; }
"\'"{Char}."\'"                     { return T_character; }
("\"").{Char}+"\"".                 { return T_string; }
{Dig}+                              { return T_integer; }
{Dig}+[.]{Dig}+((e|E)[+-]?{Dig}+)?  { return T_real; }
{Op}.                               { return yytext[0]; }
{Sep}.                              { return yytext[0]; }
{White}+                            { /* nothing */ }
{Name}*                             { return T_name; }
.                                   { yyerror("lexical error"); }

%%

void yyerror(const char *msg){
    fprintf(stderr, "%s\n", msg);
    exit(1);
}

%option noyywrap

%{
#include <iostream>
#include "parser.hpp"
#include "lexer.hpp"

using namespace std;
%}

Name [a-zA-Z]
Dig [0-9]
White [ \t\n\r]
Op [=></^@*]
Char [\x0\x9\xa\xd\x20\x21\x23-\x26\x28-\x7e]

%%

program                             { return T_program;}
nil                                 { return T_null; }
true                                { return T_true;}
false                               { return T_false; }
boolean                             { return T_booleanId; }
integer                             { return T_integerId; }
real                                { return T_realId; }
char                                { return T_characterId; }
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
">="                                { return T_ge; }
"<="                                { return T_le; }
"<>"                                { return T_dif; }
":="                                { return T_set; }
":"                                 { return yytext[0];}
";"                                 { return yytext[0];}
"."                                 { return yytext[0];}
","                                 { return yytext[0];}
"("                                 { return yytext[0];}
")"                                 { return yytext[0];}
"-"                                 { return yytext[0];}
"+"                                 { return yytext[0];}
"["                                 { return yytext[0];}
"]"                                 { return yytext[0];}
\'({Char}|[\x22]).\'                { return T_character;}
\"({Char}|[\x27])*\"                { return T_string;}
{Dig}+                              { return T_integer;}
{Dig}+[.]{Dig}+((e|E)[+-]?{Dig}+)?  { return T_real;}
{Op}.                               { return yytext[0];}
{White}+                            { /* Ignore white space */ }
{Name}+                             { return T_name;}
.                                   { fprintf(stderr, "Illegal character with code %d\n",yytext[0]);	exit(1); }

%%

void yyerror(const char *msg){
    fprintf(stderr, "%s\n", msg);
    exit(1);
}

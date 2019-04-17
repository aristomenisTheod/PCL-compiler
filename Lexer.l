%{
#define T_eof 0
#define T_if 1001
#define T_then 1002
#define T_else 1003
#define T_while 1004
#define T_do 1005
#define T_forward 1006
#define T_function 1007
#define T_procedure 1008
#define T_program 1009
#define T_var 1010
#define T_result 1011
#define T_return 1012
#define T_goto 1013
#define T_label 1014
#define T_new 1015
#define T_dispose 1016
#define T_begin 1017
#define T_end 1018
#define T_div 1019
#define T_mod 1020
#define T_and 1021
#define T_not 1022
#define T_or 1023
#define T_array 1024
#define T_of 1025
#define T_boolean 1026
#define T_integer 1027
#define T_real 1028
#define T_character 1029
#define T_string 1030
#define T_null 1031
#define T_true 1032
#define T_false 1033
#define T_name 1037

%}

%option c++
%option noyywrap

Name [A-Za-z]
Dig [0-9]
White [ \t\n\r]
Op ">="|"<="|"<>"|"="|">"|"<"|"/"|"-"|"*"|"^"|"@"
Sep ":="|";"|"."|"("|")"|":"|","|"["|"]"
Char [\x20\x21\x23-\x26\x28-\x5b\x5d-\x7e]|"\n"|"\t"|"\r"|"\0"|"\\"|"\'"|"\""

%%

program                             { return T_program; }
nil                                 { return T_null; }
true                                { return T_true; }
false                               { return T_false; }
boolean                             { return T_boolean; }
integer                             { return T_integer; }
real                                { return T_real; }
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
<<EOF>>                             { return T_eof; }
"\'"{Char}."\'"                     { return yytext[0]; }
("\"").{Char}+"\"".                 { return yytext[0]; }
{Dig}+                              { return yytext[0]; }
{Dig}+[.]{Dig}+((e|E)[+-]?{Dig}+)?  { return yytext[0]; }
{Op}.                               { return yytext[0]; }
{Sep}.                              { return yytext[0]; }
{White}+                            { /* nothing */ }
{Name}*                             { return T_name; }
.       { fprintf(stderr, "Illegal character with code %d", yytext[0]);
          exit(1);
        }

%%

#ifdef yyFlexLexer
int main(){
    yyFlexLexer lexer;// = new yyFlexLexer();
    int token;
    do {
        token = lexer.yylex();
        printf("token=%d, lexeme=\"%s\"\n", token, lexer.YYText());
    } while (token != T_eof);
}
#else
int main(){
    int token;
    do{
        token = yylex();
        printf("token=%d, lexeme=\"%s\"\n", token, yytext);
    } while (token != T_eof);
}
#endif

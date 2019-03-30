%{
 #include <stdio.h>
%}


L [A-Za-z]      /* Letters */
DIGIT [0-9]         /* Digits */
W [ \t\n]       /* White space */

%%

{L}+                        {printf("a word");}
program                     {printf("program start");}
nil                         {printf("NULL");}
boolean|true|false          {printf("Booleans: %s\n", yytext);}
integer|real                {printf("Number types: %s\n", yytext);}
array|of                    {printf("Array: %s\n", yytext);}
and|not|or                  {printf("Logical: %s\n", yytext);}
div|mod                     {printf("Divide: %s\n", yytext);}
begin|end                   {printf("Block margins: %s\n", yytext);}
new|dispose                 {printf("Memory managment: %s\n", yytext);}
if|then|else                {printf("if stmt: %s\n", yytext);}
while|do                    {printf("while loop: %s\n", yytext);}
forward|function|procedure  {printf("Blocks: %s\n", yytext);}
var                         {printf("variable dec");}
result|return               {printf("function return: %s\n", yytext);}
goto|label                  {printf("jump: %s\n", yytext);}
"EOF"                       {return 0;}

%%

int main{
  yylex();
  return 0;
}

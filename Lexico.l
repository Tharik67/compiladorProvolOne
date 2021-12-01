%{
  #include <stdio.h>
  #include <string.h>
  #include "y.tab.h"
%}

var [a-zA-Z][a-zA-Z0-9]* 
wspc [ \t\n]+

%%
ENTRADA return ENTRADA;
SAIDA return SAIDA;
FIM return FIM;
ENQUANTO return ENQUANTO;
INC return INC;
FACA return FACA;
ZERA return ZERA;
{var} { yylval.word = &yytext[0]; return id; }
[=,;] return yytext[0];
{wspc} {;}
%%

int yywrap() { return 1; }

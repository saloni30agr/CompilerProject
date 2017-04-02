%{
#include "y.tab.h"
#include<stdlib.h>
void yyerror(char *);
char *p=NULL;
%}

%%

"print"				   {return print;}
"exit"				   {return exit_command;}
[a-zA-Z]			   {yylval.id = yytext[0]; return identifier;}
[0-9]+                 {yylval.num = atoi(yytext); return number;}
[ \t\n]              	;
[-*%+=;]            	{return yytext[0];}
"/"						{return yytext[0];}
.                      {ECHO; yyerror ("unexpected character");}

%%
int yywrap (void) {return 1;}




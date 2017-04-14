%{
#include <stdlib.h>
#include "head.h"
#include "y.tab.h"
void yyerror(char *);
%}

%%

[a-z]       { 
                yylval.sIndex = *yytext - 'a';
                return VARIABLE;
            }

0           {
                yylval.iValue = atoi(yytext);
                return INTEGER;
            }

[1-9][0-9]* {
                yylval.iValue = atoi(yytext);
                return INTEGER;
            }

[-()<>=+*/;{}.] {
                return *yytext;
             }

">="            return GE;
"<="            return LE;
"=="            return EQ;
"!="            return NE;
"++"            return UP;
"--"            return UM;
"while"         return WHILE;
"if"            return IF;
"else"          return ELSE;
"print"         return PRINT;
"for"           return FOR;
"exit"          return EXIT;


[ \t\n]+        ;      

.               yyerror("Unknown character");

%%

int yywrap(void) {
    return 1;
}

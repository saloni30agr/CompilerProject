%{
void yyerror (char *s);
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>

int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
extern int yylex();
%}

%union {int num; char id; double ud;}         /* Yacc definitions */
%start line
%token print
%token exit_command
%token <num> number
%token <id> identifier
%token <ud> userdouble
%type <ud> line exp exp1 term 
%type <id> assignment

%%

/* descriptions of expected inputs     corresponding actions (in C) */

line    : assignment ';'		{;}
		| exit_command ';'		{exit(EXIT_SUCCESS);}
		| print exp ';'			{printf("Printing %f\n", $2);}
		| line assignment ';'	{;}
		| line print exp ';'	{printf("Printing %f\n", $3);}
		| line exit_command ';'	{exit(EXIT_SUCCESS);}
        ;

assignment : identifier '=' exp  { updateSymbolVal($1,$3); }
			;
exp    	: exp '+' exp1          {$$ = $1 + $3;}
       	| exp '-' exp1          {$$ = $1 - $3;}
       	| exp1                  {$$ = $1;}
       	;
exp1	: exp1 '*' term			{$$ = $1 * $3;}
       	| exp1 '/' term			{$$ = $1 / $3;}
       	| exp1 '%' term			{$$ = (int)$1 % (int)$3;}
       	| term                  {$$ = $1;}
       	;			
term   	: number                {$$ = $1;}
		| identifier			{$$ = symbolVal($1);} 
		| userdouble			{$$=$1;}
        ;

%%                     /* C code */

int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

int main (void) {
	/* init symbol table */
	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
	}

	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 


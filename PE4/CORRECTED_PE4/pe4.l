%{
#include "pe4.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int line_no = 1;
%}

%option noyywrap

ID       [a-zA-Z_][a-zA-Z0-9_]*
INTNUM   [0-9]+
FLOATNUM [0-9]+\.[0-9]+

%%

"int"           { return INT; }
"float"         { return FLOAT; }

{FLOATNUM}      { yylval.fval = atof(yytext); return FLOAT_CONST; }
{INTNUM}        { yylval.ival = atoi(yytext); return INT_CONST; }

{ID}            { yylval.str = strdup(yytext); return ID; }

"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }
"="             { return '='; }
","             { return ','; }
";"             { return ';'; }
"("             { return '('; }
")"             { return ')'; }

[ \t\r]+        ;
\n              { line_no++; }

.               { printf("Unknown character: %s at line %d\n", yytext, line_no); }

%%
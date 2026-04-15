%{
#include "pe6.tab.h"
#include <string.h>
%}

%%
[a-zA-Z]+ {
    yylval.str = strdup(yytext);
    return ID;
}

[0-9]+ {
    yylval.str = strdup(yytext);
    return NUM;
}

"+" return '+';
"*" return '*';
"=" return '=';
"(" return '(';
")" return ')';
"\n" return '\n';

[ \t] ;
. ;

%%

int yywrap() { return 1; }
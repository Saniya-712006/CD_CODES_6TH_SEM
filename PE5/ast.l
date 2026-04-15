%{
#include "ast.h" 
#include "ast.tab.h"
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
"(" return '(';
")" return ')';

[ \t] ;
\n return '\n';
. ;

%%

int yywrap() { return 1; }
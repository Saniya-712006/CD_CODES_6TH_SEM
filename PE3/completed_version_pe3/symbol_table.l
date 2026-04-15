%{
#include "symbol_table.tab.h"
#include "symbol_table.h"
#include <string.h>

int line_num = 1;
int col_num = 1;
%}

%%
"int"           { return INT; }
"float"         { return FLOAT; }
"char"          { return CHAR; }

"static"        { return STATIC; }
"extern"        { return EXTERN; }
"auto"          { return AUTO; }
"register"      { return REGISTER; }

[0-9]+ {
    yylval.str = strdup(yytext);
    return NUMBER;
}

[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.str = strdup(yytext);
    return ID;
}

"*"     { return '*'; }
"["     { return '['; }
"]"     { return ']'; }
"="     { return '='; }

"("     { return '('; }
")"     { return ')'; }
"{"     { return '{'; }
"}"     { return '}'; }
","     { return ','; }
";"     { return ';'; }

[ \t]+  { col_num += yyleng; }

\n      { line_num++; col_num = 1; }

.       { col_num++; }

%%

int yywrap() { return 1; }
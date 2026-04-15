%{
#include "a2.h"
#include "a2.tab.h"
#include <string.h>
%}

%%
"if" return IF;
"else" return ELSE;
"do" return DO;
"while" return WHILE;

"<=" return LE;
">=" return GE;
"==" return EQ;
"!=" return NE;
"<" return '<';
">" return '>';

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
"{" return '{';
"}" return '}';
"(" return '(';
")" return ')';
";" return ';';

[ \t\n] ;
. ;

%%

int yywrap() { return 1; }
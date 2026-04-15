%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex();

int temp_count = 1;

// generate temporary variable
char* new_temp() {
    char* temp = (char*)malloc(10);
    sprintf(temp, "t%d", temp_count++);
    return temp;
}
%}

%union {
    char* str;
}

%token <str> ID NUM
%type <str> expr

%left '+'
%left '*'

%%

input:
    /* empty */
    | input line
;

line:
    ID '=' expr '\n' {
        printf("(=, %s, -, %s)\n", $3, $1);
    }
    | ID '=' expr {
        printf("(=, %s, -, %s)\n", $3, $1);
    }
;

expr:
    expr '+' expr {
        char* t = new_temp();
        printf("(+, %s, %s, %s)\n", $1, $3, t);
        $$ = t;
    }
    | expr '*' expr {
        char* t = new_temp();
        printf("(*, %s, %s, %s)\n", $1, $3, t);
        $$ = t;
    }
    | '(' expr ')' {
        $$ = $2;
    }
    | ID {
        $$ = $1;
    }
    | NUM {
        $$ = $1;
    }
;

%%

void yyerror(const char *s) {
    printf("Error: %s\n", s);
}

int main() {
    printf("Enter expressions:\n");
    yyparse();
    return 0;
}
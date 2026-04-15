%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"

void yyerror(const char *s);
int yylex();

Node* root;
%}

%union {
    char* str;
    Node* node;
}

%token <str> ID NUM
%type <node> expr

%left '+'
%left '*'

%%

input:
    /* empty */
    | input line
;

line:
    expr '\n' {
        postorder($1);
        printf("\n");
    }
    | expr {
        postorder($1);
        printf("\n");
    }
;

expr:
    expr '+' expr {
        $$ = create_node("+", $1, $3);
    }
    | expr '*' expr {
        $$ = create_node("*", $1, $3);
    }
    | '(' expr ')' {
        $$ = $2;
    }
    | ID {
        $$ = create_node($1, NULL, NULL);
    }
    | NUM {
        $$ = create_node($1, NULL, NULL);
    }
;

%%

void yyerror(const char *s) {
    printf("Error: %s\n", s);
}

int main() {
    printf("Enter expression:\n");
    yyparse();
    return 0;
}
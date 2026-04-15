%{
#include <stdio.h>
#include <stdlib.h>
#include "a2.h"

void yyerror(const char *s);
int yylex();

Node* root;
%}

%union {
    char* str;
    Node* node;
}

%token <str> ID NUM
%token IF ELSE DO WHILE
%token LE GE EQ NE

%type <node> stmt stmt_list expr cond
%type <str> rel

%left '+'
%left '*'

%%

program:
    stmt_list {
        root = $1;

        printf("\nPOSTORDER TRAVERSAL:\n\n");
        print_postorder(root);
        printf("\n\n");

        generate_IC(root);
    }
;

stmt_list:
    stmt_list stmt {
        $$ = append($1, $2);
    }
    | stmt {
        $$ = $1;
    }
;

stmt:
    ID '=' expr ';' {
        $$ = create_node("ASSIGN", $1, $3, NULL, NULL);
    }

    | IF '(' cond ')' '{' stmt_list '}' ELSE '{' stmt_list '}' {
        $$ = create_node("IF", "", $3, $6, $10);
    }

    | DO '{' stmt_list '}' WHILE '(' cond ')' ';' {
        $$ = create_node("DO", "", $3, $7, NULL);
    }
;

cond:
    ID rel ID {
        $$ = create_node("REL", $2,
                         create_node("ID", $1, NULL, NULL, NULL),
                         create_node("ID", $3, NULL, NULL, NULL),
                         NULL);
    }
;

rel:
      '<' { $$ = "<"; }
    | '>' { $$ = ">"; }
    | LE  { $$ = "<="; }
    | GE  { $$ = ">="; }
    | EQ  { $$ = "=="; }
    | NE  { $$ = "!="; }
;

expr:
    expr '+' expr {
        $$ = create_node("OP", "+", $1, $3, NULL);
    }
    | expr '*' expr {
        $$ = create_node("OP", "*", $1, $3, NULL);
    }
    | ID {
        $$ = create_node("ID", $1, NULL, NULL, NULL);
    }
    | NUM {
        $$ = create_node("NUM", $1, NULL, NULL, NULL);
    }
;

%%

void yyerror(const char *s) {
    printf("Error: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}
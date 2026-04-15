%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"

extern int line_num;
extern int col_num;

char current_type[50];
char current_storage[20] = "auto";

void yyerror(const char *s);
int yylex();
%}

%union {
    char* str;
}

%token <str> ID NUMBER
%token INT FLOAT CHAR
%token STATIC EXTERN AUTO REGISTER


%%

program:
    program element
    | element
    ;

element:
    declaration
    | function
    | usage
    ;

usage:
    ID ';' {
        add_use($1, line_num);
    }
    ;

declaration:
    type declarator_list ';'
    ;

type:
    INT    { strcpy(current_type, "int"); }
    | FLOAT  { strcpy(current_type, "float"); }
    | CHAR   { strcpy(current_type, "char"); }
    ;

declarator_list:
    declarator
    | declarator_list ',' declarator
    ;

declarator:
      ID
        {
            insert_symbol($1, "variable", current_type,
                          current_storage,
                          get_size(current_type),
                          line_num, col_num, "NULL");
        }

    | ID '=' NUMBER
        {
            insert_symbol($1, "variable", current_type,
                          current_storage,
                          get_size(current_type),
                          line_num, col_num, $3);
        }

    | '*' ID
        {
            char full_type[100];
            sprintf(full_type, "%s *", current_type);

            insert_symbol($2, "variable", full_type,
                          current_storage,
                          get_size(current_type),
                          line_num, col_num, "NULL");
        }

    | '*' ID '=' NUMBER
        {
            char full_type[100];
            sprintf(full_type, "%s *", current_type);

            insert_symbol($2, "variable", full_type,
                          current_storage,
                          get_size(current_type),
                          line_num, col_num, $4);
        }

    | ID '[' NUMBER ']'
        {
            char full_type[100];
            sprintf(full_type, "%s[%s]", current_type, $3);

            insert_symbol($1, "variable", full_type,
                          current_storage,
                          get_size(current_type),
                          line_num, col_num, "NULL");
        }

    | ID '[' NUMBER ']' '=' NUMBER
        {
            char full_type[100];
            sprintf(full_type, "%s[%s]", current_type, $3);

            insert_symbol($1, "variable", full_type,
                          current_storage,
                          get_size(current_type),
                          line_num, col_num, $6);
        }
;

function:
    type ID
    {
        // insert function at global scope
        insert_symbol($2, "function", current_type,
                      current_storage, 0,
                      line_num, col_num, NULL);

        scope_level = 1;   // now enter function scope
    }
    '(' param_list ')'
    block
    {
        scope_level = 0;   // exit function scope
    }
;

param_list:
    param
    | param_list ',' param
    | 
    ;

param:
    type ID {
        insert_symbol($2, "parameter", current_type,
                      "auto",
                      get_size(current_type),
                      line_num, col_num, NULL);
    }
    ;

block:
    '{'
    program
    '}'
;

%%

void yyerror(const char *s) {
    printf("Error: %s\n", s);
}

int main() {
    yyparse();
    display_table();
    return 0;
}
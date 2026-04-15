%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int line_no;
extern FILE *yyin;

void yyerror(const char *s);

#define MAX_SYMBOLS 200

typedef struct {
    char name[50];
    char type[10];   // int / float
    double value;
    int initialized;
} Symbol;

/* Internal helper type for functions */
typedef struct {
    double val;
    char type[10];
} EvalType;

Symbol symtab[MAX_SYMBOLS];
int symcount = 0;
char current_decl_type[10];

int lookup(char *name) {
    for (int i = 0; i < symcount; i++) {
        if (strcmp(symtab[i].name, name) == 0) return i;
    }
    return -1;
}

void insert_symbol(char *name, char *type) {
    if (lookup(name) != -1) {
        printf("Error: Variable '%s' already declared at line %d\n", name, line_no);
        return;
    }
    strcpy(symtab[symcount].name, name);
    strcpy(symtab[symcount].type, type);
    symtab[symcount].value = 0;
    symtab[symcount].initialized = 0;
    symcount++;
}

void update_symbol(char *name, double val, char *type) {
    int idx = lookup(name);
    if (idx == -1) {
        printf("Error: Variable '%s' not declared at line %d\n", name, line_no);
        return;
    }

    if (strcmp(symtab[idx].type, "int") == 0 && strcmp(type, "float") == 0) {
        printf("Error: Type mismatch assigning float to int variable '%s' at line %d\n", name, line_no);
        return;
    }

    symtab[idx].value = val;
    symtab[idx].initialized = 1;
}

void print_symtab() {
    printf("\n=========== SYMBOL TABLE ===========\n");
    printf("%-10s %-10s %-10s %-12s\n", "Name", "Type", "Value", "Initialized");
    printf("------------------------------------\n");
    for (int i = 0; i < symcount; i++) {
        if (symtab[i].initialized)
            printf("%-10s %-10s %-10g %-12s\n", symtab[i].name, symtab[i].type, symtab[i].value, "Yes");
        else
            printf("%-10s %-10s %-10s %-12s\n", symtab[i].name, symtab[i].type, "NULL", "No");
    }
    printf("====================================\n");
}
%}

%union {
    int ival;
    double fval;
    char *str;
    struct {
        double val;
        char type[10];
    } expr;
}

%token INT FLOAT
%token <str> ID
%token <ival> INT_CONST
%token <fval> FLOAT_CONST

%type <expr> expr term factor

%left '+' '-'
%left '*' '/'

%%

program
    : stmt_list
      {
          print_symtab();
      }
    ;

stmt_list
    : stmt_list stmt
    | stmt
    ;

stmt
    : declaration ';'
    | assignment ';'
    ;

declaration
    : type id_list
    ;

type
    : INT   { strcpy(current_decl_type, "int"); }
    | FLOAT { strcpy(current_decl_type, "float"); }
    ;

id_list
    : ID
      {
          insert_symbol($1, current_decl_type);
          free($1);
      }
    | id_list ',' ID
      {
          insert_symbol($3, current_decl_type);
          free($3);
      }
    ;

assignment
    : ID '=' expr
      {
          update_symbol($1, $3.val, $3.type);
          free($1);
      }
    ;

expr
    : expr '+' term
      {
          $$.val = $1.val + $3.val;
          if (strcmp($1.type, "float") == 0 || strcmp($3.type, "float") == 0)
              strcpy($$.type, "float");
          else
              strcpy($$.type, "int");
      }
    | expr '-' term
      {
          $$.val = $1.val - $3.val;
          if (strcmp($1.type, "float") == 0 || strcmp($3.type, "float") == 0)
              strcpy($$.type, "float");
          else
              strcpy($$.type, "int");
      }
    | term
      {
          $$ = $1;
      }
    ;

term
    : term '*' factor
      {
          $$.val = $1.val * $3.val;
          if (strcmp($1.type, "float") == 0 || strcmp($3.type, "float") == 0)
              strcpy($$.type, "float");
          else
              strcpy($$.type, "int");
      }
    | term '/' factor
      {
          $$.val = $1.val / $3.val;
          strcpy($$.type, "float");
      }
    | factor
      {
          $$ = $1;
      }
    ;

factor
    : INT_CONST
      {
          $$.val = $1;
          strcpy($$.type, "int");
      }
    | FLOAT_CONST
      {
          $$.val = $1;
          strcpy($$.type, "float");
      }
    | ID
      {
          int idx = lookup($1);
          if (idx == -1) {
              printf("Error: Variable '%s' not declared at line %d\n", $1, line_no);
              $$.val = 0;
              strcpy($$.type, "int");
          } else if (!symtab[idx].initialized) {
              printf("Warning: Variable '%s' used before initialization at line %d\n", $1, line_no);
              $$.val = symtab[idx].value;
              strcpy($$.type, symtab[idx].type);
          } else {
              $$.val = symtab[idx].value;
              strcpy($$.type, symtab[idx].type);
          }
          free($1);
      }
    | '(' expr ')'
      {
          $$ = $2;
      }
    ;

%%

void yyerror(const char *s) {
    printf("Parse error: %s at line %d\n", s, line_no);
}

int main() {
    yyin = fopen("input.c", "r");
    if (!yyin) {
        printf("Could not open input file.\n");
        return 1;
    }

    yyparse();
    fclose(yyin);
    return 0;
}
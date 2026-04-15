#include <stdio.h>
#include <string.h>
#include "symbol_table.h"

Symbol table[MAX_SYMBOLS];
int symbol_count = 0;
int scope_level = 0;

// int get_size(char* type) {
//     if (strstr(type, "int")) return 4;
//     if (strstr(type, "float")) return 4;
//     if (strstr(type, "char")) return 1;
//     return 0;
// }

int get_size(char* type) {
    int base = 0;

    if (strstr(type, "int")) base = 4;
    else if (strstr(type, "float")) base = 4;
    else if (strstr(type, "char")) base = 1;

    // check if array
    char *start = strchr(type, '[');

    if (start) {
        int n;
        sscanf(start, "[%d]", &n);  // extract number
        return base * n;
    }

    return base;
}

void insert_symbol(char* name, char* kind, char* type,
                   char* storage, int size,
                   int line, int column, char* init) {

    strcpy(table[symbol_count].name, name);
    strcpy(table[symbol_count].kind, kind);
    strcpy(table[symbol_count].type, type);
    strcpy(table[symbol_count].storage_class, storage);

    table[symbol_count].size = size;
    table[symbol_count].scope = scope_level;
    table[symbol_count].line = line;
    table[symbol_count].column = column;

    if (init)
        strcpy(table[symbol_count].initializer, init);
    else
        strcpy(table[symbol_count].initializer, "NULL");

    table[symbol_count].use_count = 0;

    symbol_count++;
}

void add_use(char* name, int line) {
    for (int i = symbol_count - 1; i >= 0; i--) {
        if (strcmp(table[i].name, name) == 0) {
            int c = table[i].use_count;
            table[i].use_lines[c] = line;
            table[i].use_count++;
            return;
        }
    }
}

void display_table() {
    printf("\nSYMBOL TABLE:\n");
    printf("-------------------------------------------------------------------------------------------------\n");
    printf("Name\tKind\tType\tStorage\t\tSize\tScope\tLine\tCol\tInit\tUses\n");
    printf("-------------------------------------------------------------------------------------------------\n");

    for (int i = 0; i < symbol_count; i++) {
        printf("%s\t%s\t%s\t%s\t%d\t%d\t%d\t%d\t%s\t",
            table[i].name,
            table[i].kind,
            table[i].type,
            table[i].storage_class,
            table[i].size,
            table[i].scope,
            table[i].line,
            table[i].column,
            table[i].initializer
        );

        for (int j = 0; j < table[i].use_count; j++) {
            printf("%d ", table[i].use_lines[j]);
        }
        printf("\n");
    }
}
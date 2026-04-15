#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#define MAX_SYMBOLS 1000
#define MAX_USES 50

typedef struct {
    char name[50];
    char kind[20];
    char type[100];     // now includes pointer/array info
    char storage_class[20];
    int size;
    int scope;
    int line;
    int column;

    char initializer[50];

    int use_count;
    int use_lines[MAX_USES];

} Symbol;

extern Symbol table[MAX_SYMBOLS];
extern int symbol_count;
extern int scope_level;

void insert_symbol(char* name, char* kind, char* type,
                   char* storage, int size,
                   int line, int column, char* init);

void add_use(char* name, int line);
int get_size(char* type);
void display_table();

#endif
#ifndef AST_IC_H
#define AST_IC_H

typedef struct Node {
    char type[20];     // IF, DO, ASSIGN, OP, REL, ID, NUM
    char value[20];    // operator / variable

    struct Node *left;
    struct Node *right;
    struct Node *third;   // for IF (else block)
    struct Node *next;    // for statement list
} Node;

Node* create_node(char* type, char* value, Node* l, Node* r, Node* t);
Node* append(Node* list, Node* stmt);
void print_postorder(Node* root);

void generate_IC(Node* root);

#endif
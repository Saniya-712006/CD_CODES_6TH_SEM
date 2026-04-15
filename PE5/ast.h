#ifndef AST_H
#define AST_H

typedef struct Node {
    char value[20];
    struct Node *left;
    struct Node *right;
} Node;

Node* create_node(char* val, Node* left, Node* right);
void postorder(Node* root);

#endif
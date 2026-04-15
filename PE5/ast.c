#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"

Node* create_node(char* val, Node* left, Node* right) {
    Node* node = (Node*)malloc(sizeof(Node));
    strcpy(node->value, val);
    node->left = left;
    node->right = right;
    return node;
}

void postorder(Node* root) {
    if (root == NULL) return;

    postorder(root->left);
    postorder(root->right);
    printf("%s ", root->value);
}
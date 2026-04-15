#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "a2.h"

int temp_count = 1;
int label_count = 1;

char* new_temp() {
    char* t = malloc(10);
    sprintf(t, "t%d", temp_count++);
    return t;
}

char* new_label() {
    char* l = malloc(10);
    sprintf(l, "L%d", label_count++);
    return l;
}

Node* create_node(char* type, char* value, Node* l, Node* r, Node* t) {
    Node* n = malloc(sizeof(Node));
    strcpy(n->type, type);
    strcpy(n->value, value);
    n->left = l;
    n->right = r;
    n->third = t;
    n->next = NULL;
    return n;
}

Node* append(Node* list, Node* stmt) {
    if (!list) return stmt;
    Node* temp = list;
    while (temp->next) temp = temp->next;
    temp->next = stmt;
    return list;
}

/* -------- IC GENERATION -------- */

char* gen_expr(Node* n) {
    if (strcmp(n->type, "ID") == 0 || strcmp(n->type, "NUM") == 0)
        return n->value;

    char* t1 = gen_expr(n->left);
    char* t2 = gen_expr(n->right);

    char* t = new_temp();
    printf("(%s, %s, %s, %s)\n", n->value, t1, t2, t);
    return t;
}

void generate_IC(Node* root) {
    while (root) {

        if (strcmp(root->type, "ASSIGN") == 0) {
            char* t = gen_expr(root->left);
            printf("(=, %s, -, %s)\n", t, root->value);
        }

        else if (strcmp(root->type, "IF") == 0) {
            char* L1 = new_label();
            char* L2 = new_label();
            char* L3 = new_label();

            printf("if %s %s %s goto %s\n",
                   root->left->left->value,
                   root->left->value,
                   root->left->right->value,
                   L1);

            printf("goto %s\n", L2);

            printf("%s:\n", L1);
            generate_IC(root->right);

            printf("goto %s\n", L3);

            printf("%s:\n", L2);
            generate_IC(root->third);

            printf("%s:\n", L3);
        }

        else if (strcmp(root->type, "DO") == 0) {
            char* L1 = new_label();

            printf("%s:\n", L1);
            generate_IC(root->left);

            printf("if %s %s %s goto %s\n",
                   root->right->left->value,
                   root->right->value,
                   root->right->right->value,
                   L1);
        }

        root = root->next;
    }
}
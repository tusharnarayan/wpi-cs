/* File tree.h
 * Contains structure definition for the binary tree.
 * Also has prototypes for tree functions.
 * @author Tushar Narayan
 */

#ifndef TREE_H
#define TREE_H

/** Struct treenode. Holds a pointer to a C-style string, and
 * pointers to a left and right child.
 */

struct treenode {
  char* value;
  struct treenode *left_child;
  struct treenode *right_child;
};

typedef struct treenode Tnode; // for convenience

static Tnode* NULL_NODE = (Tnode*) NULL; //constant pointer to a null node

// Function prototypes

/* Function add_tnode
 * Takes in pointer to an existing node or NULL, and a value.
 * If the pointer is NULL, allocates a new node, assigns value,
 * and returns pointer to the newly-allocated node.
 * If the pointer is not NULL, compares the value to that in the node
 * pointed to, and then calls the function on child tree as appropriate.
 * If the pointer is not null, just returns 'current_node',
 * because it is the root of the subtree,
 * Returns current node in case of a duplicate value.
 * @param *current_node pointer to existing node (or NULL)
 * @param value the string to be added to the node
 * @return pointer to newly-allocated node
 */
Tnode* add_tnode(Tnode *current_node, char* value);

/* Function print_descending
 * traverses the tree and prints strings in descending order.
 * @param current_node pointer to current node (or NULL)
 */
void print_descending(Tnode* current_node);

/*Function free_nodes
 * traverses the tree and frees all the nodes.
 * @param current_node root node of the tree that has to be freed
 */
void free_nodes(Tnode* current_node);

#endif

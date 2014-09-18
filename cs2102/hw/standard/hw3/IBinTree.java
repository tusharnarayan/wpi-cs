import java.lang.Math;

interface IBinTree<T>{
  // determines whether element is in the tree
  boolean hasElt(T e);
  // returns number of nodes in the tree; counts duplicate elements as separate items
  int size();
  // returns depth of longest branch in the tree
  int height();
}

class MtBT<T> implements IBinTree<T>{
  //constructor
  MtBT(){}
  
  // returns false since empty tree has no elements
  public boolean hasElt(T e) {
    return false;
  }
  
  // returns 0 since enpty tree has no elements
  public int size() {
    return 0;
  }
  
  // returns 0 since empty tree has no branches
  public int height() {
    return 0;
  }
}

class DataBT<T> implements IBinTree<T>{
  T data;
  IBinTree<T> left;
  IBinTree<T> right;
  
  //constructor
  DataBT(T data, IBinTree<T> left, IBinTree<T> right) {
    this.data = data;
    this.left = left;
    this.right = right;
  }
  
  // determines whether this node or node in subtree has given element
  public boolean hasElt(T e) {
    return this.data == e || this.left.hasElt(e) || this.right.hasElt(e) ;
  }
  
  // adds 1 to the number of nodes in the left and right subtrees
  public int size() {
    return 1 + this.left.size() + this.right.size();
  }
  
  // adds 1 to the height of the taller subtree
  public int height() {
    return 1 + Math.max(this.left.height(), this.right.height());
  }
}
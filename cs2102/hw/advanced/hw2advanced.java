interface ISet {
  // PROPERTY: No duplicate elements
  // PROPERTY: Elements are unordered
  // returns set containing all existing elements and the given element
  ISet addElt (int elt);
  // returns set containing all existing elements except the given element
  ISet remElt (int elt);
  // returns the number of distinct elements in the set
  int size ();
  // determines whether given element is in the set
  boolean hasElt (int elt);
}

//-------------------------------------------------------------------------

interface IAVLT extends ISet {
  // produces the largest element in the BST
  int largestElt();
  IAVLT remParent(IAVLT sibling);
  IAVLT mergeToRemoveParent(IAVLT sibling);
  IAVLT balanceTree(IAVLT unbalancedTree);
}
  
//-------------------------------------------------------------------------

class MtAVLT implements IAVLT  {
  MtAVLT() {}
  
  // returns the number of distinct elements in the set
  public int size () { return 0; }
  
  // returns set containing all existing elements and the given element
  public IAVLT addElt (int elt) {
    return new DataAVLT(elt, new MtAVLT(), new MtAVLT());
  }

  // returns set containing all existing elements except the given element
  public IAVLT remElt (int elt) { return this; }

  // determines whether the given element is in the set
  public boolean hasElt (int elt) { return false; }

  // largestElt not well-defined on empty AVLTs, so raises an error
  public int largestElt () {
    throw new RuntimeException("shouldn't call largestElt on MtAVLT") ;
  }
  
  // returns the other sibling to remove parent of an empty sibling
  public IAVLT remParent(IAVLT rightsibling) {
    return rightsibling;
  }
  
  // "this" is the right sibling; leftsibling is a DataAVLT
  public IAVLT mergeToRemoveParent(IAVLT leftsibling) {
    return leftsibling;
  }
  
  //balancing MtAVLTs requires no operation other than just returning the empty tree
  public IAVLT balanceTree(IAVLT unbalancedTree){
    return this;
  }
}

//-------------------------------------------------------------------------

class DataAVLT implements IAVLT  {
  int data;
  IAVLT left;
  IAVLT right;
  
  DataAVLT(int data, IAVLT left, IAVLT right) {
    this.data = data;
    this.left = left;
    this.right = right;
  }
  
  // returns the number of distinct elements in the set
  public int size() {
    return 1 + this.left.size() + this.right.size();
  }
  
  // returns set containing all existing elements and the given element
  public IAVLT addElt (int elt) {
    if (elt == this.data)
      return this; // not storing duplicate values
    else if (elt < this.data)
      return new DataAVLT (this.data,
                          (IAVLT) this.left.addElt(elt),
                          this.right);
    else // elt > this.data
      return new DataAVLT (this.data,
                          this.left,
                          (IAVLT) this.right.addElt(elt));
  }
  
  // produces the largest element in the AVLT
  public int largestElt() {
    if (this.right instanceof MtAVLT) 
      return this.data;
    else return this.right.largestElt();
  }
  
  // determines whether the given element is in the set
  public boolean hasElt (int elt) {
    if (elt == this.data) 
      return true; 
    else if (elt < this.data)
      return this.left.hasElt(elt);
    else // elt > this.data
      return this.right.hasElt(elt);
  }
  
  // returns set containing all existing elements except the given element
  public IAVLT remElt (int elt) {
    if (elt == this.data) 
      return this.left.remParent(this.right);
    else if (elt < this.data)
      return new DataAVLT(this.data, (IAVLT) this.left.remElt(elt), this.right);
    else // (elt > this.data)
      return new DataAVLT(this.data, this.left, (IAVLT) this.right.remElt(elt)) ;
  }
  
  // returns the other sibling to remove parent of an empty sibling
  public IAVLT remParent(IAVLT rightSibling) {
    return rightSibling.mergeToRemoveParent(this);
  }
  
  // returns DataAVLT resulting from removing parent when both children are DataAVLTs
  public IAVLT mergeToRemoveParent(IAVLT leftSibling) {
    // "this" refers to the original right sibling of the parent being deleted
    // here, could decide whether to use largest-in-left or smallest-in-right
    //   and branch accordingly.  Only showing largest-in-left code for now
    int newRoot = leftSibling.largestElt();
    return new DataAVLT(newRoot,
                       (IAVLT) leftSibling.remElt(newRoot),
                       this); 
  }
  
  //balancing function for DataAVLT
  public IAVLT balanceTree(IAVLT unbalancedTree){
    int balanceFactor = this.heightLeftSub() - this.heightRightSub();
    if(balanceFactor = -2){
      
    }
    else if(balanceFactor = 2){
    }
    else //the tree is a balanced AVL tree
      return this;
  }
}
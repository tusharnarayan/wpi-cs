import java.util.Random;

interface IHeap<T extends Comparable<T>> extends IBinTree<T> {
  // adds given element to the heap without removing other elements
  IHeap<T> addElt(T e);
  
  // removes one occurrence of the smallest element from the heap
  IHeap<T> remMinElt();
  
  // Merge the current heap with another heap
  IHeap<T> merge(IHeap<T> withHeap);
  
  // Determine if the root of this heap is bigger than the given element
  boolean isBigger(T e);
  
  // Returns the root of the Heap
  T giveRoot();
  
  // Checks if the object is still a valid heap
  boolean isHeap();
  
  //Checks the result of the addElt function
  boolean testAddElt(T e);
  
  //Checks the result of the remMinElt function
  boolean testRemMinElt();
  
  //compares two heaps when one of them is the old heap with one element added to it
  boolean compareHeapsWithRoot(IHeap<T> oldHeap, IHeap<T> newHeap);
  
  //compares two heaps when one of them is the old heap but with the root element removed
  boolean compareHeapsWithoutRoot(IHeap<T> oldHeap, IHeap<T> newHeap);
  
  //returns the left half of the heap
  IHeap<T> giveLeft();
  
  //returns the right half of the heap
  IHeap<T> giveRight();
}

class MtHeap<T extends Comparable<T>> implements IHeap<T> {
  //constructor
  MtHeap(){}
  
  @Override
  // Since a MtHeap is empty, it does not have the element
    public boolean hasElt(T e) {
    return false;
  }
  
  @Override
  // A MtHeap has a size of 0
    public int size() {
    return 0;
  }
  
  @Override
  // A MtHeap has a height of 0
    public int height() {
    return 0;
  }
  
  @Override
  // If you add an element to a MtHeap, you create a new DataHeap
    public IHeap<T> addElt(T e) {
    return new DataHeap<T>(e, new MtHeap<T>(), new MtHeap<T>());
  }
  
  @Override
  // The min element of an empty heap returns an empty heap.
    public IHeap<T> remMinElt() {
    return new MtHeap<T>();
  }
  
  @Override
  // An empty heap should always lose a competition for which root is smaller (for the merge function)
    public boolean isBigger(T e) {
    return true;
  }
  
  @Override
  // An empty heap merged with another heap is the other heap (identity).
    public IHeap<T> merge(IHeap<T> withHeap) {
    return withHeap;
  }
  
  //asking an empty heap for its root is not a well-defined operation, so raises an error
  public T giveRoot(){
    throw new RuntimeException("MtHeaps don't have any root.") ;
  }
  
  // An empty heap is still a valid heap.
  public boolean isHeap(){
    return true;
  }
  
  //addElt is always true for an empty heap since a new DataHeap is created
  public boolean testAddElt(T e){
    return true;
  }
  
  //remMinElt on a MtHeap creates a new MtHeap, hence the test is always true
  public boolean testRemMinElt(){
    return true;
  }
  
  //two empty heaps are always the same
  public boolean compareHeapsWithRoot(IHeap<T> oldHeap, IHeap<T> newHeap){
    return true;
  }
  
  //two empty heaps are always the same
  public boolean compareHeapsWithoutRoot(IHeap<T> oldHeap, IHeap<T> newHeap){
    return true;
  }
  
  //the left half of an empty heap is still an empty heap
  public IHeap<T> giveLeft(){
    return new MtHeap<T>();
  }
  
  //the right half of an empty heap is still an empty heap
  public IHeap<T> giveRight(){
    return new MtHeap<T>();
  }
}

class DataHeap<T extends Comparable<T>> extends DataBT<T> implements IHeap<T>{
  IHeap<T> left;
  IHeap<T> right;
  
  //constructor
  DataHeap(T data, IHeap<T> left, IHeap<T> right) {
    super (data, left, right);
    this.left = left;
    this.right = right;
    this.data = data;
  }
  
  //merges two heaps
  public IHeap<T> merge(IHeap<T> withHeap) {
    T newRoot;
    IHeap<T> H1, H2, H3;
    
    // determine the new root value and the three subtrees to consider merging
    if (withHeap.isBigger(this.data)) {
      newRoot = this.data;
      H1 = (IHeap<T>) this.left;
      H2 = (IHeap<T>) this.right;
      H3 = withHeap;
    } else {
      // Since a MtHeap will always return true on isBigger, satisfying
      //  the first condition, we know that withHeap is a DataHeap.
      //  Therefore, we can cast it.
      newRoot = ((DataHeap<T>) withHeap).data;
      H1 = ((DataHeap<T>) withHeap).left;
      H2 = ((DataHeap<T>) withHeap).right;
      H3 = this;
    }
    
    // choose which trees to merge and construct the new tree
    if (H1.height() > H2.height() && H1.height() > H3.height()) {
      return new DataHeap<T> (newRoot, H1, H2.merge (H3));
    } else if (H2.height() > H1.height() && H2.height() > H3.height()) {
      return new DataHeap<T> (newRoot, H2, H1.merge (H3));
    } else if (H3.height() > H1.height() && H3.height() > H2.height()){
      return new DataHeap<T> (newRoot, H3, H1.merge (H2));
    } else {
      // If the two bigger heaps are of the same size, choose one at random.
      Random coinFlip = new Random();
      if (H1.height() == H2.height()) {
        if (coinFlip.nextInt() % 2 == 1) {
          return new DataHeap<T> (newRoot, H1, H2.merge(H3));
        } else {
          return new DataHeap<T> (newRoot, H2, H1.merge(H3));
        }
      } else if (H2.height() == H3.height()) {
        if (coinFlip.nextInt() % 2 == 1) {
          return new DataHeap<T> (newRoot, H2, H3.merge(H1));
        } else {
          return new DataHeap<T> (newRoot, H3, H2.merge(H1));
        }
      } else {
        if (coinFlip.nextInt() %2 == 1) {
          return new DataHeap<T> (newRoot, H3, H1.merge(H2));
        } else {
          return new DataHeap<T> (newRoot, H1, H3.merge(H2));
        }
      }
    }
  }
  
  //adds an element to the heap
  @Override
  public IHeap<T> addElt(T e) {
    return this.merge(new DataHeap<T>(e, new MtHeap<T>(), new MtHeap<T>()));
  }
  
  //removes the smallest element, i.e. the root, from the heap
  @Override
  public IHeap<T> remMinElt() {
    return this.right.merge(this.left);
  }
  
  //returns a boolean indication whether the data element of the heap is greater than that of the other heap
  @Override
  public boolean isBigger(T e) {
    return (this.data.compareTo(e) > 0);
  }
  
  //returns the value of the root of the heap
  public T giveRoot(){
    return this.data;
  }
  
  //returns the left half of the heap
  public IHeap<T> giveLeft(){
    return this.left;
  }
  
  //returns the right half of the heap
  public IHeap<T> giveRight(){
    return this.right;
  }
  
  //checks to see whether the structure is actually a heap 
  //(with respect to the properties of the heap - checks if the root is the smallest element in the entire structure
  public boolean isHeap(){
    try{
      if (((!isBigger(this.left.giveRoot())) && (this.left.isHeap()))
            &&
          ((!isBigger(this.right.giveRoot())) && (this.right.isHeap())))
        return true;
      else return false;
    }
    //Exception thrown when we ask MtHeap for its data element, dealing with that here
    catch(RuntimeException e){
      //if the MtHeap is asked for its data element, that means that the root of the structure is the smallest
      //among all the members of the structure, and hence the structure is a valid heap. So, return true for the
      //MtHeap exception case
      return true; 
    }}
  
  //compares two heaps when one of them is the other heap with just one element added to it
  public boolean compareHeapsWithRoot(IHeap<T> heap1, IHeap<T> heap2){
    try{
      if(//checks if the new heap contains the root element of the old heap
         heap2.hasElt(heap1.giveRoot())
           &&
         //recursively checks if the new heap has all the elements of the left half of the old heap
         compareHeapsWithRoot(heap1.giveLeft(), heap2)
           &&
         //recursively checks if the new heap has all the elements of the right half of the old heap
         compareHeapsWithRoot(heap1.giveRight(), heap2)){
        return true;
      }
      else return false; //if the new heap doesn't have any one of the elements of the old heap, then the heaps are not comparable
    }
    catch(RuntimeException e){
      //if the MtHeap is asked for its data element, that means that the new heap has all the elements of the respective side
      //of the old heap that the function is checking. Hence, the heaps are comparable (upto that point), so return true
      //(and continue recursion as needed, or declare the final result)
      return true;
    }
  }
  
// the testAddElt uses the addElt function and tests its output
  public boolean testAddElt(T e){
    //declaring a field oldHeap to hold the original heap so that it can be used to check
    //whether the new heap has all the elements of the original heap (otherwise carrying out the addElt operation
    //leaves no way to access the original heap, so comparison could not be carried out)
    IHeap<T> oldHeap = this;
    if(//checking if the original heap is a valid heap - if it isn't, then cannot even call the addElt function
       oldHeap.isHeap()){
      //calling the addElt function and saving the result in the field newHeap
      IHeap<T> newHeap = this.addElt(e);
      if(//checking to see if the new heap doesn't contain the element that was to be added to the old heap
         !(newHeap.hasElt(e)))
        return false;
      else if (//checking if the new heap doesn't meet the requirements for being a valid heap
               !(newHeap.isHeap()))
        return false;
      else if(//checking if the new heap has more than just one element as compared to the old heap
              !(oldHeap.size() + 1 == newHeap.size()))
        return false;
      else{//checking to see if the new heap has all the elements that the old heap had
        return compareHeapsWithRoot(oldHeap, newHeap);
      }
    }
    else return false;
  }
  
  //compares two heaps when one of them is the other heap with its original root removed
  public boolean compareHeapsWithoutRoot(IHeap<T> heap1, IHeap<T> heap2){
    try{
      //saving the heap of the old root in the field oldHeapRoot
      T oldHeapRoot = heap1.giveRoot();
      if(//the new heap should not have the old heap's root as its root
         heap2.giveRoot() != oldHeapRoot){
        if(//checking to see if the new heap has all the elements of the left half of the original heap
           //Note: we use compareHeapsWithRoot since the 'not having root of the original'
           //property only applies to the first level of the new heap
           compareHeapsWithRoot(heap1.giveLeft(), heap2)
             &&
           //checking to see if the new heap has all the elements of the right half of the original heap
           compareHeapsWithRoot(heap1.giveRight(), heap2)){
          return true;
        }
        else return false;
      }
      else{
        //if the new heap contains the root element of the old heap, then the remMinElt operation on the old heap was not successful
        return false; 
      }
    }
    catch(RuntimeException e){
      //if the MtHeap is asked for its data element, that means that the new heap has all the elements of the respective side
      //of the old heap that the function is checking. Hence, the heaps are comparable (upto that point), so return true
      //(and continue recursion as needed, or declare the final result)
      return true;
    }
  }
  
  // the testRemMinElt uses the remMinElt function and tests its output
  public boolean testRemMinElt(){
    //declaring a field oldHeap to hold the original heap so that it can be used to check
    //whether the new heap has all the elements of the original heap with the exception of the original root
    //(otherwise carrying out the addElt operation leaves no way to access the original heap, 
    //so comparison could not be carried out)
    IHeap<T> oldHeap = this;
    if(//checking if the original heap is a valid heap - if it isn't, then cannot even call the remMinElt function
       oldHeap.isHeap()){
      //calling the remMinElt function and saving the result in the field newHeap
      IHeap<T> newHeap = this.remMinElt();
      if(//checking to see if the new heap still contains the root element of the original heap
         newHeap.hasElt(oldHeap.giveRoot())) //if the root is still there, then the remMinElt was unsuccessful
        return false;
      else if(//checking if the new heap doesn't meet the requirements for being a valid heap
              !(newHeap.isHeap()))
        return false;
      else if (//checking if the new heap has less than just one element as compared to the old heap
               !(oldHeap.size() - 1 == newHeap.size()))
        return false;
      else{//checking to see if the new heap has all the elements that the old heap had 
        //(with the exception of the root of the original heap)
        return compareHeapsWithoutRoot(oldHeap, newHeap);
      }
    }
    else return false;
  }
}
/*Homework 6
 * 
 * Tushar Narayan
 * tnarayan
 * 
 * Saraf Rahman
 * strahman
 * 
 * Nikhil Godani
 * nsgodani
 * */

//class for plus formula trees

class Plus implements IFormula {
  IFormula left;
  IFormula right;
  
  Plus(IFormula left, IFormula right) {
    this.left = left;
    this.right = right;
  }
  
  public <R> R traverse(IProc<R> f) throws CellNotFoundExn{
    return f.processPlus(this.left.traverse(f), this.right.traverse(f));
  }
}
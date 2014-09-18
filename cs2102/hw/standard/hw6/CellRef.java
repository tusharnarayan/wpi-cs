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

//class for Cell References

class CellRef implements IFormula {
  String cellname;
  
  CellRef(String cellname) {
    this.cellname = cellname;
  }
  
  public <R> R traverse(IProc<R> f) throws CellNotFoundExn{
    return f.processCellRef(this);
  }
}
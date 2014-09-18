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

//visitor function that checks if the data has no references to any other cell

class NoRefs implements IProc<Boolean> {
  public Boolean processNum(Num n) {
    return true;
  }
  
  public Boolean processCellRef(CellRef c) {
    return false;
  }
  
  public Boolean processPlus(Boolean leftres, Boolean rightres) {
    return leftres && rightres;
  }
}
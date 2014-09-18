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

import java.util.LinkedList;

//visitor function that checks if the data has no cyclic expressions
class NoCyclicExpr implements IProc<Boolean> {
  SpreadSheet masterSpreadSheet;
  
  //constructor
  NoCyclicExpr(SpreadSheet masterSpreadSheet){
    this.masterSpreadSheet = masterSpreadSheet;
  }

  LinkedList<IFormula> visited = new LinkedList<IFormula>();
  
  //numbers have no cyclic expression, hence simply return true
  public Boolean processNum(Num n) {
    return true;
  }
  
  //CellRefs are references to another cell. Check if that brings in a cyclic expression.
  //When referring to another cell, put the value of that cell into the visited list;
  //and recursively call the traverse method. 
  //The method will return false when called upon an object that is already in the visited list.
  //Hence, infinite loops are prevented.
  public Boolean processCellRef(CellRef c) throws CellNotFoundExn {
    if(masterSpreadSheet.returnSheet().containsKey(c.cellname)){
      if(visited.contains(c)){
        return false;
      }
      else{
        visited.add(c);
        return masterSpreadSheet.returnSheet().get(c.cellname).traverse(this);
      }
    }
    else return true;
  }
  
  //for a plus formula tree, process both the halves and return the result
  public Boolean processPlus(Boolean leftres, Boolean rightres) {
    return leftres && rightres;
  }
}

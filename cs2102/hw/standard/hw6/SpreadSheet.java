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

import java.util.HashMap;

//class for the spreadsheet
class SpreadSheet implements ISpreadSheet{
  private HashMap<String, IFormula> masterSheet; //contain all the cells in the spreadsheet
  
  //constructor
  SpreadSheet(){
    masterSheet = new HashMap<String, IFormula>();
  }
  
  //function editContents allows user to edit the contents of the spreadsheet. throws appropriate exceptions
  //if the user is inputting a cyclic function or a reference to an uninstantiated cell
  public void editContents(String cellname, IFormula expr)throws CyclicException, CellNotFoundExn{
    this.masterSheet.put(cellname, expr);
    if(!(expr.traverse(new NoCyclicExpr(this)))){
      masterSheet.remove(cellname);
      throw new CyclicException(); 
    }
  }
  
  //function that allows the user to lookup the value of a particular cell.
  //throws exception if the user is looking up the value of an uninstantiated cell
  public Integer lookupValue(String forcell) throws CellNotFoundExn{
    if(masterSheet.containsKey(forcell)){
      IFormula forcellContent = masterSheet.get(forcell);
      return forcellContent.traverse(new ValueOf(this));
    }
    else throw new CellNotFoundExn();
  }
  
  //getter function
  public HashMap<String, IFormula> returnSheet(){
    return masterSheet; 
  }
}
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

//visitor function that returns the value of the cell
class ValueOf implements IProc<Integer> {
  SpreadSheet masterSpreadSheet;
  
  //constructor
  ValueOf(SpreadSheet masterSpreadSheet){
    this.masterSpreadSheet = masterSpreadSheet;
  }
  
  //second constructor 
  //constructor was overloaded so that calls can be made without passing the spreadsheet
  //in simple examples
  ValueOf(){}
  
  //simply return numerical value
  public Integer processNum(Num n) {
    return n.value;
  }
  
  //need to compute the value of the cell that the CellRef points to
  public Integer processCellRef(CellRef c) throws CellNotFoundExn{
    if ((masterSpreadSheet.returnSheet()).containsKey(c.cellname)){
      return masterSpreadSheet.returnSheet().get(c.cellname).traverse(this);
    }
    throw new CellNotFoundExn();
  }
  
  //compute both branches
  public Integer processPlus(Integer leftres, Integer rightres) {
    return leftres + rightres;
  }
}
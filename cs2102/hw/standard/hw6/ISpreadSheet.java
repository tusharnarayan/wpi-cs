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

//interface for spreadsheets

interface ISpreadSheet {
  void editContents(String cellname, IFormula expr) throws CyclicException, CellNotFoundExn;
  Integer lookupValue(String forcell) throws CellNotFoundExn;
}
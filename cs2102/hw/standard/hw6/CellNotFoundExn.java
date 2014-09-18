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

//exception for when the cell referenced in a formula does not exist in the spreadsheet

/*We decided to treat that as an exception, since no specific instructions were provided.
 * This can be easily switched out later for another implementation for as-yet uninstantiated cells.*/

class CellNotFoundExn extends Exception {
  CellNotFoundExn(){}
}
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

//interface for different types of data in a cell

interface IFormula {
  <R> R traverse(IProc<R> f) throws CellNotFoundExn;
}
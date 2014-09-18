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

//interface for processing different types of formulae

interface IProc<R> {
  R processNum(Num n);
  R processCellRef(CellRef c) throws CellNotFoundExn;
  R processPlus(R leftres, R rightres);
}

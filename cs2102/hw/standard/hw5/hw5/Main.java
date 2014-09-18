/*Homework 5
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

import tester.*;

class Main {
  static Examples E = new Examples () ;
  static Examples2 E2 = new Examples2 () ;
  
  public static void main(String[] args) {
    Tester.run (E) ;
    Tester.run (E2) ;
  }
}

//kept test cases in two different examples classes so as to provide separation between them
//The class Examples is for the WordFinder class - the LevDist function
//The class Examples2 is for the Graphs - both city and social
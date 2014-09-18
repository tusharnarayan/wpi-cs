/*Homework 5
 * Part 1
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

import tester.* ;

class Examples{
  Examples(){}
  
  WordFinder sampleWordFinder = new WordFinder();
  
  boolean test1(Tester t){
    return t.checkExpect(sampleWordFinder.LevDist("my", "my"), 0);
  }
  boolean test2(Tester t){
    return t.checkExpect(sampleWordFinder.LevDist("hi", "hi"), 0);
  }
  //optimize test
  boolean test3(Tester t){
    return t.checkExpect(sampleWordFinder.LevDist("", "hi"), 2);
  }
  boolean test4(Tester t){
    return t.checkExpect(sampleWordFinder.LevDist("me", ""), 2);
  }
  boolean test5(Tester t){
    return t.checkExpect(sampleWordFinder.LevDist("a", "ba"), 1);
  }
  boolean test6(Tester t){
    return t.checkExpect(sampleWordFinder.LevDist("cat", "bat"), 1);
  }
  
  boolean test7(Tester t){
    return t.checkExpect(sampleWordFinder.LevDist("cat", "carrot"), 3);
  }
  //optimize test
  boolean test8(Tester t){
    return t.checkExpect(sampleWordFinder.LevDist("cat", "cbrrot"), 4);
  }
  
  boolean test9(Tester t){
    return t.checkExpect(sampleWordFinder.LevDist("da", "dog"), 2);
  }
  //optimize test
  boolean test10(Tester t){
    return t.checkExpect(sampleWordFinder.LevDist("da", "day"), 1);
  }
  //optimize test
  boolean test11(Tester t){
    return t.checkExpect(sampleWordFinder.LevDist("da", "da"), 0);
  }
  
  boolean test12(Tester t){
    return t.checkExpect(sampleWordFinder.LevDist("my", "me"), 1);
  }
  
  boolean test13(Tester t){
    return t.checkExpect(sampleWordFinder.LevDist("cap", "cappuccino"), 7);
  }
  //optimize test
  boolean test14(Tester t){
    return t.checkExpect(sampleWordFinder.LevDist("capital", "cappuccino"), 7);
  }
  
  boolean test15(Tester t){
    return t.checkExpect(sampleWordFinder.LevDist("patchy", "patchwork"), 4);
  }
  //optimize test
  boolean test16(Tester t){
    return t.checkExpect(sampleWordFinder.LevDist("patchily", "patchwork"), 4);
  }
  
  //reusing the same two tests as test 13 and 14.
  //we found that with optimization, we get just two calls more to the function,
  //whereas we get lots more calls in case of the unoptimized version.
  //This is because it just finds and returns the value of the function call from the hashtable
  //in case of optimization.
  boolean test17(Tester t){
    return t.checkExpect(sampleWordFinder.LevDist("cap", "cappuccino"), 7);
  }
  //optimize test
  boolean test18(Tester t){
    return t.checkExpect(sampleWordFinder.LevDist("capital", "cappuccino"), 7);
  }
  
  //function to print the value of the counter.
  //name starts with the word 'test' so that the testing library will automatically call this function 
  void testTotalCalls(Tester t){
    System.out.println("Total of " + sampleWordFinder.totalCalls + " calls made to the LevDist function.");
  }
}
/*To test that the optimized version of WordFinder is correct:
 * We use a counter (totalCalls) that increments by 1 every time the function LevDist is called, and check its value
 * after all the test cases have been executed. The optimized version should result in the counter having a final value
 * lower than that in the case of the unoptimized version.
 * 
 * We observe that there are 508115 calls made in case of the unoptimized function, whereas there were 520 calls made
 * in the optimized version (for the same 18 tests).
 * This optimization is occurring due to the checking of the HashMap to see if it already has the value for the
 * particular two strings passed to the function. Same function calls hence do not result in the computation being repeated.
 * */
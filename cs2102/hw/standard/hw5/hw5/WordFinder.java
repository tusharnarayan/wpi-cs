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

import java.lang.Math;
import java.util.*;

class WordFinder{
  //totalCalls serves as a counter for the LevDist method
  int totalCalls = 0;
  
  //HashMap to store the already computed result of LevDist for pairs of strings
  HashMap<LinkedList<String>, Integer> alreadyComputed = new HashMap<LinkedList<String>, Integer>();
  
  //empty constructor
  WordFinder(){}
  
  //takes two strings, puts them in a linked list, and returns that list
  public LinkedList<String> putStringsInList(String str1, String str2){
    LinkedList<String> inputList = new LinkedList<String>();
    inputList.add(str1);
    inputList.add(str2);
    return inputList;
  }
  
  //computes the Levenshtein distance between two strings
  public int LevDist(String str1, String str2) {
    //counter for checking optimization using hashmap
    totalCalls++;
    
    if(alreadyComputed.containsKey(putStringsInList(str1, str2))){
      return alreadyComputed.get(putStringsInList(str1, str2));
    }
    else if (str1.equals(str2)){
      alreadyComputed.put(putStringsInList(str1, str2), 0);
      return 0;
    }
    else if (str1.equals("")){
      alreadyComputed.put(putStringsInList(str1, str2), str2.length());
      return str2.length();
    }
    else if (str2.equals("")){
      alreadyComputed.put(putStringsInList(str1, str2), str1.length());
      return str1.length();
    }
    else {
      String str1WithoutLast = str1.substring(0, (str1.length() - 1)); //string1 without its last character
      String str2WithoutLast = str2.substring(0, (str2.length() - 1)); //string2 without its last character
      char LastCharStr1 = str1.charAt(str1.length() - 1); // the last character of string1
      char LastCharStr2 = str2.charAt(str2.length() - 1); // the last character of string 2
      if (LastCharStr1 == LastCharStr2){
        int m;
        m = LevDist(str1WithoutLast, str2WithoutLast);
        alreadyComputed.put(putStringsInList(str1, str2), m);
        return m;
      }
      else {
        int n;
        n = 1 + Math.min(
                         Math.min(LevDist(str1WithoutLast, str2),
                                  LevDist(str1, str2WithoutLast)),        
                         (LevDist(str1WithoutLast, str2WithoutLast)));
        alreadyComputed.put(putStringsInList(str1, str2), n);
        return n;
      }
    }
  }
}
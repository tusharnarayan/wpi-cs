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

import tester.* ;

//all test cases use a try-catch construct to deal with the exceptions that may get
//thrown during function calls

class Examples {
  Examples(){}
  
  //example data
  Num num2 = new Num(2);
  Num num5 = new Num(5);
  CellRef a10 = new CellRef("a10");
  Plus f1 = new Plus(num2, num5);
  Plus f2 = new Plus(a10, num5);
  
  //tests
  
  boolean test1(Tester t) {
    return t.checkExpect(num2.traverse(new NoRefs()),true);
  }
  
  boolean test2(Tester t) {
    return t.checkExpect(num2.traverse(new ValueOf()),2);
  }
  
  boolean test3(Tester t) {
    try{
      return t.checkExpect(a10.traverse(new NoRefs()),false);
    }
    catch(CellNotFoundExn c){
      System.out.println("In test 3, the data referred to a cell that doesn't exist!");
      return false;
    }
  }
  
  boolean test4(Tester t) {
    try{
      return t.checkExpect(f1.traverse(new NoRefs()), true);
    }
    catch(CellNotFoundExn c){
      System.out.println("In test 4, the data referred to a cell that doesn't exist!");
      return false;
    }
  }
  
  boolean test5(Tester t) {
    try{
      return t.checkExpect(f1.traverse(new ValueOf()), 7);
    }
    catch(CellNotFoundExn c){
      System.out.println("In test 5, the data referred to a cell that doesn't exist!");
      return false;
    }
  }
  
  boolean test6(Tester t) {
    try{
      return t.checkExpect(f2.traverse(new NoRefs()), false);
    }
    catch(CellNotFoundExn c){
      System.out.println("In test 6, the data referred to a cell that doesn't exist!");
      return false;
    }
  }
  
  SpreadSheet s = new SpreadSheet();
  
  boolean test7(Tester t){
    try{
      s.editContents("a10", new Num(5));
      s.editContents("b10", new Num(3));
      s.editContents("c10", new Plus(new CellRef("a10"),
                                     new CellRef("b10")));
      return t.checkExpect(s.lookupValue("c10"), 8);
    }
    catch(CellNotFoundExn c){
      System.out.println("In test 7, the data referred to a cell that doesn't exist!");
      return false;
    }
    catch(CyclicException e){
      System.out.println("In test 7, the data entered contained a cyclic formula!");
      return false;
    }
  }
  
  boolean test8(Tester t){
    try{
      s.editContents("a10", new Num(5));
      s.editContents("b10", new Num(3));
      s.editContents("c10", new Plus(new CellRef("a10"),
                                     new CellRef("b10")));
      s.editContents("a10", new Num(9));
      return t.checkExpect(s.lookupValue("c10"), 12);
    }
    catch(CellNotFoundExn c){
      System.out.println("In test 8, the data referred to a cell that doesn't exist!");
      return false;
    }
    catch(CyclicException e){
      System.out.println("In test 8, the data entered contained a cyclic formula!");
      return false;
    }
    
  }
  
  boolean test9(Tester t){
    try{
      s.editContents("a10", new Num(12));
      s.editContents("b10", new Num(30));
      s.editContents("c10", new Plus(new CellRef("a10"),
                                     new CellRef("b10")));
      s.editContents("a10", new Num(19));
      s.editContents("b10", new Num(11));
      return t.checkExpect(s.lookupValue("c10"), 30);
    }
    catch(CellNotFoundExn c){
      System.out.println("In test 9, the data referred to a cell that doesn't exist!");
      return false;
    }
    catch(CyclicException e){
      System.out.println("In test 9, the data entered contained a cyclic formula!");
      return false;
    }
  }
  
  boolean test10(Tester t){
    try{
      s.editContents("c10", new Plus(new Num(910),
                                     new Num(10)));
      return t.checkExpect(s.lookupValue("c10"), 920);
    }
    catch(CellNotFoundExn c){
      System.out.println("In test 10, the data referred to a cell that doesn't exist!");
      return false;
    }
    catch(CyclicException e){
      System.out.println("In test 10, the data entered contained a cyclic formula!");
      return false;
    }
  }
  
  boolean test11(Tester t){
    try{
      s.editContents("a10", new Num(12));
      s.editContents("b10", new Plus(new Num(30),
                                     new CellRef("a10")));
      return t.checkExpect(s.lookupValue("b10"), 42);
    }
    catch(CellNotFoundExn c){
      System.out.println("In test 11, the data referred to a cell that doesn't exist!");
      return false;
    }
    catch(CyclicException e){
      System.out.println("In test 11, the data entered contained a cyclic formula!");
      return false;
    }
  }
  
  boolean test12(Tester t){
    try{
      s.editContents("a10", new Num(30));
      s.editContents("b10", new Plus(new CellRef("a10"), 
                                     new Num(30)));
      return t.checkExpect(s.lookupValue("b10"), 60);
    }
    catch(CellNotFoundExn c){
      System.out.println("In test 12, the data referred to a cell that doesn't exist!");
      return false;
    }
    catch(CyclicException e){
      System.out.println("In test 12, the data entered contained a cyclic formula!");
      return false;
    }
  }
  
  //cyclic references - a10 refers to b10, b10 refers to a10
  boolean test13(Tester t){
    try{
      s.editContents("a10", new CellRef("b10"));
      s.editContents("b10", new Plus(new CellRef("a10"), 
                                     new Num(30)));
      return t.checkExpect(s.lookupValue("b10"), 60);
    }
    catch(CellNotFoundExn c){
      System.out.println("In test 13, the data referred to a cell that doesn't exist!");
      return false;
    }
    catch(CyclicException e){
      System.out.println("In test 13, the data entered contained a cyclic formula!");
      return false;
    }
  }
  
  //cell refers a cell that is uninstantiated - b10 refers to d10
  boolean test14(Tester t){
    try{
      s.editContents("a10", new Num(5));
      s.editContents("b10", new Plus(new CellRef("a10"), 
                                     new CellRef("d10")));
      return t.checkExpect(s.lookupValue("b10"), 60);
    }
    catch(CellNotFoundExn c){
      System.out.println("In test 14, the data referred to a cell that doesn't exist!");
      return false;
    }
    catch(CyclicException e){
      System.out.println("In test 14, the data entered contained a cyclic formula!");
      return false;
    }
  }
  
  //self-referential data - c10 refers to c10 itself
  boolean test15(Tester t){
    try{
      s.editContents("a10", new Num(5));
      s.editContents("b10", new Plus(new CellRef("a10"), 
                                     new Num(10)));
      s.editContents("c10", new Plus(new CellRef("b10"), new CellRef("c10")));
      return t.checkExpect(s.lookupValue("c10"), 15);
    }
    catch(CellNotFoundExn c){
      System.out.println("In test 15, the data referred to a cell that doesn't exist!");
      return false;
    }
    catch(CyclicException e){
      System.out.println("In test 15, the data entered contained a cyclic formula!");
      return false;
    }
  }
  
  //edit a10, but try looking up e10 which is uninstantiated
  boolean test16(Tester t){
    try{
      s.editContents("a10", new Num(5));
      return t.checkExpect(s.lookupValue("e10"), 15);
    }
    catch(CellNotFoundExn c){
      System.out.println("In test 16, the data referred to a cell that doesn't exist!");
      return false;
    }
    catch(CyclicException e){
      System.out.println("In test 16, the data entered contained a cyclic formula!");
      return false;
    }
  }
  
  boolean test17(Tester t){
    try{
      s.editContents("a10", new Num(5));
      s.editContents("b10", new Num(6));
      s.editContents("c10", new Num(10));
      s.editContents("g10", new Plus(new Plus(new CellRef("a10"), new CellRef("b10")), 
                                     new Plus(new CellRef("c10"), new CellRef("g10"))));
      return t.checkExpect(s.lookupValue("g10"), 15);
    }
    catch(CellNotFoundExn c){
      System.out.println("In test 17, the data referred to a cell that doesn't exist!");
      return false;
    }
    catch(CyclicException e){
      System.out.println("In test 17, the data entered contained a cyclic formula!");
      return false;
    }
  }
  
  boolean test18(Tester t){
    try{
      s.editContents("a10", new Num(5));
      s.editContents("b10", new Num(6));
      s.editContents("c10", new Num(16));
      s.editContents("r10", new Num(23));
      s.editContents("s10", new Num(65));
      s.editContents("t10", new Num(89));
      s.editContents("u10", new Num(99));
      s.editContents("g10", new Plus(new Plus(new Plus (new CellRef("a10"), new CellRef("b10")), new Plus(new CellRef("c10"), new CellRef("r10"))),
                                     new Plus(new Plus (new CellRef("s10"), new CellRef("t10")), new Plus(new CellRef("u10"), new CellRef("g10")))));
      return t.checkExpect(s.lookupValue("g10"), 15);
    }
    catch(CellNotFoundExn c){
      System.out.println("In test 18, the data referred to a cell that doesn't exist!");
      return false;
    }
    catch(CyclicException e){
      System.out.println("In test 18, the data entered contained a cyclic formula!");
      return false;
    }
  }
  
}
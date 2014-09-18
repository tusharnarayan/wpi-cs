/*Homework 3
 * Standard Version
 * 
 * Tushar Narayan
 * tnarayan
 * 
 * Saraf Rahman
 * strahman
 * */

import tester.* ;

class Examples{
  Examples(){}
  
  //sample data
  DataHeap<Integer> sampleHeap1 = new DataHeap<Integer>(5, 
                                                        new DataHeap<Integer>(16, 
                                                                              new DataHeap<Integer>(17, 
                                                                                                    new MtHeap<Integer>(), 
                                                                                                    new DataHeap<Integer>(19, new MtHeap<Integer>(), new MtHeap<Integer>())),
                                                                              new DataHeap<Integer>(70, new MtHeap<Integer>(), new MtHeap<Integer>())),
                                                        new DataHeap<Integer>(82,
                                                                              new DataHeap<Integer>(99, new MtHeap<Integer>(), new MtHeap<Integer>()),
                                                                              new DataHeap<Integer>(123, new MtHeap<Integer>(), new MtHeap<Integer>())));
  DataHeap<Integer> sampleHeap2 = new DataHeap<Integer>(2,
                                                        new DataHeap<Integer>(0, new MtHeap<Integer>(), new MtHeap<Integer>()),
                                                        new DataHeap<Integer>(10, new MtHeap<Integer>(), new MtHeap<Integer>()));
  
  TestHeap<Integer> sampleHeap3 = new TestHeap<Integer>(5, 
                                                        new DataHeap<Integer>(16, 
                                                                              new DataHeap<Integer>(17, 
                                                                                                    new MtHeap<Integer>(), 
                                                                                                    new DataHeap<Integer>(19, new MtHeap<Integer>(), new MtHeap<Integer>())),
                                                                              new DataHeap<Integer>(70, new MtHeap<Integer>(), new MtHeap<Integer>())),
                                                        new DataHeap<Integer>(82,
                                                                              new DataHeap<Integer>(99, new MtHeap<Integer>(), new MtHeap<Integer>()),
                                                                              new DataHeap<Integer>(123, new MtHeap<Integer>(), new MtHeap<Integer>())));
  
  TestHeap2<Integer> sampleHeap4 = new TestHeap2<Integer>(5, 
                                                          new DataHeap<Integer>(16, 
                                                                                new DataHeap<Integer>(17, 
                                                                                                      new MtHeap<Integer>(), 
                                                                                                      new DataHeap<Integer>(19, new MtHeap<Integer>(), new MtHeap<Integer>())),
                                                                                new DataHeap<Integer>(70, new MtHeap<Integer>(), new MtHeap<Integer>())),
                                                          new DataHeap<Integer>(82,
                                                                                new DataHeap<Integer>(99, new MtHeap<Integer>(), new MtHeap<Integer>()),
                                                                                new DataHeap<Integer>(123, new MtHeap<Integer>(), new MtHeap<Integer>())));
  
  TestHeap3<Integer> sampleHeap5 = new TestHeap3<Integer>(5, 
                                                          new DataHeap<Integer>(16, 
                                                                                new DataHeap<Integer>(17, 
                                                                                                      new MtHeap<Integer>(), 
                                                                                                      new DataHeap<Integer>(19, new MtHeap<Integer>(), new MtHeap<Integer>())),
                                                                                new DataHeap<Integer>(70, new MtHeap<Integer>(), new MtHeap<Integer>())),
                                                          new DataHeap<Integer>(82,
                                                                                new DataHeap<Integer>(99, new MtHeap<Integer>(), new MtHeap<Integer>()),
                                                                                new DataHeap<Integer>(123, new MtHeap<Integer>(), new MtHeap<Integer>())));
  
  TestHeap4<Integer> sampleHeap6 = new TestHeap4<Integer>(5, 
                                                          new DataHeap<Integer>(16, 
                                                                                new DataHeap<Integer>(17, 
                                                                                                      new MtHeap<Integer>(), 
                                                                                                      new DataHeap<Integer>(19, new MtHeap<Integer>(), new MtHeap<Integer>())),
                                                                                new DataHeap<Integer>(70, new MtHeap<Integer>(), new MtHeap<Integer>())),
                                                          new DataHeap<Integer>(82,
                                                                                new DataHeap<Integer>(99, new MtHeap<Integer>(), new MtHeap<Integer>()),
                                                                                new DataHeap<Integer>(123, new MtHeap<Integer>(), new MtHeap<Integer>())));
  TestHeap5<Integer> sampleHeap7 = new TestHeap5<Integer>(5, 
                                                          new DataHeap<Integer>(16, 
                                                                                new DataHeap<Integer>(17, 
                                                                                                      new MtHeap<Integer>(), 
                                                                                                      new DataHeap<Integer>(19, new MtHeap<Integer>(), new MtHeap<Integer>())),
                                                                                new DataHeap<Integer>(70, new MtHeap<Integer>(), new MtHeap<Integer>())),
                                                          new DataHeap<Integer>(82,
                                                                                new DataHeap<Integer>(99, new MtHeap<Integer>(), new MtHeap<Integer>()),
                                                                                new DataHeap<Integer>(123, new MtHeap<Integer>(), new MtHeap<Integer>())));
  
  TestHeap6<Integer> sampleHeap8 = new TestHeap6<Integer>(5, 
                                                          new DataHeap<Integer>(16, 
                                                                                new DataHeap<Integer>(17, 
                                                                                                      new MtHeap<Integer>(), 
                                                                                                      new DataHeap<Integer>(19, new MtHeap<Integer>(), new MtHeap<Integer>())),
                                                                                new DataHeap<Integer>(70, new MtHeap<Integer>(), new MtHeap<Integer>())),
                                                          new DataHeap<Integer>(82,
                                                                                new DataHeap<Integer>(99, new MtHeap<Integer>(), new MtHeap<Integer>()),
                                                                                new DataHeap<Integer>(123, new MtHeap<Integer>(), new MtHeap<Integer>())));
  
  DataHeap<String> sampleHeap9 = new DataHeap<String>("A", 
                                                        new DataHeap<String>("B", 
                                                                              new DataHeap<String>("C", 
                                                                                                    new MtHeap<String>(), 
                                                                                                    new DataHeap<String>("E", new MtHeap<String>(), new MtHeap<String>())),
                                                                              new DataHeap<String>("H", new MtHeap<String>(), new MtHeap<String>())),
                                                        new DataHeap<String>("D",
                                                                              new DataHeap<String>("I", new MtHeap<String>(), new MtHeap<String>()),
                                                                              new DataHeap<String>("T", new MtHeap<String>(), new MtHeap<String>())));
  
  DataHeap<String> sampleHeap10 = new DataHeap<String>("C",
                                                        new DataHeap<String>("A", new MtHeap<String>(), new MtHeap<String>()),
                                                        new DataHeap<String>("J", new MtHeap<String>(), new MtHeap<String>()));
  
  DataHeap<String> sampleHeap11 = new DataHeap<String>("Aardvark", 
                                                        new DataHeap<String>("Blink", 
                                                                              new DataHeap<String>("Carry", 
                                                                                                    new MtHeap<String>(), 
                                                                                                    new DataHeap<String>("Ever", new MtHeap<String>(), new MtHeap<String>())),
                                                                              new DataHeap<String>("Hospitable", new MtHeap<String>(), new MtHeap<String>())),
                                                        new DataHeap<String>("Distance",
                                                                              new DataHeap<String>("Inkling", new MtHeap<String>(), new MtHeap<String>()),
                                                                              new DataHeap<String>("Tuxedo", new MtHeap<String>(), new MtHeap<String>())));
  
  DataHeap<String> sampleHeap12 = new DataHeap<String>("Citation",
                                                        new DataHeap<String>("Aspect", new MtHeap<String>(), new MtHeap<String>()),
                                                        new DataHeap<String>("Juxtaposition", new MtHeap<String>(), new MtHeap<String>()));
  
  //test cases
  boolean test1(Tester t){
    return t.checkExpect(sampleHeap1.isHeap(), true);
  }
  boolean test2(Tester t){
    return t.checkExpect(sampleHeap2.isHeap(), false);
  }
  boolean test3(Tester t){
    return t.checkExpect(sampleHeap1.addElt(101).isHeap(), true);
  }
  boolean test4(Tester t){
    return t.checkExpect(sampleHeap2.addElt(101).isHeap(), false);
  }
  boolean test5(Tester t){
    return t.checkExpect(sampleHeap1.remMinElt().isHeap(), true);
  }
  boolean test6(Tester t){
    return t.checkExpect(sampleHeap2.remMinElt().isHeap(), true);
  }
  boolean test7(Tester t){
    return t.checkExpect(sampleHeap1.testAddElt(200), true);
  }
  
  
  boolean test8(Tester t){
    return t.checkExpect(sampleHeap3.testAddElt(200), false);
  }
  boolean test9(Tester t){
    return t.checkExpect(sampleHeap4.testAddElt(200), true);
  }
  boolean test10(Tester t){
    return t.checkExpect(sampleHeap5.testAddElt(200), false);
  }
  boolean test11(Tester t){
    return t.checkExpect(sampleHeap6.testAddElt(200), false);
  }
  boolean test12(Tester t){
    return t.checkExpect(sampleHeap7.testAddElt(200), true);
  }
  boolean test13(Tester t){
    return t.checkExpect(sampleHeap8.testAddElt(200), false);
  }
  
  boolean test14(Tester t){
    return t.checkExpect(sampleHeap1.testRemMinElt(), true);
  }
  boolean test15(Tester t){
    return t.checkExpect(sampleHeap2.testRemMinElt(), false);
  }
  boolean test16(Tester t){
    return t.checkExpect(sampleHeap3.testRemMinElt(), true);
  }
  boolean test17(Tester t){
    return t.checkExpect(sampleHeap4.testRemMinElt(), false);
  }
  boolean test18(Tester t){
    return t.checkExpect(sampleHeap5.testRemMinElt(), false);
  }
  boolean test19(Tester t){
    return t.checkExpect(sampleHeap6.testRemMinElt(), true);
  }
  boolean test20(Tester t){
    return t.checkExpect(sampleHeap7.testRemMinElt(), false);
  }
  boolean test21(Tester t){
    return t.checkExpect(sampleHeap8.testRemMinElt(), true);
  }
  
  boolean test22(Tester t){
    return t.checkExpect(sampleHeap9.isHeap(), true);
  }
  boolean test23(Tester t){
    return t.checkExpect(sampleHeap10.isHeap(), false);
  }
  boolean test24(Tester t){
    return t.checkExpect(sampleHeap9.addElt("Y").isHeap(), true);
  }
  boolean test25(Tester t){
    return t.checkExpect(sampleHeap10.addElt("Y").isHeap(), false);
  }
  boolean test26(Tester t){
    return t.checkExpect(sampleHeap9.remMinElt().isHeap(), true);
  }
  boolean test27(Tester t){
    return t.checkExpect(sampleHeap10.remMinElt().isHeap(), true);
  }
  boolean test28(Tester t){
    return t.checkExpect(sampleHeap9.testAddElt("Z"), true);
  }
  
  boolean test29(Tester t){
    return t.checkExpect(sampleHeap11.isHeap(), true);
  }
  boolean test30(Tester t){
    return t.checkExpect(sampleHeap12.isHeap(), false);
  }
  boolean test31(Tester t){
    return t.checkExpect(sampleHeap11.addElt("Yoda").isHeap(), true);
  }
  boolean test32(Tester t){
    return t.checkExpect(sampleHeap12.addElt("Yoda").isHeap(), false);
  }
  boolean test33(Tester t){
    return t.checkExpect(sampleHeap11.remMinElt().isHeap(), true);
  }
  boolean test34(Tester t){
    return t.checkExpect(sampleHeap12.remMinElt().isHeap(), true);
  }
  boolean test35(Tester t){
    return t.checkExpect(sampleHeap11.testAddElt("Zen"), true);
  }
  
  boolean test36(Tester t){
    return t.checkExpect(sampleHeap1.testAddElt(0), true);
  }
}
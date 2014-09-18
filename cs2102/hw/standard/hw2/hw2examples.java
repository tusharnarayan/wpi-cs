/*Homework 2
 * Common part
 * 
 * Tushar Narayan
 * tnarayan
 * 
 * Saraf Rahman
 * strahman
 * */

import tester.* ;
  
class Main {
  static Examples E = new Examples () ;
  
  public static void main(String[] args) {
    Tester.run (E) ;
  }
}


interface IPriorQ{
  IPriorQ newPQ();
  IPriorQ addElt(int elt);
  IPriorQ remMinElt();
  int getMinElt();
}
class PriorQ implements IPriorQ {
  public IPriorQ newPQ() { return this; }
  public IPriorQ addElt(int elt) { return this; }
  public IPriorQ remMinElt() { return this; }
  public int getMinElt() { return 0; }
}

interface IStack{
  IStack newStk();
  IStack push(int elt);
  IStack pop();
  int top();
}
class Stack implements IStack {
  public IStack newStk() { return this; }
  public IStack push(int elt) { return this; }
  public IStack pop() { return this; }
  public int top() { return 0; }
}

interface IQueue{
  IQueue newQ();
  IQueue enqueue(int elt);
  IQueue dequeue();
  int front();
}
class Queue implements IQueue {
  public IQueue newQ() { return this; }
  public IQueue enqueue(int elt) { return this; }
  public IQueue dequeue() { return this; }
  public int front() { return 0; }
}


class Examples{
  Examples(){}

  //test cases for Priority Queues
  PriorQ samplePQ = new PriorQ();
  
  boolean test1(Tester t){
    return t.checkExpect(samplePQ.newPQ().addElt(2).getMinElt(), 0); //2
  }
  boolean test2(Tester t){
    return t.checkExpect(samplePQ.newPQ().addElt(2).addElt(1).getMinElt(), 0); //1
  }
  boolean test3(Tester t){
    return t.checkExpect(samplePQ.newPQ().addElt(10).addElt(5).addElt(36).getMinElt(), 0); //5
  }
  boolean test4(Tester t){
    return t.checkExpect(samplePQ.newPQ().addElt(60).addElt(200).addElt(567).getMinElt(), 0); //60
  }
  
  /*Casts are required for testing with the dummy classes because the functions of the dummy class
   * have return type of the interface of that particular set, whereas object being defined is of
   * the type of the class and not the interface. Hence, Java needs the casts to compile the code.
   * */
  PriorQ samplePQ1 = (PriorQ) samplePQ.newPQ().addElt(10).addElt(5).addElt(36).addElt(23);
  PriorQ samplePQ2 = (PriorQ) samplePQ.newPQ().addElt(10).addElt(36).addElt(23);
  PriorQ samplePQ3 = (PriorQ) samplePQ.newPQ().addElt(10).addElt(5).addElt(36).addElt(23);
  PriorQ samplePQ4 = (PriorQ) samplePQ.newPQ().addElt(10).addElt(5).addElt(36).addElt(23);
  
  boolean test5(Tester t){
    return t.checkExpect(samplePQ1.remMinElt(), samplePQ2);
  }
  boolean test6(Tester t){
    return t.checkExpect(samplePQ3.addElt(2).remMinElt(), samplePQ4);
  }
  
  //test cases for Stacks
  Stack sampleStk = new Stack();
  
  boolean test7(Tester t){
    return t.checkExpect(sampleStk.newStk().push(2).top(), 0); //2
  }
  boolean test8(Tester t){
    return t.checkExpect(sampleStk.newStk().push(2).push(1).top(), 0); //1
  }
  boolean test9(Tester t){
    return t.checkExpect(sampleStk.newStk().push(10).push(5).push(36).top(), 0); //36
  }
  boolean test10(Tester t){
    return t.checkExpect(sampleStk.newStk().push(60).push(200).push(567).top(), 0); //567
  }
  
  /*Casts are required for testing with the dummy classes because the functions of the dummy class
   * have return type of the interface of that particular set, whereas object being defined is of
   * the type of the class and not the interface. Hence, Java needs the casts to compile the code.
   * */
  Stack sampleStk1 = (Stack) sampleStk.newStk().push(10).push(5).push(36);
  Stack sampleStk2 = (Stack) sampleStk.newStk().push(10).push(5);
  Stack sampleStk3 = (Stack) sampleStk.newStk().push(10).push(5).push(36);
  Stack sampleStk4 = (Stack) sampleStk.newStk().push(10).push(5).push(36);
  
  boolean test11(Tester t){
    return t.checkExpect(sampleStk1.pop(), sampleStk2);
  }
  boolean test12(Tester t){
    return t.checkExpect(sampleStk3.push(2).pop(), sampleStk4);
  }
  
  //test cases for Queues
  Queue sampleQ = new Queue();
  
  boolean test13(Tester t){
    return t.checkExpect(sampleQ.newQ().enqueue(2).front(), 0); //2
  }
  boolean test14(Tester t){
    return t.checkExpect(sampleQ.newQ().enqueue(2).enqueue(1).front(), 0); //2
  }
  boolean test15(Tester t){
    return t.checkExpect(sampleQ.newQ().enqueue(10).enqueue(5).enqueue(36).front(), 0); //10
  }
  boolean test16(Tester t){
    return t.checkExpect(sampleQ.newQ().enqueue(60).enqueue(200).enqueue(567).front(), 0); //60
  }
  
  /*Casts are required for testing with the dummy classes because the functions of the dummy class
   * have return type of the interface of that particular set, whereas object being defined is of
   * the type of the class and not the interface. Hence, Java needs the casts to compile the code.
   * */
  Queue sampleQ1 = (Queue) sampleQ.newQ().enqueue(10).enqueue(5).enqueue(36);
  Queue sampleQ2 = (Queue) sampleQ.newQ().enqueue(5).enqueue(36);
  Queue sampleQ3 = (Queue) sampleQ.newQ().enqueue(10).enqueue(5).enqueue(36);
  Queue sampleQ4 = (Queue) sampleQ.newQ().enqueue(5).enqueue(36).enqueue(2);
  
  boolean test17(Tester t){
    return t.checkExpect(sampleQ1.dequeue(), sampleQ2);
  }
  boolean test18(Tester t){
    return t.checkExpect(sampleQ3.enqueue(2).dequeue(), sampleQ4);
  }
}
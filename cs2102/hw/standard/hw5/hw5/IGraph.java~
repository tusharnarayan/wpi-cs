/*Homework 5
 * Part 2
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

import java.util.LinkedList;
import tester.*;

class Main {
  static Examples E = new Examples () ;
  
  public static void main(String[] args) {
    Tester.run (E) ;
  }
}

interface IGraph<T> {
  // add a new node with the given string as the cityname 
  Node<T> newNode(T cityname);
  
  // add a directed edge from the "from" Node<T> to the "to" Node
  void addDirectedEdge(Node<T> from, Node<T> to);
  
  // produce a list of all nodes reachable from given starting node
  LinkedList<Node<T>> reachableFrom (Node<T> from);
}

//class for capturing the elements of a social network
class Profile {
  String name;
  String college;
  Profile(String name, String college){
    this.name = name;
    this.college = college;
  }
}

class Node<T> {
  private T aNode;          // name of element (user profile or city name) at this node
  private LinkedList<Node<T>> getsTo;  // edges from this Node
  
  // constructor only takes the element name as an argument, 
  //   initializing the getsTo list internally
  Node(T aNode) {
    this.aNode = aNode;
    this.getsTo = new LinkedList<Node<T>>();
  }
  
  // adds an edge from this node to the given toNode
  public void addEdge(Node<T> toNode) {
    this.getsTo.add(toNode);
  }
  
  // determines whether there is a route from this Node to the given node
  boolean hasRoute(Node<T> to, LinkedList<Node<T>> visited){
    if(this.equals(to))
      return true;
    else if(visited.contains(this))
      return false;
    else {
      visited.add(this);
      for (Node<T> c : this.getsTo){
        if(c.hasRoute(to, visited)){
          return true;
        }
      }
      return false;
    }
  }
  
  // produce a list of all nodes reachable from this node
  LinkedList<Node<T>> reacheableFrom(LinkedList<Node<T>> visited){
    if(visited.contains(this))
      return visited;
    else {
      visited.add(this);
      for (Node<T> c : this.getsTo){
        c.reacheableFrom(visited);
      }
    }
    return visited;
  }
}

class Graph<T> implements IGraph<T> {
  private LinkedList<Node<T>> nodes;  // all the nodes in the graph
  
  //constructor internally initializes the list that will contain all the nodes in the graph
  Graph() {
    this.nodes = new LinkedList<Node<T>>();
  }
  
  // adds a new node to the graph with the given string as the element name
  public Node<T> newNode(T cityname) {
    Node<T> newN = new Node<T>(cityname);
    this.nodes.add(newN);
    return newN;
  }
  
  // adds a directed edge from the "from" node to the "to" node
  public void addDirectedEdge(Node<T> from, Node<T> to) {
    from.addEdge(to);
  }
  
  // determine whether graph contains a route from "from" node to "to" node
  public boolean hasRoute(Node<T> from, Node<T> to) {
    LinkedList<Node<T>> emptyVisitList = new LinkedList<Node<T>>();
    return from.hasRoute(to, emptyVisitList);
  }
  
  // produce a list of all nodes reachable from given starting node
  public LinkedList<Node<T>> reachableFrom (Node<T> from){
    LinkedList<Node<T>> emptyVisitList = new LinkedList<Node<T>>();
    return from.reacheableFrom(emptyVisitList);
  }
}

class Examples {
  Graph<String> G = new Graph<String>();
  Node<String> bost, worc, hart, prov, manc;
  
  Graph<Profile> SG = new Graph<Profile>();
  Node<Profile> bill, hannah, jack,  meghan, jill;
  
  
  Examples(){
    this.initCityGraph();
    this.initSocialGraph();
  }
  
  void initCityGraph() {
    bost = this.G.newNode("Boston");
    worc = this.G.newNode("Worcester");
    hart = this.G.newNode("Hartford");
    prov = this.G.newNode("Providence");
    manc = this.G.newNode("Manchester");
    
    G.addDirectedEdge(bost,worc);
    G.addDirectedEdge(bost,prov);
    G.addDirectedEdge(worc,bost);
    G.addDirectedEdge(prov,hart);
    G.addDirectedEdge(manc,bost);
  }
  
  void initSocialGraph(){
    bill = this.SG.newNode(new Profile("Bill", "Harvard"));
    hannah = this.SG.newNode(new Profile("Hannah", "WPI"));
    jack = this.SG.newNode(new Profile("Jack", "CMU"));
    meghan = this.SG.newNode(new Profile("Meghan", "MIT"));
    jill = this.SG.newNode(new Profile("Jill", "Stanford"));
    
    SG.addDirectedEdge(bill, hannah);
    SG.addDirectedEdge(bill, meghan);
    SG.addDirectedEdge(hannah, bill);
    SG.addDirectedEdge(meghan, jack);
    SG.addDirectedEdge(jill, bill);
  }
  
  //compares two LinkedLists to see if they have the same content, regardless of the order
  public <T> boolean compareLists(LinkedList<Node<T>> list1, LinkedList<Node<T>> list2){
    if(list1.size() != list2.size()) //if different sizes, lists are clearly not the same
      return false;
    else{
      int counter = 0;
      for(Node<T> n: list1){
        for(Node<T> m: list2){
          if (m == n) {
            counter++;
            break; //this captures the case when the lists have duplicate elements
            //without the break, the cases of a list with one duplicate and one missing element might pass
          }
        }
      }
      if(counter == list1.size()) return true;
      else return false;
    }
  }
  
  //tests for the function compareLists
  
  //test when the expected list has more elements
  //for Social Graph
  boolean testingCheckLists1(Tester t){
    LinkedList<Node<Profile>> sampleListCL1 = new LinkedList<Node<Profile>>();
    sampleListCL1.add(jack);
    sampleListCL1.add(meghan);
    sampleListCL1.add(hannah);
    sampleListCL1.add(bill);
    sampleListCL1.add(jill);
    return t.checkExpect(compareLists(SG.reachableFrom(bill), sampleListCL1), false);
  }
  //for City Graph
  boolean testCheckLists2(Tester t){
    LinkedList<Node<String>> sampleListCL2 = new LinkedList<Node<String>>();
    sampleListCL2.add(hart);
    sampleListCL2.add(bost);
    sampleListCL2.add(worc);
    sampleListCL2.add(prov);
    sampleListCL2.add(manc);
    return t.checkExpect(compareLists(G.reachableFrom(bost), sampleListCL2), false);
  }
  //test when the expected list has same size, but has one duplicate and one missing element
  //for Social Graph
  boolean testingCheckLists3(Tester t){
    LinkedList<Node<Profile>> sampleListCL3 = new LinkedList<Node<Profile>>();
    sampleListCL3.add(jack);
    sampleListCL3.add(hannah);
    sampleListCL3.add(bill);
    sampleListCL3.add(jack);
    return t.checkExpect(compareLists(SG.reachableFrom(bill), sampleListCL3), false);
  }
  //for City Graph
  boolean testCheckLists4(Tester t){
    LinkedList<Node<String>> sampleListCL4 = new LinkedList<Node<String>>();
    sampleListCL4.add(manc);
    sampleListCL4.add(bost);
    sampleListCL4.add(worc);
    sampleListCL4.add(prov);
    sampleListCL4.add(worc);
    return t.checkExpect(compareLists(G.reachableFrom(manc), sampleListCL4), false);
  }
  
  //tests when the expected list has the same elements in arbritrary order
  boolean testCheckLists5(Tester t){
    LinkedList<Node<String>> sampleListCL5 = new LinkedList<Node<String>>();
    sampleListCL5.add(hart);
    sampleListCL5.add(worc);
    sampleListCL5.add(bost);
    sampleListCL5.add(manc);
    sampleListCL5.add(prov);
    return t.checkExpect(compareLists(G.reachableFrom(manc), sampleListCL5), true);
  }
  boolean testCheckLists6(Tester t){
    LinkedList<Node<String>> sampleListCL6 = new LinkedList<Node<String>>();
    sampleListCL6.add(prov);
    sampleListCL6.add(manc);
    sampleListCL6.add(hart);
    sampleListCL6.add(worc);
    sampleListCL6.add(bost);
    return t.checkExpect(compareLists(G.reachableFrom(manc), sampleListCL6), true);
  }
  
  //testing two input lists which are the same size but contain different duplicates
  //since they have the same unique elements, they would be equal
  boolean testingCheckLists7(Tester t){
    LinkedList<Node<Profile>> sampleListCL7 = new LinkedList<Node<Profile>>();
    sampleListCL7.add(jack);
    sampleListCL7.add(hannah);
    sampleListCL7.add(jack);
    sampleListCL7.add(bill);
    LinkedList<Node<Profile>> sampleListCL8 = new LinkedList<Node<Profile>>();
    sampleListCL8.add(bill);
    sampleListCL8.add(hannah);
    sampleListCL8.add(bill);
    sampleListCL8.add(jack);
    return t.checkExpect(compareLists(sampleListCL7, sampleListCL8), true);
  }
  boolean testingCheckLists8(Tester t){
    LinkedList<Node<Profile>> sampleListCL9 = new LinkedList<Node<Profile>>();
    sampleListCL9.add(jack);
    sampleListCL9.add(jack);
    sampleListCL9.add(jack);
    sampleListCL9.add(bill);
    LinkedList<Node<Profile>> sampleListCL10 = new LinkedList<Node<Profile>>();
    sampleListCL10.add(bill);
    sampleListCL10.add(bill);
    sampleListCL10.add(bill);
    sampleListCL10.add(jack);
    return t.checkExpect(compareLists(sampleListCL9, sampleListCL10), true);
  }
    
  //tests for hasRoute for City Graphs
  boolean testbb (Tester t) {
    return t.checkExpect(G.hasRoute(bost,bost), true);
  }
  
  boolean testbw (Tester t) {
    return t.checkExpect(G.hasRoute(bost,worc), true);
  }
  
  boolean testhp (Tester t) {
    return t.checkExpect(G.hasRoute(hart,prov), false);
  }
  
  boolean testpb (Tester t) {
    return t.checkExpect(G.hasRoute(prov,bost), false);
  }
  
  boolean testbh (Tester t) {
    return t.checkExpect(G.hasRoute(bost,hart), true);
  }
  
  boolean testbp (Tester t) {
    return t.checkExpect(G.hasRoute(bost,prov), true);
  }
  
  //tests for reachableFrom for City Graphs
  boolean testRF1(Tester t){
    LinkedList<Node<String>> sampleList1 = new LinkedList<Node<String>>();
    sampleList1.add(prov);
    sampleList1.add(hart);
    return t.checkExpect(compareLists(G.reachableFrom(prov), sampleList1), true);
  }
  
  boolean testRF2(Tester t){
    LinkedList<Node<String>> sampleList2 = new LinkedList<Node<String>>();
    sampleList2.add(hart);
    return t.checkExpect(compareLists(G.reachableFrom(hart), sampleList2), true);
  }
  
  boolean testRF3(Tester t){
    LinkedList<Node<String>> sampleList3 = new LinkedList<Node<String>>();
    sampleList3.add(worc);
    sampleList3.add(bost);
    sampleList3.add(prov);
    sampleList3.add(hart);
    return t.checkExpect(compareLists(G.reachableFrom(worc), sampleList3), true);
  }
  
  boolean testRF4(Tester t){
    LinkedList<Node<String>> sampleList4 = new LinkedList<Node<String>>();
    sampleList4.add(manc);
    sampleList4.add(bost);
    sampleList4.add(worc);
    sampleList4.add(prov);
    sampleList4.add(hart);
    return t.checkExpect(compareLists(G.reachableFrom(manc), sampleList4), true);
  }
  
  boolean testRF5(Tester t){
    LinkedList<Node<String>> sampleList5 = new LinkedList<Node<String>>();
    sampleList5.add(bost);
    sampleList5.add(worc);
    sampleList5.add(prov);
    sampleList5.add(hart);
    return t.checkExpect(compareLists(G.reachableFrom(bost), sampleList5), true);
  }
  
  //tests for hasRoute for Social Graphs
  boolean testsbb (Tester t) {
    return t.checkExpect(SG.hasRoute(bill,bill), true);
  }
  
  boolean testsbh (Tester t) {
    return t.checkExpect(SG.hasRoute(bill,hannah), true);
  }
  
  boolean testsjm (Tester t) {
    return t.checkExpect(SG.hasRoute(jack,meghan), false);
  }
  
  boolean testsmb (Tester t) {
    return t.checkExpect(SG.hasRoute(meghan,bill), false);
  }
  
  boolean testsbj (Tester t) {
    return t.checkExpect(SG.hasRoute(bill,jack), true);
  }
  
  boolean testsbm (Tester t) {
    return t.checkExpect(SG.hasRoute(bill,meghan), true);
  }
  
  //tests for reachableFrom for Social Graphs
  boolean testsRF1(Tester t){
    LinkedList<Node<Profile>> sampleListS1 = new LinkedList<Node<Profile>>();
    sampleListS1.add(meghan);
    sampleListS1.add(jack);
    return t.checkExpect(compareLists(SG.reachableFrom(meghan), sampleListS1), true);
  }
  
  boolean testsRF2(Tester t){
    LinkedList<Node<Profile>> sampleListS2 = new LinkedList<Node<Profile>>();
    sampleListS2.add(jack);
    return t.checkExpect(compareLists(SG.reachableFrom(jack), sampleListS2), true);
  }
  
  boolean testsRF3(Tester t){
    LinkedList<Node<Profile>> sampleListS3 = new LinkedList<Node<Profile>>();
    sampleListS3.add(hannah);
    sampleListS3.add(bill);
    sampleListS3.add(meghan);
    sampleListS3.add(jack);
    return t.checkExpect(compareLists(SG.reachableFrom(hannah), sampleListS3), true);
  }
  
  boolean testsRF4(Tester t){
    LinkedList<Node<Profile>> sampleListS4 = new LinkedList<Node<Profile>>();
    sampleListS4.add(jill);
    sampleListS4.add(bill);
    sampleListS4.add(hannah);
    sampleListS4.add(meghan);
    sampleListS4.add(jack);
    return t.checkExpect(compareLists(SG.reachableFrom(jill), sampleListS4), true);
  }
  
  boolean testsRF5(Tester t){
    LinkedList<Node<Profile>> sampleListS5 = new LinkedList<Node<Profile>>();
    sampleListS5.add(bill);
    sampleListS5.add(hannah);
    sampleListS5.add(meghan);
    sampleListS5.add(jack);
    return t.checkExpect(compareLists(SG.reachableFrom(bill), sampleListS5), true);
  }
  
  boolean testsRF6(Tester t){
    LinkedList<Node<Profile>> sampleListS6 = new LinkedList<Node<Profile>>();
    sampleListS6.add(jack);
    sampleListS6.add(meghan);
    sampleListS6.add(hannah);
    sampleListS6.add(bill);
    return t.checkExpect(compareLists(SG.reachableFrom(bill), sampleListS6), true);
  }
}

/*Why the reachableFrom method will terminate:
 * INVARIANT: a node is in the visited LinkedList if and only if the program has called node.hasRoute, 
 * since reachableFrom is called on the entire graph
 * TERMINATES: because the program checks the visited list before recurring (and every node goes into visited 
 * when called with reachableFrom(from invariant)). Since there are a finite number of nodes, the method will terminate 
 * after a finite number of recursive calls.
 * EXTENDED EXPLANATION:
 * The method calls the reachableFrom method of the Node class.
 * The reachableFrom of the node class uses a LinkedList to store the cities as it checks for possible routes, and an addition
 * is made to that list every single time the function recurses, hence ensuring that there are a finite number 
 * of recursive calls. Thus, the reachableFrom method terminates because of the invariant of the visited LinkedList.
 * */
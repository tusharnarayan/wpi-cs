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

import java.util.*;

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
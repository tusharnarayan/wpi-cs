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

interface IGraph<T> {
  // add a new node with the given string as the cityname 
  Node<T> newNode(T cityname);
  
  // add a directed edge from the "from" Node<T> to the "to" Node
  void addDirectedEdge(Node<T> from, Node<T> to);
  
  // produce a list of all nodes reachable from given starting node
  LinkedList<Node<T>> reachableFrom (Node<T> from);
}
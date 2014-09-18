/*Homework 4
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

//the IVisit interface contains the visit function for visiting and 
//processing different objects
interface IVisit{
  <T> T visit(IProc<T> f);
}

//-------------------------------------------------

abstract class MenuItem implements IVisit{
  String name;
  int price;
  
  MenuItem(String name, int price) {
    this.name = name;
    this.price = price;
  }
  
  abstract public <T> T visit(IProc<T> f);
}  

class Dessert extends MenuItem {
  Dessert (String name, int price) {
    super(name, price);
  }
  
  public <T> T visit(IProc<T> f){
    return f.processDessert(this);
  }
}

class Starter extends MenuItem {
  Starter (String name, int price) {
    super(name, price);
  }
  
  public <T> T visit(IProc<T> f){
    return f.processStarter(this);
  }
}

class Entree extends MenuItem {
  Entree (String name, int price) {
    super(name, price);
  }
  
  public <T> T visit(IProc<T> f){
    return f.processEntree(this);
  }
}

//-------------------------------------------------

interface IMenu extends IVisit{
  //the countMatch function has now been implemented via the IProc interface and the visitors
}

class MtMenu implements IMenu {
  MtMenu(){}
  
  public <T> T visit(IProc<T> f){
    return f.processMtMenu(this);
  }
}

class DataMenu implements IMenu {
  MenuItem item;
  IMenu left;
  IMenu right;
  
  DataMenu(MenuItem item, IMenu left, IMenu right) {
    this.item = item;
    this.left = left;
    this.right = right;
  }
  
  // Second constructor with default arguments for the left and the right nodes
  DataMenu(MenuItem item) {
    this.item = item;
    this.left = new MtMenu();
    this.right = new MtMenu();
  }
  
  public <T> T visit(IProc<T> f){
    return f.processDataMenu(this);
  }
}

//-------------------------------------------------

//interface to process classes extending MenuItem and those implementing IMenu

interface IProc<T>{
  //for the classes extending the MenuItem class
  T processStarter(Starter s);
  T processEntree(Entree e);
  T processDessert(Dessert d);
  //for the classes implementing the IMenu interface
  T processMtMenu(MtMenu m);
  T processDataMenu(DataMenu d);
}

//class for the function that returns the number of items in the menu
//that are either garlic entrees or lemon desserts
class MatchGarlicEntreesLemonDesserts implements IProc<Integer>{
  MatchGarlicEntreesLemonDesserts(){}
  
  public Integer processStarter(Starter s){
    return 0;
  }
  
  public Integer processEntree(Entree e){
    if(e.name.startsWith("garlic")) return 1;
    else return 0;
  }
  
  public Integer processDessert(Dessert d){
    if(d.name.startsWith("lemon")) return 1;
    else return 0;
  } 
  
  public Integer processMtMenu(MtMenu m){
    return 0;
  }
  
  public Integer processDataMenu(DataMenu d){
    return d.item.visit(new MatchGarlicEntreesLemonDesserts())
      +
      d.left.visit(new MatchGarlicEntreesLemonDesserts())
      +
      d.right.visit(new MatchGarlicEntreesLemonDesserts());
  }
}

//class for the function that counts the number of starters in the menu
class CountStarters implements IProc<Integer>{
  CountStarters(){}
  
  public Integer processStarter(Starter s){
    return 1;
  }
  
  public Integer processEntree(Entree e){
    return 0;
  }
  
  public Integer processDessert(Dessert d){
    return 0;
  } 
  
  public Integer processMtMenu(MtMenu m){
    return 0;
  }
  
  public Integer processDataMenu(DataMenu d){
    return d.item.visit(new CountStarters())
      +
      d.left.visit(new CountStarters())
      +
      d.right.visit(new CountStarters());
  }
}

//class for the function that checks if at least one starter in the menu is costlier than 15 units
class ExpensiveStarters implements IProc<Boolean>{
  ExpensiveStarters(){}
  
  public Boolean processStarter(Starter s){
    return s.price > 15;
  }
  
  public Boolean processEntree(Entree e){
    return false;
  }
  
  public Boolean processDessert(Dessert d){
    return false;
  } 
  
  public Boolean processMtMenu(MtMenu m){
    return false;
  }
  
  public Boolean processDataMenu(DataMenu d){
    return d.item.visit(new ExpensiveStarters())
      ||
      d.left.visit(new ExpensiveStarters())
      ||
      d.right.visit(new ExpensiveStarters());
  }
}

//class for the function that checks whether at least one item in the menu is
//costlier than the value that is passed
class StarterExpensiveThan implements IProc<Boolean>{
  int inputPrice;
  
  StarterExpensiveThan(int inputPrice){
    this.inputPrice = inputPrice;
  }
  
  public Boolean processStarter(Starter s){
    return s.price > inputPrice;
  }
  
  public Boolean processEntree(Entree e){
    return false;
  }
  
  public Boolean processDessert(Dessert d){
    return false;
  } 
  
  public Boolean processMtMenu(MtMenu m){
    return false;
  }
  
  public Boolean processDataMenu(DataMenu d){
    return d.item.visit(new StarterExpensiveThan(inputPrice))
      ||
      d.left.visit(new StarterExpensiveThan(inputPrice))
      ||
      d.right.visit(new StarterExpensiveThan(inputPrice));
  }
}

/*NOTE
 * The two classes below are for the original MatchLowPrice and MatchGarlic methods that were provided.
 * The methods are now implemented via the IProc interface and the visitors. Accordingly, the methods
 * have been edited to also count the respective items (though we elected to keep the original names).
 * */

//class for the function that returns the number of items that are cheaper than 10 units
class MatchLowPrice implements IProc<Integer>{  
  MatchLowPrice(){}
  
  public Integer processStarter(Starter s){
    if(s.price<10) return 1;
    else return 0;
  }
  
  public Integer processEntree(Entree e){
    if(e.price<10) return 1;
    else return 0;
  }
  
  public Integer processDessert(Dessert d){
    if(d.price<10) return 1;
    else return 0;
  } 
  
  public Integer processMtMenu(MtMenu m){
    return 0;
  }
  
  public Integer processDataMenu(DataMenu d){
    return d.item.visit(new MatchLowPrice())
      +
      d.left.visit(new MatchLowPrice())
      +
      d.right.visit(new MatchLowPrice());
  }
}

//class for the function that returns the number of items that are garlicy
class MatchGarlic implements IProc<Integer>{  
  MatchGarlic(){}
  
  public Integer processStarter(Starter s){
    if(s.name.startsWith("garlic")) return 1;
    else return 0;
  }
  
  public Integer processEntree(Entree e){
    if(e.name.startsWith("garlic")) return 1;
    else return 0;
  }
  
  public Integer processDessert(Dessert d){
    if(d.name.startsWith("garlic")) return 1;
    else return 0;
  } 
  
  public Integer processMtMenu(MtMenu m){
    return 0;
  }
  
  public Integer processDataMenu(DataMenu d){
    return d.item.visit(new MatchGarlic())
      +
      d.left.visit(new MatchGarlic())
      +
      d.right.visit(new MatchGarlic());
  }
}
//-------------------------------------------------

class Examples {
  Examples(){}
  
  // example data
  Starter bread = new Starter("garlic bread", 6);
  Starter salad = new Starter("salad", 5);
  Entree pasta = new Entree("pasta", 11);
  Entree chicken = new Entree("garlic chicken", 14);
  Dessert dessert = new Dessert("garlic ice cream", 4);
  Entree garlicPasta = new Entree("garlic pasta", 11);
  Dessert lemonDessert = new Dessert("lemon ice cream", 4);
  Starter chickenSalad = new Starter("chicken salad", 10);
  Starter olives = new Starter("olives", 30);
  
  IMenu M = new DataMenu(bread, 
                         new DataMenu(salad),
                         new DataMenu(pasta, 
                                      new DataMenu(chicken), 
                                      new DataMenu(dessert)));
  
  IMenu M2 = new DataMenu(bread, 
                          new DataMenu(salad),
                          new DataMenu(garlicPasta, 
                                       new DataMenu(chicken), 
                                       new DataMenu(lemonDessert)));
  
  IMenu M3 = new DataMenu(bread, new DataMenu(salad), new DataMenu(chickenSalad));
  
  IMenu M4 = new DataMenu(bread, 
                          new DataMenu(salad),
                          new DataMenu(garlicPasta, 
                                       new DataMenu(chicken), 
                                       new DataMenu(lemonDessert, new DataMenu(chickenSalad), new DataMenu(olives))));
  
  //test cases
  boolean testPrice1(Tester t) {
    return t.checkExpect(M.visit(new MatchLowPrice()),3);
  }
  
  boolean testGarlic1(Tester t) {
    return t.checkExpect(M.visit(new MatchGarlic()),3);
  }
  
  boolean testGarlicEntreesLemonDesserts1(Tester t) {
    return t.checkExpect(chicken.visit(new MatchGarlicEntreesLemonDesserts()), 1);
  }
  
  boolean testGarlicEntreesLemonDesserts2(Tester t) {
    return t.checkExpect(M.visit(new MatchGarlicEntreesLemonDesserts()), 1);
  }
  
  boolean testGarlicEntreesLemonDesserts3(Tester t) {
    return t.checkExpect(M2.visit(new MatchGarlicEntreesLemonDesserts()), 3);
  }
  
  boolean testGarlicEntreesLemonDesserts4(Tester t) {
    return t.checkExpect(M4.visit(new MatchGarlicEntreesLemonDesserts()), 3);
  }
  
  boolean testCountStarters1(Tester t) {
    return t.checkExpect(M.visit(new CountStarters()), 2);
  }
  
  boolean testCountStarters2(Tester t) {
    return t.checkExpect(M3.visit(new CountStarters()), 3);
  }
  
  boolean testCountStarters3(Tester t) {
    return t.checkExpect(M4.visit(new CountStarters()), 4);
  }
  
  boolean testExpensiveStarters1(Tester t) {
    return t.checkExpect(M.visit(new ExpensiveStarters()), false);
  }
  
  boolean testExpensiveStarters2(Tester t) {
    return t.checkExpect(M4.visit(new ExpensiveStarters()), true);
  }
  
  boolean testStarterExpensiveThan1(Tester t) {
    return t.checkExpect(M.visit(new StarterExpensiveThan(0)), true);
  }
  
  boolean testStarterExpensiveThan2(Tester t) {
    return t.checkExpect(M.visit(new StarterExpensiveThan(6)), false);
  }
  
  boolean testStarterExpensiveThan3(Tester t) {
    return t.checkExpect(M4.visit(new StarterExpensiveThan(15)), true);
  }
  
  boolean testStarterExpensiveThan4(Tester t) {
    return t.checkExpect(M3.visit(new StarterExpensiveThan(15)), false);
  }
}
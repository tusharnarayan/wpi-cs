/*Homework 2
 * Standard Version
 * 
 * Tushar Narayan
 * tnarayan
 * 
 * Saraf Rahman
 * strahman
 * */

//superclass for generic vehicles
class Vehicle{
  int seats;
  int mileage;
  int baseHourlyRate;
  //constructor
  Vehicle(int seats, int mileage, int baseHourlyRate){
    this.seats = seats;
    this.mileage = mileage;
    this.baseHourlyRate = baseHourlyRate;
  }
  //returns the cost of renting the vehicle at the base hourly rate
  int rentalCost(int numHours) {
    return numHours * this.baseHourlyRate;
  }
}

//abstract class for vehicles that have a premium price charge on top of hourly rental cost
abstract class LuxuryVehicle extends Vehicle {
  int premiumPrice;
  //constructor
  LuxuryVehicle(int seats, int mileage, int baseHourlyRate, int premiumPrice){
    super(seats, mileage, baseHourlyRate);
    this.premiumPrice = premiumPrice;
  }
  //returns the cost of renting the luxury vehicle 
  //(factoring in the extra cost of the premium surcharge)
  int rentalCost(int numHours){
    return numHours * (this.premiumPrice + this.baseHourlyRate);
  }
}

//abstract class for vehicles that have no premium charge associated with their rental

//Note - right now, this class does nothing more than maintain 
//the class heirarchy, and thereby the code understandibility.
//But it makes future extensions to the code easier.
abstract class StandardVehicle extends Vehicle{
  StandardVehicle(int seats, int mileage, int baseHourlyRate){
    super(seats, mileage, baseHourlyRate);
  }
}

//interface for those vehicles that have a conventional engine 
//that would require an oil change at some point
//(when a specific mileage has been reached)
interface IConventionalEngine{
  boolean needsOilChange();
}

/*In all the following classes representing real world vehicles, 
 * we assume a constant baseHourlyRate for all instances of that class - 
 * for example, all Rickshaws have a constant hourly rate, as do all limos.
 * Thus, we do not ask for that input when the constructor is called; 
 * instead it is supplied by the constructor itself.
 * */

class Rickshaw extends StandardVehicle {
  //constructor
  Rickshaw(int seats, int mileage) {
    super(seats, mileage, 10);
  }
}

class SchoolBus extends StandardVehicle implements IConventionalEngine {
  String color;
  //constructor
  SchoolBus(int seats, int mileage, String color){
    super(seats, mileage, 500);
    this.color = color;
  }
  //returns a boolean indicating whether or not the School bus needs an oil change
  public boolean needsOilChange() {
    return (this.mileage > 6000);
  }
}

class Limo extends LuxuryVehicle implements IConventionalEngine{
  boolean hasDiscoLights;
  //constructor
  //Note - the premium price would depend on how new the specific limo is, hence it's not a constant
  //but the base rate for all limos would be the same
  Limo(int seats, int mileage, int premiumPrice, boolean hasDiscoLights){
    super(seats, mileage, 2000, premiumPrice);
    this.hasDiscoLights = hasDiscoLights;
  }
  // luxury vehicles incur a higher hourly rate, raised by premium rate
  // this method returns that increased hourly cost of renting a limo
  int hourlyCost() {
    return this.premiumPrice + this.baseHourlyRate; 
  }
  //returns a boolean indicating whether or not the limo needs an oil change
  public boolean needsOilChange() {
    return (this.mileage > 3000);
  }
}

class Unicycle extends StandardVehicle {
  //constructor
  Unicycle() {
    super(1, 0, 10);
  }
}

/*Criteria used to capture each concept as a class, abstract class or interface:
 * Classes were made for the concepts that have to have objects made for them 
 * during program runtime - Unicycle, Limo, SchoolBus, Rickshaw
 * In addition, the Vehicle superclass was not made abstract since it might be 
 * necessary during program extension in the future to create
 * an object of type vehicle - new Vehicle makes sense in the real world implementation.
 * 
 * LuxuryVehicle was made an abstract classes since it functions as a code repository 
 * for vehicles that have a premiumPrice.
 * StandardVehicle was also made an abstract class to help maintain class heirarchy 
 * and program understandibility. In addition, it makes program
 * extension in the future easier.
 * 
 * The concept of conventional engine vehicles was captured in an interface 
 * since it makes sense in the real world implementation, and ensures
 * that every class implementing IConventionalEngine has its own specific version of the needsOilChange method.
 * */

/*How the code enables extensions in the long run:
 * Since the classes and interfaces are logically defined according to a real world scenario, 
 * the code can be easily extended for other vehicle types.
 * For example, for parachutes and hang gliders, an abstract class called AirVehicles can be 
 * defined that captures all the common properties (including
 * the maintainance issues for these),  and then the classes Parachute and HangGlider 
 * can just extend that abstract class.
 * */
/*Homework 1
 * Standard Version
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

interface ITournament{
  boolean allScoresValid();
  /*method allScoresValid returns true if every match in the tournament has a valid score, else returns false*/
  String getFirstTeamName();
  /*method getFirstTeamName returns the name of the first team of the object of type ITournament*/
  String getSecondTeamName();
  /*method getSecondTeamName returns the name of the second team of the object of type ITournament*/
  boolean playersAlwaysAdvanced();
  /*method playersAlwaysAdvanced that produces a boolean indicating whether each contestant
   * in an advance match played in one of the feeder matches*/
  int matchesPlayed(String contestantName);
  /*method matchesPlayed consumes a contestant name and 
   * produces the number of matches in the tournament in which the named contestant played.*/
}

class InitMatch implements ITournament{
  MatchData data;
  InitMatch(MatchData data){
    //constructor
    this.data = data;
  }
  public boolean allScoresValid(){
    /*method allScoresValid returns true if every match in the tournament has a valid score, else returns false*/
    return data.score.isValid();
  }
  public String getFirstTeamName(){
    /*method getFirstTeamName returns the name of the first team of the object of type ITournament,
     * since class InitMatch implements Itournament*/
    return this.data.team1;
  }
  public String getSecondTeamName(){
    /*method getSecondTeamName returns the name of the second team of the object of type ITournament,
     * since class InitMatch implements Itournament*/
    return this.data.team2;
  }
  public int matchesPlayed(String contestantName){
    /*method matchesPlayed consumes a contestant name and 
     * produces the number of matches in the tournament in which the named contestant played.*/
    if(this.data.team1.equals(contestantName) || this.data.team2.equals(contestantName))
      return 1;
    else return 0;
  }
  public boolean playersAlwaysAdvanced(){
    /*method playersAlwaysAdvanced that produces a boolean indicating whether each contestant
     * in an advance match played in one of the feeder matches*/
    //Since an object of class InitMatch() has no feeders, the method simply returns true in this case.
    return true;
  }
}

class AdvanceMatch implements ITournament{
  MatchData data;
  ITournament feeder1;
  ITournament feeder2;
  AdvanceMatch(MatchData data, ITournament feeder1, ITournament feeder2){
    //constructor
    this.data = data;
    this.feeder1 = feeder1;
    this.feeder2 = feeder2;
  }
  public boolean allScoresValid(){
    /*method allScoresValid returns true if every match in the tournament has a valid score, else returns false*/
    if (data.score.isValid() && 
        (feeder1.allScoresValid() && feeder2.allScoresValid()))
      return true;
    else return false;
  }
  public String getFirstTeamName(){
    /*method getFirstTeamName returns the name of the first team of the object of type ITournament,
     * since class AdvanceMatch implements Itournament*/
    return this.data.team1;
  }
  public String getSecondTeamName(){
    /*method getSecondTeamName returns the name of the second team of the object of type ITournament,
     * since class AdvanceMatch implements Itournament*/
    return this.data.team2;
  }
  public boolean playersAlwaysAdvanced(){
    /*method playersAlwaysAdvanced that produces a boolean indicating whether each contestant
     * in an advance match played in one of the feeder matches*/
    //if the teams playing in this game both have their names in either one of the two feeders, then we return true
    if ((((data.team1.equals(feeder1.getFirstTeamName())) || (data.team1.equals(feeder1.getSecondTeamName()))) ||
        ((data.team1.equals(feeder2.getFirstTeamName())) || (data.team1.equals(feeder2.getSecondTeamName()))))
      &&
        (((data.team2.equals(feeder1.getFirstTeamName())) || (data.team2.equals(feeder1.getSecondTeamName()))) ||
        ((data.team2.equals(feeder2.getFirstTeamName())) || (data.team2.equals(feeder2.getSecondTeamName())))))
      return true;
    else return false;
  }
  public int matchesPlayed(String contestantName){
    /*method matchesPlayed consumes a contestant name and 
     * produces the number of matches in the tournament in which the named contestant played.*/
    // first we check if the teams in the tournament have always advanced through playing in the feeder matches,
    // if they have we calculate the number of matches they took part in, else we don't since they haven't
    // advanced in a fair manner.
    if(playersAlwaysAdvanced()){
      if(this.data.team1.equals(contestantName) || this.data.team2.equals(contestantName))
        return 1 + this.feeder1.matchesPlayed(contestantName) + this.feeder2.matchesPlayed(contestantName);
      else return this.feeder1.matchesPlayed(contestantName) + this.feeder2.matchesPlayed(contestantName);
    }
    else return -1;
  }
}

/*Answer to question 6:
 * The matchesPlayed method assumes a valid tournament as that in which players advanced from feeder matches.
 * That assumption has been used in the first line of the function definition, where a call to
 * playersAlwaysAdvanced() is made; and depending on the result of that call the matches are counted or 
 * an error is indicated through returning a negative integer (which clearly does not make sense
 * for the number of matches played by the contestant team).
 */

class MatchData{
  String team1;
  String team2;
  MatchScore score;
  MatchData(String team1, String team2, MatchScore score){
    //constructor
    this.team1 = team1;
    this.team2 = team2;
    this.score = score;
  }
}

interface MatchScore{
  boolean isValid();
  /*method isValid determines whether the score is valid for its corresponding sport. 
   * If the score is valid, returns true; else returns false.
   **/
}

/* Answer to question 2:
 * Since the class MatchData declares variable score to be of MatchScore type, 
 * the class of any score of any sport (even those added later on) must 
 * implement the MatchScore interface. Now, since the interface MatchScore
 * has the function isValid() declared in it, Java will require every class
 * implementing the interface to have a definition of the isValid() function.
 * Hence, this code requires every sport to have an isValid() method.*/

class SoccerScore implements MatchScore{
  int goals1;
  int goals2;
  boolean hadExtraTime;
  SoccerScore(int goals1, int goals2, boolean hadExtraTime){
    //constructor
    this.goals1 = goals1;
    this.goals2 = goals2;
    this.hadExtraTime = hadExtraTime;
  }
  public boolean isValid(){
    /*method isValid determines whether the score is valid for Soccer, and returns an appropriate boolean.
     * Rule - If the two teams have the same number of goals, extra time had to have been played.*/
    if (goals1 != goals2)
      return true;
    else if (hadExtraTime == true)
      return true;
    else return false;
  }
}

class BaseballScore implements MatchScore{
  int runs1;
  int runs2;
  int totalInnings;
  BaseballScore(int runs1, int runs2, int totalInnings){
    //constructor
    this.runs1 = runs1;
    this.runs2 = runs2;
    this.totalInnings = totalInnings;
  }
  public boolean isValid(){
    /*method isValid determines whether the score is valid for Baseball, and returns an appropriate boolean.
     * Rule - at least 9 innings must have been played and the two teams may not have the same number of runs.
     * */
    if (totalInnings >= 9){
      if (runs1 == runs2)
        return false;
      else return true;
    }
    else return false;
  }
}

class Examples{
  Examples(){}
  //examples of BaseballScore
  BaseballScore sampleBaseballScore1 = new BaseballScore(20, 10, 9);
  BaseballScore sampleBaseballScore2 = new BaseballScore(30, 50, 9);
  BaseballScore sampleBaseballScore3 = new BaseballScore(35, 30, 10);
  BaseballScore sampleBaseballScore4 = new BaseballScore(2, 3, 4); 
  /*sampleBaseballScore4 is an invalid data set (with less than 9 innings), 
   * to check that functions are working correctly in the test cases
   */
  
  //examples of SoccerScore
  SoccerScore sampleSoccerScore1 = new SoccerScore(4, 5, false);
  SoccerScore sampleSoccerScore2 = new SoccerScore(5, 5, true);
  SoccerScore sampleSoccerScore3 = new SoccerScore(5, 3, false);
  SoccerScore sampleSoccerScore4 = new SoccerScore(10, 10, true);
  SoccerScore sampleSoccerScore5 = new SoccerScore(6, 2, true);
  SoccerScore sampleSoccerScore6 = new SoccerScore(2, 2, false);
  /*sampleSoccerScore6 is an invalid data set 
   * (with no extra time even though the number of goals scored is the same), 
   * to check that functions are working correctly in the test cases
   */
  
  //examples of MatchData for Baseball Matches
  MatchData sampleBaseballMatch1 = new MatchData("Red Sox", "Orioles", sampleBaseballScore1);
  MatchData sampleBaseballMatch2 = new MatchData("Diamondbacks", "Braves", sampleBaseballScore2);
  MatchData sampleBaseballMatch3 = new MatchData("Red Sox", "Braves", sampleBaseballScore3);
  
  //examples of MatchData for Soccer Matches
  MatchData sampleSoccerMatch1 = new MatchData("Germany", "Brazil", sampleSoccerScore1);
  MatchData sampleSoccerMatch2 = new MatchData("Spain", "Italy", sampleSoccerScore5);
  MatchData sampleSoccerMatch3 = new MatchData("Brazil", "Spain", sampleSoccerScore3);
  MatchData sampleSoccerMatch4 = new MatchData("Brazil", "Portugal", new SoccerScore(2, 4, false));
  MatchData sampleSoccerMatch5 = new MatchData("England", "Portugal", new SoccerScore(10, 14, false));
  MatchData sampleSoccerMatch6 = new MatchData("Portugal", "Spain", new SoccerScore(5, 1, false));
  MatchData sampleSoccerMatch7 = new MatchData("Finland", "Portugal", new SoccerScore(5, 6, false));
  
  //examples of InitMatch for Baseball Matches
  InitMatch sampleInitMatch1 = new InitMatch(sampleBaseballMatch1);
  InitMatch sampleInitMatch2 = new InitMatch(sampleBaseballMatch2);
  
  //examples of InitMatch for Soccer Matches
  InitMatch sampleInitMatch3 = new InitMatch(sampleSoccerMatch1);
  InitMatch sampleInitMatch4 = new InitMatch(sampleSoccerMatch2);
  InitMatch sampleInitMatch5 = new InitMatch(sampleSoccerMatch3);
  InitMatch sampleInitMatch6 = new InitMatch(sampleSoccerMatch5);
  InitMatch sampleInitMatch7 = new InitMatch(sampleSoccerMatch6);
  InitMatch sampleInitMatch8 = new InitMatch(sampleSoccerMatch7);
  
  //examples of AdvanceMatch
  AdvanceMatch sampleAdvanceMatch1 = new AdvanceMatch(sampleBaseballMatch3, sampleInitMatch1, sampleInitMatch2);
  AdvanceMatch sampleAdvanceMatch2 = new AdvanceMatch(sampleSoccerMatch3, sampleInitMatch3, sampleInitMatch4);
  AdvanceMatch sampleAdvanceMatch3 = new AdvanceMatch(sampleSoccerMatch4, sampleInitMatch3, sampleInitMatch4);
  /*sampleAdvanceMatch3 is an invalid data set 
   * (where all the players have not come through the feeder matches), 
   * to check that functions are working correctly in the test cases
   */
  AdvanceMatch sampleAdvanceMatch4 = new AdvanceMatch(sampleSoccerMatch4, sampleInitMatch5, sampleInitMatch6);
  
  AdvanceMatch sampleTournamentMatch1 = new AdvanceMatch(sampleSoccerMatch6, sampleInitMatch4, sampleInitMatch8);
  /* Feeder 1 - In sampleInitMatch4, Spain played Italy, Spain won.
   * Feeder 2 - In sampleInitMatch8, Finland played Portugal, Portugal won.
   * Hence, here Portugal plays Spain. Portugal wins 5-1.
   * */
  AdvanceMatch sampleTournamentMatch2 = new AdvanceMatch(sampleSoccerMatch3, sampleInitMatch3, sampleInitMatch4);
  /* Feeder 1 - In sampleInitMatch3, Germany played Brazil, Brazil won.
   * Feeder 2 - In sampleInitMatch4, Spain played Italy, Spain won.
   * Hence, here Brazil plays Spain. Brazil wins 5-3.
   * */
  AdvanceMatch sampleTournamentFinal = new AdvanceMatch(sampleSoccerMatch4, sampleTournamentMatch1, sampleTournamentMatch2);
  /*Feeder 1 gives Portugal.
   * Feeder 2 gives Brazil.
   * Brazil plays Portugal for the final game of the tournament. Portugal wins 4-2.
   * */
  
  
  // TEST CASES FOLLOW:
  
  //test cases for isValid() for BaseballScore
  boolean test1(Tester t){
    return t.checkExpect(sampleBaseballScore1.isValid(), true);
  }
  boolean test2(Tester t){
    return t.checkExpect(sampleBaseballScore2.isValid(), true);
  }
  boolean test3(Tester t){
    return t.checkExpect(sampleBaseballScore3.isValid(), true);
  }
  boolean test4(Tester t){
    return t.checkExpect(sampleBaseballScore4.isValid(), false);
  }
  
  //test cases for isValid() for SoccerScore
 boolean test5(Tester t){
   return t.checkExpect(sampleSoccerScore1.isValid(), true);
 }
 boolean test6(Tester t){
   return t.checkExpect(sampleSoccerScore2.isValid(), true);
 }
  boolean test7(Tester t){
   return t.checkExpect(sampleSoccerScore3.isValid(), true);
 }
  boolean test8(Tester t){
   return t.checkExpect(sampleSoccerScore4.isValid(), true);
 }
  boolean test9(Tester t){
   return t.checkExpect(sampleSoccerScore5.isValid(), true);
 }
  boolean test10(Tester t){
   return t.checkExpect(sampleSoccerScore6.isValid(), false);
 }
  
  //test cases for allScoresValid()
  boolean test11(Tester t){
   return t.checkExpect(sampleInitMatch1.allScoresValid(), true);
 }
  boolean test12(Tester t){
   return t.checkExpect(sampleInitMatch2.allScoresValid(), true);
 }
  boolean test13(Tester t){
   return t.checkExpect(sampleInitMatch3.allScoresValid(), true);
 }
  boolean test14(Tester t){
   return t.checkExpect(sampleInitMatch4.allScoresValid(), true);
 }
  boolean test15(Tester t){
   return t.checkExpect(sampleInitMatch5.allScoresValid(), true);
 }
  
  //test cases for getFirstTeamName() and getSecondTeamName()
  boolean test16(Tester t){
   return t.checkExpect(sampleInitMatch1.getFirstTeamName(), "Red Sox");
 }
  boolean test17(Tester t){
   return t.checkExpect(sampleInitMatch1.getSecondTeamName(), "Orioles");
 }
  boolean test18(Tester t){
   return t.checkExpect(sampleInitMatch3.getFirstTeamName(), "Germany");
 }
  boolean test19(Tester t){
   return t.checkExpect(sampleInitMatch3.getSecondTeamName(), "Brazil");
  }
  
  //test cases for playersAlwaysAdvanced()
  boolean test20(Tester t){
    return t.checkExpect(sampleInitMatch1.playersAlwaysAdvanced(), true);
  }
  boolean test21(Tester t){
    return t.checkExpect(sampleInitMatch5.playersAlwaysAdvanced(), true);
  }
  boolean test22(Tester t){
   return t.checkExpect(sampleAdvanceMatch1.playersAlwaysAdvanced(), true);
 }
  boolean test23(Tester t){
   return t.checkExpect(sampleAdvanceMatch2.playersAlwaysAdvanced(), true);
 }
  boolean test24(Tester t){
   return t.checkExpect(sampleAdvanceMatch3.playersAlwaysAdvanced(), false);
 }
  boolean test25(Tester t){
   return t.checkExpect(sampleAdvanceMatch4.playersAlwaysAdvanced(), true);
 }
  
  //test cases for matchesPlayed()
  boolean test26(Tester t){
   return t.checkExpect(sampleAdvanceMatch4.matchesPlayed("Brazil"), 2);
 }
  boolean test27(Tester t){
   return t.checkExpect(sampleTournamentFinal.matchesPlayed("Brazil"), 3);
 }
  boolean test28(Tester t){
   return t.checkExpect(sampleTournamentFinal.matchesPlayed("Portugal"), 3);
 }
  boolean test29(Tester t){
   return t.checkExpect(sampleAdvanceMatch3.matchesPlayed("Brazil"), -1);
 }
  /*Since all teams in sampleAdvanceMatch3 did not come through the feeders, we get the number
   * -1 which clearly indicates an error with the input according to the logic of the program.*/
}
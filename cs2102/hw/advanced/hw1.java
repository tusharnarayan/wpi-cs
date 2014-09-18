/*Homework 1
 * Advanced Version
 * 
 * Tushar Narayan
 * tnarayan
 * 
 * */

import tester.* ;
  
class Main {
  static Examples E = new Examples () ;
  
  public static void main(String[] args) {
    Tester.run (E) ;
  }
}

interface ITournament{
}


class InitMatch implements ITournament{
  MatchData data;
  InitMatch(MatchData data){
    //constructor
    this.data = data;
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
}

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
}

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
}

class TennisScore implements MatchScore{
  int numberOfSets;
  int [] player1Scores = new int[numberOfSets];
  int [] player2Scores = new int[numberOfSets];
  TennisScore(int numberOfSets){
    this.numberOfSets = numberOfSets;
    getPlayer1Scores(for (int i=0; i< numberOf
  }
}

class Examples{
  Examples(){}
}
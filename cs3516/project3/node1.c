//CS3516 B Term, 2013
//Computer Networks
//Project 3
//Routing protocol

//Tushar Narayan
//tnarayan@wpi.edu

#include <stdio.h>
#include "project3.h"
#include <string.h>

extern int TraceLevel;
extern float clocktime;

int myNode1 = 1;

int prettyPrintRestrainer1 = 4; //used to only print for 4 nodes when printing packets
int printCounter1 = 0; //counter for the number of nodes printed

struct distance_table {
  int costs[MAX_NODES][MAX_NODES];
};

struct distance_table dt1;
struct NeighborCosts   *neighbor1;

//prototype
void printdt1( int MyNodeNumber, struct NeighborCosts *neighbor, struct distance_table *dtptr ); 

/* students to write the following two routines, and maybe some others */

void rtinit1() {
  int i, j;
  int min[MAX_NODES]; //array of minimum distances for each node
  int localMinimum; //stores minimum distance for each node in turn
  struct RoutePacket distanceUpdatePacket;
  
  if (TraceLevel >= 1){
    printf("At time t=%f, rtinit1() called.\n", clocktime);
  }
  
  //getNeighborCosts is defined in project3.c
  neighbor1 = getNeighborCosts(myNode1);
  
  //construct the distance table with values
  //the distance table is a 2d matrix of MAX_NODES by MAX_NODES
  for(i = 0; i < MAX_NODES; i++){
    for(j = 0; j < MAX_NODES; j++){
      if(i == j){
	dt1.costs[i][j] = neighbor1->NodeCosts[j];
      }
      else{ //no path
	dt1.costs[i][j] = INFINITY;
      }
    }
  }
  
  for(i = 0; i < MAX_NODES; i++){
    localMinimum = INFINITY;
    for(j = 0; j < MAX_NODES; j++){
      if(dt1.costs[i][j] < localMinimum){
	localMinimum = dt1.costs[i][j];
      }
    }
    min[i] = localMinimum;
  }
  
  //print contents of distance table
  if(TraceLevel >= 1){
    printdt1(myNode1, neighbor1, &dt1);
  }  
  
  //send an update packet to all the nodes in the network
  for(i = 0; i < neighbor1->NodesInNetwork; i++){
    if((i != myNode1) && (neighbor1->NodeCosts[i] != INFINITY)){
      distanceUpdatePacket.sourceid = myNode1; //source router is myNode1
      distanceUpdatePacket.destid = i; //destination router
      //copy over the array of minimum distances for each node
      memcpy(distanceUpdatePacket.mincost, min , sizeof(distanceUpdatePacket.mincost));
	  if(TraceLevel >= 1){
	  printf("At time t=%f, node %d sends packet to node %d with: ", clocktime, distanceUpdatePacket.sourceid, distanceUpdatePacket.destid);
	  for(j = 0, printCounter1 = 0; (j < MAX_NODES) && (printCounter1 < prettyPrintRestrainer1); j++, printCounter1++){
		printf("%d   ", min[j]);
      }
      printf("\n");
	}
      //send packet
      toLayer2(distanceUpdatePacket);
    }
  }  
}

void rtupdate1( struct RoutePacket *rcvdpkt ) {
  int i, j;  
  int source = rcvdpkt->sourceid; //packet sender
  
  //flag to indicate if the distance table was changed
  //0 indicates no change
  //1 indicates a change
  int changeFlag = 0;
  
  int localMinCost; //stores minimum cost from this node 
  //to the sender node in turn for each sender
  
  if(TraceLevel >= 1){
	printf("At time t=%f, rtupdate1() called. node %d receives a packet from node %d\n", clocktime, myNode1, source);
  }

  //update distance table
  for(i = 0; i < neighbor1->NodesInNetwork; i++){
    localMinCost = rcvdpkt->mincost[i];
    if(dt1.costs[i][source] > (dt1.costs[source][source] + localMinCost)){
      dt1.costs[i][source] = dt1.costs[source][source] + localMinCost;     
      changeFlag = 1; //set flag to indicate a change in distance table
    }
  }
  
  //if the distance table has changed
  //calculate minimum costs for each node
  //send an update to all nodes in the network
  if(changeFlag == 1){
    int min[MAX_NODES]; //array of minimum distances for each node
    int localMinimum; //stores minimum distance for each node in turn
    for(i = 0; i < MAX_NODES; i++){
      localMinimum = INFINITY;
      for(j = 0; j < MAX_NODES; j++){
	if(dt1.costs[i][j] < localMinimum){
	  localMinimum = dt1.costs[i][j];
	}
      }
      min[i] = localMinimum;
    }
    
	//print contents of distance table
    if(TraceLevel >= 1){
      printdt1(myNode1, neighbor1, &dt1);
    }
	
    //send an update packet to all the nodes in the network
    struct RoutePacket distanceUpdatePacket;
    for(i = 0; i < neighbor1->NodesInNetwork; i++){
      if((i != myNode1) && (neighbor1->NodeCosts[i] != INFINITY)){
	distanceUpdatePacket.sourceid = myNode1; //source router is myNode1
	distanceUpdatePacket.destid = i; //destination router
	//copy over the array of minimum distances for each node
	memcpy(distanceUpdatePacket.mincost, min, sizeof(distanceUpdatePacket.mincost));
	if(TraceLevel >= 1){
	  printf("At time t=%f, node %d sends packet to node %d with: ", clocktime, distanceUpdatePacket.sourceid, distanceUpdatePacket.destid);
	  for(j = 0, printCounter1 = 0; (j < MAX_NODES) && (printCounter1 < prettyPrintRestrainer1); j++, printCounter1++){
		printf("%d   ", min[j]);
      }
      printf("\n");
	}
	//send packet
	toLayer2(distanceUpdatePacket);
      }  
    }
   }
   else{
	//print contents of distance table
	if(TraceLevel >= 1){
	  printdt1(myNode1, neighbor1, &dt1);
    }  
  }
}


/////////////////////////////////////////////////////////////////////
//  printdt
//  This routine is being supplied to you.  It is the same code in
//  each node and is tailored based on the input arguments.
//  Required arguments:
//  MyNodeNumber:  This routine assumes that you know your node
//                 number and supply it when making this call.
//  struct NeighborCosts *neighbor:  A pointer to the structure 
//                 that's supplied via a call to getNeighborCosts().
//                 It tells this print routine the configuration
//                 of nodes surrounding the node we're working on.
//  struct distance_table *dtptr: This is the running record of the
//                 current costs as seen by this node.  It is 
//                 constantly updated as the node gets new
//                 messages from other nodes.
/////////////////////////////////////////////////////////////////////
void printdt1( int MyNodeNumber, struct NeighborCosts *neighbor, 
		struct distance_table *dtptr ) {
    int       i, j;
    int       TotalNodes = neighbor->NodesInNetwork;     // Total nodes in network
    int       NumberOfNeighbors = 0;                     // How many neighbors
    int       Neighbors[MAX_NODES];                      // Who are the neighbors

    // Determine our neighbors 
    for ( i = 0; i < TotalNodes; i++ )  {
        if (( neighbor->NodeCosts[i] != INFINITY ) && i != MyNodeNumber )  {
            Neighbors[NumberOfNeighbors] = i;
            NumberOfNeighbors++;
        }
    }
    // Print the header
    printf("                via     \n");
    printf("   D%d |", MyNodeNumber );
    for ( i = 0; i < NumberOfNeighbors; i++ )
        printf("     %d", Neighbors[i]);
    printf("\n");
    printf("  ----|-------------------------------\n");

    // For each node, print the cost by travelling thru each of our neighbors
    for ( i = 0; i < TotalNodes; i++ )   {
        if ( i != MyNodeNumber )  {
            printf("dest %d|", i );
            for ( j = 0; j < NumberOfNeighbors; j++ )  {
                    printf( "  %4d", dtptr->costs[i][Neighbors[j]] );
            }
            printf("\n");
        }
    }
    printf("\n");
}    // End of printdt1

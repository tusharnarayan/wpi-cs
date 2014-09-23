//CS3516 B Term, 2013
//Computer Networks
//Project 2
//Alternating Bit protocol

//Tushar Narayan
//tnarayan@wpi.edu

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "project2.h"
 
/* ***************************************************************************
 ALTERNATING BIT AND GO-BACK-N NETWORK EMULATOR: VERSION 1.1  J.F.Kurose

   This code should be used for Project 3, unidirectional or bidirectional
   data transfer protocols from A to B and B to A.
   Network properties:
   - one way network delay averages five time units (longer if there
     are other messages in the channel for GBN), but can be larger
   - packets can be corrupted (either the header or the data portion)
     or lost, according to user-defined probabilities
   - packets may be delivered out of order.

   Compile as gcc -g project3.c student3.c -o p3
**********************************************************************/



/********* STUDENTS WRITE THE NEXT SEVEN ROUTINES *********/
/* 
 * The routines you will write are detailed below. As noted above, 
 * such procedures in real-life would be part of the operating system, 
 * and would be called by other procedures in the operating system.  
 * All these routines are in layer 4.
 */

extern int TraceLevel; //from project2.c

#define RTT 20.0

//AEntity and BEntity are already defined in the header file

//sender side variables
struct pkt lastPacket; //the last packet transmitted
struct pkt lastACK; //the last packet that an ACK was received for

//receiver side variables
int expectedSeqnum; //expected sequence number at the receiver

//globals
char ACKmsg[MESSAGE_LENGTH] = {'A', 'C', 'K', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0,0,0};
char NACKmsg[MESSAGE_LENGTH] = {'N', 'A', 'C', 'K', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0,0};

//prototypes
int isCorruptedPacket(struct pkt p);
int calculateChecksum(struct pkt p);

/* 
 * A_output(message), where message is a structure of type msg, containing 
 * data to be sent to the B-side. This routine will be called whenever the 
 * upper layer at the sending side (A) has a message to send. It is the job 
 * of your protocol to insure that the data in such a message is delivered 
 * in-order, and correctly, to the receiving side upper layer.
 */
void A_output(struct msg message) {
  int checksum = 0;
  struct pkt packetToSend;
  int seqnum;

  //if the last packet sent had sequence number 0, set "seqnum" to 1
  //else set to 0
  seqnum = (lastPacket.seqnum == 0)? 1 : 0;
  
  //make packet ready to transmit
  packetToSend.seqnum = seqnum;
  packetToSend.acknum = 0;
  strncpy(packetToSend.payload, message.data, MESSAGE_LENGTH);
  checksum = calculateChecksum(packetToSend);
  packetToSend.checksum = checksum;
  
  //if the last ACKed packet was the same as the current one
  if(lastACK.acknum == packetToSend.seqnum){
    return;
  }
  
  if(TraceLevel >= 4) printf("AEntity sending packet with seqnum %d and checksum %d ", seqnum, packetToSend.checksum);
  
  //save the packet in state variable (if retransmission required)
  lastPacket.seqnum = packetToSend.seqnum;
  lastPacket.acknum = packetToSend.acknum;
  strncpy(lastPacket.payload, message.data, MESSAGE_LENGTH);
  checksum = calculateChecksum(lastPacket);
  lastPacket.checksum = checksum;
  
  if(TraceLevel >= 4) printf("AEntity sending packet!\n");
  tolayer3(AEntity, packetToSend);
  startTimer(AEntity, 500);
}

/*
 * Just like A_output, but residing on the B side.  USED only when the 
 * implementation is bi-directional.
 */
void B_output(struct msg message) {
  
}

/* 
 * A_input(packet), where packet is a structure of type pkt. This routine 
 * will be called whenever a packet sent from the B-side (i.e., as a result 
 * of a tolayer3() being done by a B-side procedure) arrives at the A-side. 
 * packet is the (possibly corrupted) packet sent from the B-side.
 */
void A_input(struct pkt packet) {
  int i;
  int checksum;
  
  //sanity check
  if((isCorruptedPacket(packet) == FALSE) && (strncmp(packet.payload, "ACK", strlen("ACK")) == 0) && (packet.acknum == lastPacket.seqnum)){
    if(TraceLevel >= 4)	printf("AEntity got a valid expected ACK!\n");
	//store last ACKed packet in state variable
    lastACK.seqnum = packet.seqnum;
    lastACK.acknum = packet.acknum;
    for(i = 0; i < MESSAGE_LENGTH; i++){
      lastACK.payload[i] = packet.payload[i];
    }
	checksum = calculateChecksum(lastACK);
    lastACK.checksum = checksum;
    stopTimer(AEntity);
  }
  else{
    if(TraceLevel >= 4) printf("AEntity did not get a valid expected ACK, resending last packet with seqnum %d and checksum %d \n", lastPacket.seqnum, lastPacket.checksum);
    tolayer3(AEntity, lastPacket);
    startTimer(AEntity, 500);
  }
}

/*
 * A_timerinterrupt()  This routine will be called when A's timer expires 
 * (thus generating a timer interrupt). You'll probably want to use this 
 * routine to control the retransmission of packets. See starttimer() 
 * and stoptimer() in the writeup for how the timer is started and stopped.
 */
void A_timerinterrupt(){
  if(lastPacket.seqnum != lastACK.acknum){
    if(TraceLevel >= 4) printf("AEntity timed out, resending last packet with seqnum %d and checksum %d \n", lastPacket.seqnum, lastPacket.checksum);
    tolayer3(AEntity, lastPacket);
    startTimer(AEntity, 500);
  }
  else{
    if(TraceLevel >= 4) printf("AEntity timed out, but the last packet sent was already acked\n");
  }
}  

/* The following routine will be called once (only) before any other    */
/* entity A routines are called. You can use it to do any initialization */
void A_init(){
  int i;
  lastPacket.seqnum = 1; //set to 1 so that in A_output seqnum gets set to 0
  lastPacket.acknum = 0;
  for(i = 0; i < MESSAGE_LENGTH; i++){
    lastPacket.payload[i] = 0;
  }
  lastPacket.checksum = 0;
  lastACK.seqnum = -1;
  lastACK.acknum = -1;
  for(i = 0; i< MESSAGE_LENGTH; i++){
    lastACK.payload[i] = 0;
  }
  lastACK.checksum = 0;
}

/* 
 * Note that with simplex transfer from A-to-B, there is no routine  B_output() 
 */

/*
 * B_input(packet),where packet is a structure of type pkt. This routine 
 * will be called whenever a packet sent from the A-side (i.e., as a result 
 * of a tolayer3() being done by a A-side procedure) arrives at the B-side. 
 * packet is the (possibly corrupted) packet sent from the A-side.
 */
void B_input(struct pkt packet) {
  int checksum;
  int i;
  struct pkt replyPacket;
  struct msg msgToSend;

  if(TraceLevel >= 4){
    printf("BEntity expects packet with seqnum %d \n", expectedSeqnum);
    printf("BEntity received packet with seqnum %d and checksum %d \n", packet.seqnum, packet.checksum);
  }
  if((isCorruptedPacket(packet) == FALSE) && (packet.seqnum == expectedSeqnum)){
    if(TraceLevel >= 4) printf("BEntity received the non-corrupt, expected packet!\n");
    
    replyPacket.seqnum = packet.seqnum;
    replyPacket.acknum = packet.seqnum;
    for(i = 0; i < MESSAGE_LENGTH; i++){
      replyPacket.payload[i] = *ACKmsg;
    }
	checksum = calculateChecksum(replyPacket);
    replyPacket.checksum = checksum;
	
    if(TraceLevel >= 4)printf("BEntity sending ACK!\n");
    tolayer3(BEntity, replyPacket);
	
    for(i = 0; i < MESSAGE_LENGTH; i++){
      msgToSend.data[i] = packet.payload[i];
    }
    if(TraceLevel >= 4) printf("BEntity sending message!\n");
    tolayer5(BEntity, msgToSend);
	
	//update the seqnum of the next expected packet
    expectedSeqnum = 1 - expectedSeqnum;
  }
  else{
    if(TraceLevel >= 4) printf("BEntity did not receive a valid, expected packet!\n");
    replyPacket.seqnum = packet.seqnum;
    replyPacket.acknum = -1;
    for(i = 0; i < MESSAGE_LENGTH; i++){
      replyPacket.payload[i] = *NACKmsg;
    }
	checksum = calculateChecksum(replyPacket);
    replyPacket.checksum = checksum;
    
	if(TraceLevel >= 4) printf("BEntity sending NACK!\n"); 
    tolayer3(BEntity, replyPacket);
  }
}

/*
 * B_timerinterrupt()  This routine will be called when B's timer expires 
 * (thus generating a timer interrupt). You'll probably want to use this 
 * routine to control the retransmission of packets. See starttimer() 
 * and stoptimer() in the writeup for how the timer is started and stopped.
 */
void B_timerinterrupt(){
}

/* 
 * The following routine will be called once (only) before any other   
 * entity B routines are called. You can use it to do any initialization 
 */
void B_init(){
  expectedSeqnum = 0;
}

//method to calculate the checksum
//places importance on both the value of the data and
//its place in the array
int calculateChecksum(struct pkt p){
  int i = 0;
  int checksum = 0;
  for(i = 0; i < MESSAGE_LENGTH; i++){
    checksum = (checksum + (i * ((int) (p.payload[i]))));
  }
  return checksum;
}

//method to check if the packet is corrupted
//calculates the checksum independently and compares it
//returns true if the packet is corrupted
int isCorruptedPacket(struct pkt p){
  int checksum = calculateChecksum(p);
  
  if((p.checksum) == checksum){
    return FALSE;
  }
  else{
    return TRUE;
  }
}

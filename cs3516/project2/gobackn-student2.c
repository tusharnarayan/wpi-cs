//CS3516 B Term, 2013
//Computer Networks
//Project 2
//Go-Back-N protocol

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

#define WINDOWSIZE 5 //the number of packets that have been sent and are currently un-ACKed
#define BUFFERSIZE 100 //the number of packets that are buffered to transmit later

extern int TraceLevel; //from project2.c

#define RTT 20.0

//sender side variables
int nextSeqnum; //next sequence number at the sender
struct pkt packetsBuffer[BUFFERSIZE]; //array of packets
int baseOfBuffer; //sequence number that the buffer currently needs to start from
int bufferIndex; //index of buffer where the next packet will be stored

//receiver side variables
int expectedSeqnum; //expected sequence number at the receiver
int lastReceivedSeqnum; //sequence number of last packet received

//prototypes
int calculateChecksum(struct pkt p);

/*
 * A_output(message), where message is a structure of type msg, containing
 * data to be sent to the B-side. This routine will be called whenever the
 * upper layer at the sending side (A) has a message to send. It is the job
 * of your protocol to insure that the data in such a message is delivered
 * in-order, and correctly, to the receiving side upper layer.
 */
void A_output(struct msg message){
  int checksum = 0;
  struct pkt packetToSend;
  if(TraceLevel >= 4) printf("A_output: baseOfBuffer is %d, nextSeqnum is %d, bufferIndex is %d\n", baseOfBuffer, nextSeqnum, bufferIndex);
  
  if(bufferIndex >= BUFFERSIZE){ //if the buffer is full, can do nothing
    if(TraceLevel >= 4) printf("The buffer is full.\n");
    return;
  }
  
  //make packet ready for transmission
  packetToSend.seqnum = bufferIndex;
  packetToSend.acknum = 0;
  strncpy(packetToSend.payload, message.data, MESSAGE_LENGTH);
  checksum = calculateChecksum(packetToSend);
  packetToSend.checksum = checksum;
  
  //store packet in buffer
  packetsBuffer[bufferIndex] = packetToSend;
  //increment buffer index
  bufferIndex++;
  
  //if there is still space in the window to send another packet
  if(nextSeqnum < (baseOfBuffer + WINDOWSIZE)){
    if(TraceLevel >= 4) printf("AEntity sending packet with seqnum %d\n", packetToSend.seqnum);
	//send packet
    tolayer3(AEntity, packetToSend);
    if(baseOfBuffer == nextSeqnum){
	  //start timer
      startTimer(AEntity, RTT);
    }
	//increment the next sequence number at the sender
    nextSeqnum++;
  }
  else{
    if(TraceLevel >= 4) printf("The window is full. Packet has been stored in the buffer.\n");
  }
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
  int checksum = 0;
  if(TraceLevel >= 4) printf("A_input: baseOfBuffer is %d, nextSeqnum is %d, bufferIndex is %d\n", baseOfBuffer, nextSeqnum, bufferIndex);

  checksum = calculateChecksum(packet);

  //sanity checks
  if(checksum != packet.checksum){
    if(TraceLevel >= 4) printf("The received packet is corrupted!\n");
    return;
  }
  //BEntity sends packets with acknum = 1 to indicate ACK
  if(packet.acknum != 1){
    if(TraceLevel >= 4) printf("The received packet is a NACK.\n");
    return;
  }
  if(packet.seqnum < baseOfBuffer){
    if(TraceLevel >= 4) printf("The received packet is a duplicate of a previously received packet.\n");
    return;
  }
  
  //passed the sanity checks, the packet is good
  if(TraceLevel >= 4) printf("The received packet is an uncorrupted, previously-unseen packet.\n");
  baseOfBuffer = packet.seqnum + 1;

  if(baseOfBuffer == nextSeqnum){
    stopTimer(AEntity);
  }
  else{
	//still waiting on something to be acked
    startTimer(AEntity, 100);
  }
}

/*
 * A_timerinterrupt()  This routine will be called when A's timer expires
 * (thus generating a timer interrupt). You'll probably want to use this
 * routine to control the retransmission of packets. See starttimer()
 * and stoptimer() in the writeup for how the timer is started and stopped.
 */
void A_timerinterrupt() {
  if(TraceLevel >= 4) printf("A's timer has expired. Resending packets.\n");
  int i;  
  startTimer(AEntity, 100);
  //transmit all the packets in the buffer
  for(i = baseOfBuffer; i < nextSeqnum; i++){
    tolayer3(AEntity, packetsBuffer[i]);
  }
}

/* The following routine will be called once (only) before any other    */
/* entity A routines are called. You can use it to do any initialization */
void A_init(){
  baseOfBuffer = 0;
  nextSeqnum = 0;
  bufferIndex = 0;
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
  int checksum = 0;
  struct msg message;
  struct pkt replyPacket;
  
  checksum = calculateChecksum(packet);
  
  //sanity check
  if(checksum != packet.checksum || packet.seqnum != expectedSeqnum){
    if(checksum != packet.checksum){ //corrupt packet
      if(TraceLevel >= 4) printf("BEntity - received a corrupted packet;");
    }
    if(packet.seqnum != expectedSeqnum){ // packet out of order
	  //send ACK for the last received in-sequence packet
	  replyPacket.acknum = 1;
      replyPacket.seqnum = lastReceivedSeqnum;
      checksum = calculateChecksum(replyPacket);
      replyPacket.checksum = checksum;
      
      if(TraceLevel >= 4) printf("Sending ACK message for last packet successfully received");
      tolayer3(BEntity, replyPacket);
    }
  }
  else if(packet.checksum == checksum && packet.seqnum == expectedSeqnum){ //the packet is good
    if(TraceLevel >= 4) printf("BEntity - received packet in good state");
    strncpy(message.data, packet.payload, 20);
    tolayer5(BEntity, message);
	
	//update state variable to indicate seqnum of last received packet
    lastReceivedSeqnum = packet.seqnum;
	
    replyPacket.acknum = 1;
    replyPacket.seqnum = expectedSeqnum;
    checksum = calculateChecksum(replyPacket);
    replyPacket.checksum = checksum;
    tolayer3(BEntity, replyPacket);
	
	//increment to indicate seqnum of next expected packet
    expectedSeqnum++;
  }
}

/*
 * B_timerinterrupt()  This routine will be called when B's timer expires
 * (thus generating a timer interrupt). You'll probably want to use this
 * routine to control the retransmission of packets. See starttimer()
 * and stoptimer() in the writeup for how the timer is started and stopped.
 */
void  B_timerinterrupt() {
}

/*
 * The following routine will be called once (only) before any other
 * entity B routines are called. You can use it to do any initialization
 */
void B_init() {
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

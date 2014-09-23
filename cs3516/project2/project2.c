/* ***************************************************************************
ALTERNATING BIT AND GO-BACK-N NETWORK EMULATOR: 

   This code should be used for Project 3, unidirectional or bidirectional
   data transfer protocols from A to B and B to A.
   Network properties:
   - one way network delay averages five time units (longer if there
     are other messages in the channel for GBN), but can be larger
   - packets can be corrupted (either the header or the data portion)
     or lost, according to user-defined probabilities
   - packets may be delivered out of order.
VERSIONS:
1.1 - the version from Jim Kurose
1.2 - some modifications of the code were made on the web - mostly cleanup.
      I don't quite know all the places they came from.
2.0 - October 2005 - my modifications - and there are lots of them.  Make
                     it possible to run on windows.
2.05 - November lots of small things:
              Individual inputs weren't correctly handling decimals
              Sometimes packets weren't really being corrupted.
              routine to see if a timer is running.
              timer warning messages should come out only at certain
              debugging levels.
2.10 - February 2011 - lots of cleanup.
2.20 - October 2013  - Prep for WPI Class
2.30 - November 2013 - Enhancements to better support bidirectional 
              and Go Back N
2.31 - November 2013 - Version released to 3016 class.
*****************************************************************************/

#include "project2.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>
#ifdef  WINDOWS
    #include <windows.h>
#endif


/* ***************************************************************************
*********************** NETWORK EMULATION CODE STARTS BELOW ******************
The code below emulates the layer 3 and below network environment:
  - emulates the tranmission and delivery (possibly with corruption
    and packet loss) of packets across the layer 3/4 interface
  - handles the starting/stopping of a timer, and generates timer
    interrupts (resulting in calling students timer handler).
  - generates message to be sent (passed from layer 5 to 4)

THERE IS NO REASON THAT ANY STUDENT SHOULD HAVE TO READ OR UNDERSTAND
THE CODE BELOW.  YOU SHOULD NOT TOUCH, OR REFERENCE (in your code) ANY
OF THE DATA STRUCTURES BELOW.  If you're interested in how the emulator
is designed, you're welcome to look at the code.  But again, it's not a
requirement that you read the code - and you certainly shouldn't modify
the code.
*****************************************************************************/

// Used to keep an ordered list of the events in the simulator
struct     event {
    double       evtime;         // event time 
    int          evtype;         // event type code 
    int          eventity;       // entity where event occurs 
    struct pkt   *pktptr;        // ptr to packet (if any) assoc w/ this event
    struct event *prev;          
    struct event *next;
};

struct event *evlist = NULL;   /* the event list */

/* possible events: */
#define  TIMER_INTERRUPT 0  
#define  FROM_LAYER5     1
#define  FROM_LAYER3     2
#define  VersionString "2.31"



#define  TIME_TO_GET_TO_OTHER_SIDE            10


int    MaxMsgsToSimulate = 0;   // number of msgs to generate, then stop 
double LossProb;                // probability that a packet is dropped  
double CorruptProb;             // probability that packet has been damaged 
double OutOfOrderProb;          // probability that packets may be out of order 
double AveTimeBetweenMsgs ;     // Average time between messages from layer 5 
int    TraceLevel = 0;          // Defines the default level of debugging 
int    RandomizationRequested;  // Should results be randomized or repeatable 
int    Bidirectional = FALSE;   // Should simulation be also from B->A?  


double CurrentSimTime = 0.000;  // The simulation time                   
int    NumMsgs5To4       = 0;   // number of messages from 5 to 4 so far 
int    NumMsgs5To4WithErr= 0;   // number of messages incorrectly received
int    NumMsgs4To5       = 0;   // number of messages from 4 to 5 so far 
int    NumMsgs4To3       = 0;   // number sent into layer 3 
int    NumMsgsLost       = 0;   // number lost in media 
int    NumMsgsCorrupt    = 0;   // number corrupted by media
int    NumMsgsOutOfOrder = 0;   // Number messages MAYBE out of order 
int    NumSimultaneousMsgs= 0;   // How many messages simultaneously in media

// These are sequence numbers used by calling and receiving application layers
int    GeneratingSeqNum[2] = { 0, 0};  // An array for A side and B side
int    ExpectedSeqNum[2] = { 0, 0};
char   EntityLetter[2] = "AB";

int    CallingArgc;              // Used to pass input params to init routine 
char   **CallingArgv;

/*   PROTOTYPES WITHIN THE SIMULATOR */

void    init( );
void    GenerateNextArrival();
void    InsertEvent(struct event *);
void    GetTimeNow( double *);
void    GetMessageString( int, int, char *); 
void    printEntireEventQ ( );
void    SetRandomSeed( long );
double  GetRandomNumber( );

/* ***************************************************************************
                      PROGRAM STARTS HERE     
*****************************************************************************/

int main( int argc, char *argv[] )     {
    struct event *eventptr;
    struct msg   msg2give;
    struct pkt   pkt2give;
   
    int          currentEntity;
    int          i,j;
  
//  Do our initialization and any requested by student's Transport Layer 
    CallingArgc = argc;
    CallingArgv = argv;
    init( );
    A_init();
    B_init();
   
    /* ***********************************************************************
      We loop here forever.  During these actions we get an event off the
      event header.  We analyze the action to be performed and go do it.
    *************************************************************************/
    while (TRUE) {
        eventptr = evlist;        // get next event to simulate from Q head 
        if (eventptr==NULL) {     //  IF nothing to simulate, we're done  
            if ( TraceLevel >= 5 )  printf("Nothing left to trace\n");
            break;
	}

        evlist = evlist->next;    // remove this event from event list 
        if (evlist != NULL)       //   and sort out forward and back ptrs
            evlist->prev=NULL;

        // Update simulation time to event time  - by definition, the
        // simulation time is the time of the last event.
        CurrentSimTime = eventptr->evtime;        
        currentEntity = eventptr->eventity;
        // If we've delivered the required number of messages, then we've
        // fullfilled our task and are done.
        if ( NumMsgs4To5 >= MaxMsgsToSimulate )  {
            if ( TraceLevel >= 5 )  printf("Messages have been completed\n");
            break;                            // all done with simulation 
	}
         
	// Print out what's on the Q
        if ( ( NumMsgs4To5 + 1 ) % (MaxMsgsToSimulate / 3) == 0 )
            printEntireEventQ ( );
        if ( TraceLevel >= 5 )    // WIth large trace level, print every time
            printEntireEventQ ( );

        /* *******************************************************************
          Here we've gotten a request to hand data from layer 5 to layer 4.
            Generate the date we want to give to the student.                 
        *********************************************************************/
        if ( eventptr->evtype == FROM_LAYER5 ) {
            // Use the sequence number as starter for the message string
            j = GeneratingSeqNum[currentEntity]++;
            // printf( "%X  %d %d\n", &eventptr, currentEntity, j );
            GetMessageString( currentEntity, j, &(msg2give.data[0]) );
            /*  Always print trace so we know it matches the receive  */
            if ( TraceLevel >= 0 )  {    
                //printf("%c: ", &(EntityLetter[currentEntity]) );
                if ( currentEntity == AEntity )   
                    printf("A: " );
                else
                    printf("B: " );
                printf(" %11.4f,", eventptr->evtime);

                printf("  Layer 5 to 4  Message = ");
                for (i=0; i<MESSAGE_LENGTH; i++) 
                    printf("%c", msg2give.data[i]);
                printf("\n");
            }
            // The simulation will actually end when the requested number of
            // messages has been received back at layer 5.  But there could be
            // many packets in the system, and that total arrival could take
            // a long time.  We want to make sure we down't overwhelm the
            // student code with messages that won't ever be delivered anyway.
            //
            if ( NumMsgs5To4 <= MaxMsgsToSimulate + 3 ) { 
                GenerateNextArrival();           // set up future arrival 
                NumMsgs5To4++;                   // # msgs from layer 5 to 4 
            }
            if ( currentEntity == AEntity )  // Pass the data to layer 4 here 
                A_output(msg2give);  
            else
                B_output(msg2give);  
        }                              /* END of event is from layer 5 */

        /* *******************************************************************
          This is a request to hand data from layer 3 up to student layer 4 
        *********************************************************************/
        else if (eventptr->evtype ==  FROM_LAYER3 ) {
            pkt2give.seqnum   = eventptr->pktptr->seqnum;
            pkt2give.acknum   = eventptr->pktptr->acknum;
            pkt2give.checksum = eventptr->pktptr->checksum;
            for ( i = 0; i < MESSAGE_LENGTH; i++)  
                pkt2give.payload[i] = eventptr->pktptr->payload[i];

            if ( TraceLevel >= 5 )  {     /* Print out trace info if requested */
                if ( eventptr->eventity == AEntity )   
                    printf("A: " );
                else
                    printf("B: " );
                printf(" %11.4f,", eventptr->evtime);

                printf("  Layer 3 to 4  ");
                printf( "Seq/Ack/Check = %d/%d/%d:  ",
                        eventptr->pktptr->seqnum, eventptr->pktptr->acknum,
                        eventptr->pktptr->checksum );
                for (i=0; i<MESSAGE_LENGTH; i++) 
                    printf("%c", eventptr->pktptr->payload[i] );
                printf("\n");
            }
            if (eventptr->eventity == AEntity)   /* deliver packet by calling */
                   A_input(pkt2give);            /* appropriate entity */
            else
                   B_input(pkt2give);
            free(eventptr->pktptr);          /* free the memory for packet */
        }                             /* END of event is from layer 3 */

        /* *******************************************************************
              This is a request for a timer interrupt 
        *********************************************************************/
        else if (eventptr->evtype ==  TIMER_INTERRUPT) {
            if ( TraceLevel >= 5 )  {     /* Print out trace info if requested */
                if ( eventptr->eventity == AEntity )   
                    printf("A: " );
                else
                    printf("B: " );
                printf(" %f,", eventptr->evtime);
                printf("  Timer Interrupt\n");
            }
            if (eventptr->eventity == AEntity) 
                A_timerinterrupt();
            else
                B_timerinterrupt();
        }                             /* END of event is interrupt request */
        else  {
            printf("INTERNAL PANIC: unknown event type \n");
        }
        free(eventptr);
    }                       // End of while

    printf("\n\nSimulator terminated at time %f\n after receiving %d msgs at layer5\n",
                  CurrentSimTime, NumMsgs4To5 );
    printf( "Simulator Analysis:\n");
    printf( "  Number of messages sent from 5 to 4: %d\n", NumMsgs5To4 );
    printf( "  Number of messages received at Layer 5, side A: %d\n",
                  ExpectedSeqNum[0]  );
    printf( "  Number of messages received at Layer 5, side B: %d\n",
                  ExpectedSeqNum[1]  );
    printf( "  Number of messages incorrectly received at layer 5: %d\n", 
                  NumMsgs5To4WithErr );
    printf( "  Number of packets entering the network: %d\n", NumMsgs4To3 );
    printf( "  Average number of packets already in network: %9.3f\n",
               (double)NumSimultaneousMsgs /  (double)NumMsgs4To3 );
    printf( "  Number of packets that the network lost: %d\n", NumMsgsLost );
    printf( "  Number of packets that the network corrupted: %d\n", 
                   NumMsgsCorrupt );
    printf( "  Number of packets that the network put out of order: %d\n", 
                   NumMsgsOutOfOrder );
    return 0;
}

/* ***************************************************************************
  ************************ INITIALIZE THE SIMULATOR HERE  *****************
Main calls here in order to initialize the simulator. 
Operations include: 
1. Ask the user for various paramenters.
2. Put an initial item on the event queue.
3. Make sure the random number generator is OK for this system.

******************************************************************************/

void init( ) {
    int      i;
    double   sum, avg;
    double   TimeNow;
    char     TempString[50];
  
    printf("-----  Network Simulator Version %6.3s -------- \n\n", VersionString);
    if ( CallingArgc  >= 9 ) {
        MaxMsgsToSimulate      = atoi( CallingArgv[1] );
        LossProb               = atof( CallingArgv[2] );
        CorruptProb            = atof( CallingArgv[3] );
        OutOfOrderProb         = atof( CallingArgv[4] );
        AveTimeBetweenMsgs     = atof( CallingArgv[5] );
        TraceLevel             = atoi( CallingArgv[6] );
        RandomizationRequested = atoi( CallingArgv[7] );
        Bidirectional          = atoi( CallingArgv[8] );
    }
    else {
        printf("Enter the number of messages to simulate: ");
        scanf( "%d", &MaxMsgsToSimulate);
        printf("Packet loss probability [enter number between 0.0 and 1.0]: ");
        scanf( "%s", TempString );
        LossProb = atof( TempString );
        printf("Packet corruption probability [0.0 for no corruption]: ");
        scanf( "%s", TempString );
        CorruptProb = atof( TempString );
        printf("Packet out-of-order probability [0.0 for no out-of-order]: ");
        scanf( "%s", TempString );
        OutOfOrderProb = atof( TempString );
        printf("Average time between messages from sender's layer5 [ > 0.0]: ");
        scanf( "%s", TempString );
        AveTimeBetweenMsgs     = atof( TempString );
        printf("Enter Level of tracing desired: ");
        scanf( "%d", &TraceLevel);
        printf("Do you want actions randomized: (1 = yes, 0 = no)? " );
        scanf( "%d", &RandomizationRequested);
        printf("Do you want Bidirectional: (1 = yes, 0 = no)? " );
        scanf( "%d", &Bidirectional);
    }
    //  Do sanity checking on inputs:
    if (   LossProb < 0 || LossProb> 1.0 || CorruptProb < 0 
                        || CorruptProb > 1.0 || OutOfOrderProb < 0 
                        || OutOfOrderProb > 1.0 || AveTimeBetweenMsgs <= 0.0 )
    {
         printf( "One of your input parameters is out of range\n");
         exit(0);
    }
    printf( "Input parameters:\n");
    printf( "Number of Messages = %d", MaxMsgsToSimulate );
    printf( "  Lost Packet Prob. =  %6.3f\n", LossProb );
    printf( "Corrupt Packet Prob. =  %6.3f", CorruptProb );
    printf( "  Out Of Order Prob. =  %6.3f\n", OutOfOrderProb );
    printf( "Ave. time between messages = %8.2f", AveTimeBetweenMsgs );
    printf( "  Trace level = %d\n", TraceLevel );
    printf( "Randomize = %d", RandomizationRequested );
    printf( "  Bi-directional = %d\n\n", Bidirectional );

    if ( RandomizationRequested == 1 )   {
        GetTimeNow( &TimeNow );
        SetRandomSeed( (long)TimeNow );
    }
    // test random number generator for students 
    // GetRandomNumber() should be uniform in [0,1] 
    sum = 0.0;               
    for (i = 0; i < 1000; i++)
        sum = sum + GetRandomNumber();  
    avg = sum/1000.0;
    if (avg < 0.25 || avg > 0.75) {
        printf("It is likely that random number generation on your machine\n" );
        printf("is different from what this emulator expects.  Please look\n");
        printf("at the routine GetRandomNumber() in the emulator. Sorry. \n");
        exit(0);
    }

    NumMsgs4To3        = 0;              /* Initialize Counters    */
    NumMsgsLost        = 0;
    NumMsgsCorrupt     = 0;
    NumSimultaneousMsgs = 0;

    CurrentSimTime = 0.0;                  /* initialize time to 0.0 */
    GenerateNextArrival();     /* initialize event list */
}                               /*  End of init()   */

/**************************************************************************
    GetMessageString
    Generate the message sent between application layers.  The string is
    based on the first (seed) character.
**************************************************************************/
#define   MSG_STRING   "!#$%&\'()*+,-.x0123456789:;<=>?ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~"
void   GetMessageString( int entity, int  SeqNum, char *ReturnString ) {
    int             i;
    int   NextChar = SeqNum % strlen( MSG_STRING );     // Bugfix 3/19/11
    int   Increment = SeqNum * ( entity + 1 ) + 1;
    if ( Increment == 0 ) Increment = 1;
    if ( Increment == strlen(MSG_STRING) ) Increment++;
    for ( i = 0 ; i < MESSAGE_LENGTH; i++ )  {
        ReturnString[i] = MSG_STRING[NextChar];
        NextChar += 17 * Increment;  
        NextChar = NextChar % strlen( MSG_STRING );
    }
    // Produce a sequence that MAY defeat the checksum
    if ( SeqNum % 7 == 0 )   {
        ReturnString[0] = 100;
        ReturnString[12] = 50;
    }
    if ( SeqNum % 9 == 0 )   {
        ReturnString[1] = 102;
        ReturnString[14] = 51;
    }
    // Now we embed the sequence number in the string
    SeqNum = SeqNum % strlen( MSG_STRING );
    ReturnString[SeqNum % MESSAGE_LENGTH ] = MSG_STRING[SeqNum];
    // printf( "GetMessageString %d   %d   %s\n", entity, SeqNum, ReturnString );    
}                             /* End of GetMessageString  */
/**************************************************************************
    GetRandomNumber()
        This is a method given by Jain.  It calculates

              X = ( 16807 * X ) % 2147483647.

        However this requires 48-bit arithmetic so the beauty of
        the method is that he reduces it to run on 32 bits (and
        thus is much faster).

    Returns a double between 0 and 1;
    August 2004:  Made thread safe.  Having a static here produced strange
                  results.  When multithreaded, we may return two of the
                  same random number to different threads.
**************************************************************************/

long static RandomSeed = 42;

void     SetRandomSeed( long NewRandomSeed )
{
    RandomSeed = NewRandomSeed;
}
double   GetRandomNumber( )
    {
    long                a = 16807;            /* Multiplier */
    long                m = 2147483647;       /* Modulus    */
    long                q = 127773;           /* m / a      */
    long                r = 2836;             /* m mod a    */
    long                X_div_q;
    long                X_mod_q;
    long                Working;

    Working = RandomSeed;
    if ( Working == 0 )
        Working = 1;
    X_div_q = Working / q;
    X_mod_q = Working % q;
    Working       = a * X_mod_q - r * X_div_q;
    if ( Working < 0 )
        Working = Working + m;
    RandomSeed = Working;
    return( ((double)Working)/(double)m  );
}                                /* End of GetRandomNumber             */

/**************************************************************************
             Get the current time of day.
             The NT version uses a method due to Jim Gray.
***************************************************************************/

void    GetTimeNow( double *time_returned )
{
#ifdef WINDOWS
    static short            first_time = TRUE;
    LARGE_INTEGER           ticks = {0,0};
    LARGE_INTEGER           ticks_per_second = {0,0}; 
    static  double          ticks_per_microsecond;

       
    if ( first_time == TRUE )
        {
        QueryPerformanceFrequency (&ticks_per_second);
        ticks_per_microsecond = (float) ticks_per_second.LowPart / 1E6;
        first_time = FALSE;
    }
    QueryPerformanceCounter (&ticks);
    *time_returned = ticks.LowPart/ticks_per_microsecond;
    *time_returned += ldexp(ticks.HighPart,32)/ticks_per_microsecond;
    *time_returned /= 1E6;

#endif
#ifdef LINUX

    struct timeval tp;

    gettimeofday (&tp, NULL);
    *time_returned = tp.tv_usec;
    *time_returned /= 1E6;
    *time_returned += tp.tv_sec;

#endif


}                               /* End of GetTimeNow              */

/****************************************************************************
*********************        EVENT HANDLING ROUTINES                  *******
  The next set of routines handles the event list.
  
    GenerateNextArrival  - Prepare an event for the queue that requests
                             a packet be sent from layer 5 to layer 4.
    InsertEvent            - Puts an event on the queue in time order.
    printevlist            - Prints out the event queue in order
****************************************************************************/
 
void GenerateNextArrival()
{
    double       x, log(), ceil();
    struct event *evptr;

    /* x is uniform on [0,2*AveTimeBetweenMsgs ] 
       having mean of AveTimeBetweenMsgs */
    x = AveTimeBetweenMsgs *GetRandomNumber()*2; 
    if ( TraceLevel >= 5)
        printf("\tGenerateNextArrival: Creating new arrival at %f from now\n",  x);

    evptr = (struct event *)malloc(sizeof(struct event));
    evptr->evtime =  CurrentSimTime + x;
    evptr->evtype =  FROM_LAYER5;
    if (Bidirectional && (GetRandomNumber()>0.5) )
        evptr->eventity = BEntity;
    else
        evptr->eventity = AEntity;
    InsertEvent(evptr);
} 


void InsertEvent(p)
    struct event *p;
{
    struct event *q,*qold;

    if ( TraceLevel >= 5) 
        printf("\tInsertEvent: Time now is %f.  Future event will be at %f\n", CurrentSimTime, p->evtime );
    
    q = evlist;     /* q points to header of list in which p struct inserted */
    if (q==NULL) {   /* list is empty */
        evlist=p;
        p->next=NULL;
        p->prev=NULL;
    }
    else   {
        /*  Find correct place in the list for new event */
        for (qold = q; q !=NULL && p->evtime > q->evtime; q=q->next)
              qold = q;   
        if (q==NULL) {          /* end of list */
             qold->next = p;
             p->prev = qold;
             p->next = NULL;
        }
        else if (q==evlist) {   /* front of list */
             p->next=evlist;
             p->prev=NULL;
             p->next->prev=p;
             evlist = p;
        }
        else {                  /* middle of list */
             p->next=q;
             p->prev=q->prev;
             q->prev->next=p;
             q->prev=p;
             }
         }
}                                    /* END OF InsertEvent */

void printevlist()
{
    struct event   *q;

    printf("--------------\nEvent List Follows:\n");
    for( q = evlist; q != NULL; q = q->next) {
        printf( "Event time: %f, type: %d entity: %d\n",
                        q->evtime, q->evtype, q->eventity);
    }
    printf("--------------\n");
}



/*****************************************************************************
 ************************** Student Callable Routines ************************
 ************************** Student Callable Routines ************************
******************************************************************************/

/*****************************************************************************
   stopTimer Called by student's routine to cancel a previously-started timer 
     input -- is A or B trying to stop timer 
******************************************************************************/
void stopTimer(int AorB) {
    struct event *q;

    if ( TraceLevel >= 5 )  {       /* Print out trace info if requested */
        if ( AorB == AEntity ) printf("A: " ); else printf("B: " );
        printf(" %f,", CurrentSimTime );
        printf("  stop timer\n");
    }
    /* for (q=evlist; q!=NULL && q->next!=NULL; q = q->next)  */
    for (q=evlist; q!=NULL ; q = q->next) 
        if ( (q->evtype==TIMER_INTERRUPT  && q->eventity==AorB) ) { 
       /* remove this event */
           if (q->next==NULL && q->prev==NULL)
               evlist=NULL;        // remove first and only event on list 
           else if (q->next==NULL) // end of list - there is one in front
               q->prev->next = NULL;
           else if (q==evlist) { // front of list - there must be event after
               q->next->prev=NULL;
               evlist = q->next;
           }
           else {     // middle of list 
               q->next->prev = q->prev;
               q->prev->next =  q->next;
           }
           free(q);
           return;
        }                          // END of if q->evtype  
    if ( TraceLevel >= 5 )         // Print out trace info if requested 
        printf("\tWarning: unable to cancel your timer. It wasn't running.\n");
}


/*****************************************************************************
     getTimerStatus - determines the current state of the timer for A or B
         Returns TRUE if timer currently is running
         Returns FALSE if timer currently is not running
******************************************************************************/
int    getTimerStatus( int AorB ) {
    struct event *q;

    for (q = evlist; q != NULL ; q = q->next) {
        if ( (q->evtype==TIMER_INTERRUPT  && q->eventity==AorB) ) 
            return( TRUE );            // Event of this type found
    }
    // We got thru the entire list and found nothing - return FALSE
    return( FALSE );
}       // End getTimerStatus

/*****************************************************************************
     startTimer - Start a timer on behalf of an entity
         Inputs: Is the calling entity A or B? 
             Time in the future for which we want to start timer

         Returns TRUE if timer currently is running
         Returns FALSE if timer currently is not running
******************************************************************************/
void    startTimer( int AorB, double increment )   {

    struct event *q;
    struct event *evptr;

    // Print out trace info if requested
    if ( TraceLevel >= 5 )  {       
        if ( AorB == AEntity ) printf("A: " ); else printf("B: " );
        printf(" %11.4f,", CurrentSimTime );
        printf(" start timer\n");
    }
    // be nice: check to see if timer is already started, if so, then  warn 
    for (q=evlist; q!=NULL ; q = q->next)   {
        if ( (q->evtype==TIMER_INTERRUPT  && q->eventity==AorB) ) { 
            if ( TraceLevel >= 5 )      // Print out trace info if requested */
                printf("Error in startTimer - the timer is already started\n");
            return;
        }
    }
 
    // create future event for when timer goes off 
    evptr = (struct event *)malloc(sizeof(struct event));
    evptr->evtime   =  CurrentSimTime + increment;
    evptr->evtype   =  TIMER_INTERRUPT;
    evptr->eventity =  AorB;
    InsertEvent(evptr);
}              // End of startTimer
/* ***************************************************************************
   getClockTime - returns the current simulation time
*****************************************************************************/
double  getClockTime( ) {
    return( CurrentSimTime );
}
/* ***************************************************************************
   countMessagesFromThisEntity
   We want to know how many messages are already heading for the other side
   due to this entity.  It allows us to determine how well the student is
   doing go back N or stop-and-wait.
*****************************************************************************/
int   countMessagesFromThisEntity ( int AorB ) {
    int count = 0;
    struct event *q;
    for (q = evlist; q!=NULL ; q = q->next)   {
        if ( (q->evtype == FROM_LAYER3  && q->eventity == AorB ) ) 
            count++;
    }
    return count;
}
/* ***************************************************************************
   printEntireEventQueue
   Print everything that's on the event simulation Q.  It lets us examine
   what the student is doing in their code.
*****************************************************************************/
void   printEntireEventQ ( ) {
    struct event *q;
    int           i;
    printf("\nPrinting the contents of the Simulation Event Q\n");
    
    for (q = evlist; q != NULL ; q = q->next)   { 
        printf("Event Time = %8.3f ", q->evtime );
        if ( q->eventity == AEntity )   printf("A: " ); else printf("B: " );
        if ( q->evtype == 0 ) printf("Timer    ");
        if ( q->evtype == 1 ) printf("LAYER 5  ");
        if ( q->evtype == 2 ) printf("LAYER 3  ");
	if ( q->evtype == 2 )  {
            printf( "Seq/Ack/Check = %d/%d/%d:  ", q->pktptr->seqnum,
                    q->pktptr->acknum,  (unsigned int)(q->pktptr->checksum) );
            for ( i = 0; i < MESSAGE_LENGTH; i++) 
                printf("%c", q->pktptr->payload[i]);
	}
        printf("\n");
    }
    printf("\n");
}               // End of printEntireEventQ

/* ***************************************************************************
           ******************************* TOLAYER3 ********************
   The student in layer 4 sends a packet here.  And we do
   magical things to it and eventually send it back to layer 4
   on the other side.
*****************************************************************************/
void tolayer3( int AorB, struct pkt packet ) {
    struct pkt   *mypktptr;
    struct event *evptr, *q;
    double       LastTime;
    char         WhichSide[10];
    int          i;
    int          FirstCharPos, SecondCharPos;
    char         Temp, *CharPtr;
    int          NumberOfCorruptionTries;


    NumMsgs4To3++;          // Record of packets getting to layer 3 
    // Count how many packets are going to the other guy.
    NumSimultaneousMsgs += countMessagesFromThisEntity ( (AorB + 1) % 2 );
    // printf( "TEMP: %d  %d  %d\n", AorB,  NumMsgs4To3, NumSimultaneousMsgs );


    // Make a copy of the packet the student just gave me since he/she 
    // may decide to do something with the packet after we return back 
    // to him/her 
    mypktptr = (struct pkt *)malloc(sizeof(struct pkt));
    mypktptr->seqnum = packet.seqnum;
    mypktptr->acknum = packet.acknum;
    mypktptr->checksum = packet.checksum;
    for (i=0; i<MESSAGE_LENGTH; i++)
        mypktptr->payload[i] = packet.payload[i];

    if ( TraceLevel >= 5 )  {     // Print out trace info if requested 
        if ( AorB == AEntity )   printf("A: " ); else printf("B: " );
        printf(" %11.4f,", CurrentSimTime );

        printf("  Layer 4 to 3  ");
        printf( "Seq/Ack/Check = %d/%d/%d:  ", mypktptr->seqnum,
                mypktptr->acknum,  (unsigned int)(mypktptr->checksum) );
        for (i=0; i<MESSAGE_LENGTH; i++) 
            printf("%c", mypktptr->payload[i]);
        printf("\n");
    }

    //Simulate losses.  We do this simply by not saving the packet 
    if ( GetRandomNumber() < LossProb )  {
        NumMsgsLost++;          //  Count number of lost packets  
        if ( TraceLevel > 5 )    {
            if ( AorB == AEntity )
                printf("\t<Packet from A: Layer 4 to 3 is being lost>\n" );
            else
                printf("\t<Packet from B: Layer 4 to 3 is being lost>\n" );
        }
        free(mypktptr);
        return;
    }  

    // Create future event for arrival of this packet at the other side 
    evptr = (struct event *)malloc(sizeof(struct event));
    evptr->evtype   =  FROM_LAYER3;   // packet will pop out from layer3 
    evptr->eventity = (AorB+1) % 2;   // event occurs at other entity 
    evptr->pktptr   = mypktptr;       // save ptr to my copy of packet 

    /**********************************
      Finally, compute the arrival time of packet at the other end.
      Medium may or may not reorder: 
      1.  If NOT reordering, make sure packet arrives between 1 and 10
          time units after the latest arrival time of packets
          currently in the medium on their way to the destination 
      2.  If we ARE reordering, simply calculate a time and put it on the Q.
          This may or may not actually produce an out-of-order event
     *********************************/

    LastTime = CurrentSimTime;
    for (q=evlist; q!=NULL ; q = q->next) 
        if ( (q->evtype==FROM_LAYER3  && q->eventity==evptr->eventity) ) 
            LastTime = q->evtime;

    if ( GetRandomNumber() < OutOfOrderProb ) {  /* Is it out of order?  */
        if ( LastTime == CurrentSimTime )         // Nothing ahead - simply calculate
            evptr->evtime =  CurrentSimTime + 1 
            + ( TIME_TO_GET_TO_OTHER_SIDE ) * GetRandomNumber();
        else
            evptr->evtime =  CurrentSimTime + 1   // Put it before the last item on Q
            + ( LastTime - CurrentSimTime ) * GetRandomNumber();
        if ( TraceLevel > 5 )    {
            strcpy( WhichSide, "B" );
            if ( AorB == AEntity ) strcpy( WhichSide, "A" );
            printf("\t<Packet from %s: Layer 4 to 3: Last / This Pkt Time = %f / %f\n",
                          WhichSide, LastTime, evptr->evtime );
        }
        NumMsgsOutOfOrder++;                     // Number messages MAYBE out of order 
    }
    else                                        /* It's NOT out of order  */
        evptr->evtime =  LastTime + 1 + 
           3 * TIME_TO_GET_TO_OTHER_SIDE * GetRandomNumber();

    /* *************************************************************************
       Simulate corruption: 
       We do this by picking randomly two positions in the packet.  We ensure 
       that those two positions contain unique/different characters.  We then
       swap the characters.
    ************************************************************************* */
    if ( GetRandomNumber() < CorruptProb)  {
        NumMsgsCorrupt++;
        CharPtr = (char *)mypktptr;
        FirstCharPos  = SecondCharPos  = 0;
        if ( CharPtr[12] == 100 && CharPtr[24] == 50 ) {
            CharPtr[12] = 98;
            CharPtr[24] = 51;
        } 
        NumberOfCorruptionTries = 0;     // Guard against all chars being same
        while( ( CharPtr[FirstCharPos]  == CharPtr[SecondCharPos] )
            && ( NumberOfCorruptionTries < 100 ) )    
        {
            FirstCharPos  = (int)(sizeof( struct pkt ) * GetRandomNumber());
            SecondCharPos = (int)(sizeof( struct pkt ) * GetRandomNumber());
            NumberOfCorruptionTries++;
        }
        Temp                   = CharPtr[FirstCharPos];
        CharPtr[FirstCharPos]  = CharPtr[SecondCharPos];
        CharPtr[SecondCharPos] = Temp;
        if ( TraceLevel >= 5 )    {
            if ( AorB == AEntity )
                printf("A:\tPacket from Layer 4 to 3 is being corrupted\n" );
            else
                printf("B:\tPacket from Layer 4 to 3 is being corrupted\n" );
        }
    }         // End of if GetRandomNumber

    if ( TraceLevel >= 5)  
        printf("\tToLayer3: scheduling arrival on other side\n");
    InsertEvent( evptr );
} 

/* ***************************************************************************
   tolayer5()
    Layer 4 has sent data up to layer 5 on the receive side.
    Make sure the data is OK        
*****************************************************************************/

void tolayer5( int AorB, struct msg message) {
    int          i, j;  
    static int   CurrentNSim = 0;
    char         ExpectedString[50];

    /* Print out trace info every time - this is how we can see success. */
    if ( TraceLevel >= 0 )  {     
        if ( AorB == AEntity )   printf("A: " ); else printf("B: " );
        printf(" %11.4f,", CurrentSimTime );
        printf("  Layer 4 to 5  Message = ");
        for (i=0; i < MESSAGE_LENGTH; i++)  
            printf("%c", message.data[i]);
        printf("\n");
    }
    // We REALLY shouldn't increment the next expected sequence number, BUT
    // The transport layer maybe screwed up and future packets MAY be right.
    j = ExpectedSeqNum[AorB]++;
    // Note that we're asking for the string that was generated on behalf
    // of the other entity.
    GetMessageString( (AorB + 1) % 2, j, ExpectedString ); 
    if ( strncmp( ExpectedString, &(message.data[0]), MESSAGE_LENGTH ) != 0 ) {
        printf( "\t\tTOLAYER5:  PANIC!!  Data Received in this packet are wrong\n");
        NumMsgs5To4WithErr++;   // number of messages incorrectly received
    }
    CurrentNSim++;
    NumMsgs4To5++;
}

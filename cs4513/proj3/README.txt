This is the P2P Streaming Movie System project.

Language: English
System Dependencies: Runs on the CCC systems.

To compile, run the "make" command.

One executable is generated. To run, "./mcast".

The movies included are from the course website:
-clerks
-pong
-starwars
-tiger
-walk

These movies have to be registered in the ".nutella" file. The .nutella config
file must be in the same directory as the movie text files. The config file is
included in the submission.

When the streaming player is running, enter the movie name - without ".txt" extension -
to stream. For example:

tnarayan@CCCWORK4 proj3] $ ./mcast
Type in the movie you would like to see:
starwars
Found, playing movie...
=====================


     STAR WARS!



(and the stream continues...it is truncated for the purposes of this README).

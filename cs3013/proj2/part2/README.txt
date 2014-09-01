Project 2
Cynthia Rogers - cerogers@wpi.edu
Tushar Narayan - tnarayan@wpi.edu
README file

Brief overview of tests used:
-The tests we used included forking for a first child and then forking 
for a second child subsequently. We put the children to sleep to be able
to check that the siblings were represented correctly in the statistics.
Throughout this, we also periodically printed the parent information to
check the related child information.
-The information from the getprocessinfo system call changed from run to run
depending on the parent pid the system assigned, the runtimes related to the 
child processes, and if some other processes were running in the shell
background.
-These statistics change based on the run environment. The frequency
associated with the change is about on every other run.

Sample output from the user-space processinfo.c is included below:
Note that the processinfo.c program invokes the systemcall more than once.
-----

student@linux-zudt:~> ./processinfo 

The return code from the getprocessinfo system call is 0


Original parent process before wait

Members:
state = 0
pid = 5306
parent_pid = 3865
youngest_child = 0
younger_sibling = 0
older_sibling = 0
uid = 1000
comm = processinfo
start_time = 776630892898
user_time = 0
sys_time = 10000
cutime = 1639680640
cstime = 0

Second fork:

Members:
state = 0
pid = 5306
parent_pid = 3865
youngest_child = 0
younger_sibling = 0
older_sibling = 0
uid = 1000
comm = processinfo
start_time = 776630892898
user_time = 0
sys_time = 10000
cutime = 1639680640
cstime = 0


Second child info

Members:


First child info

Members:
state = 0
pid = 5308
parent_pid = 5306
youngest_child = 0
younger_sibling = 0
older_sibling = 0
uid = 1000
comm = processinfo
start_time = 776640151609
user_time = 0
sys_time = 0
cutime = 551258752
cstime = 551258752


Original parent process after wait
state = 0

Members:
pid = 5307
state = 0
parent_pid = 5306
pid = 5308
youngest_child = 0
parent_pid = 5306
younger_sibling = 0
youngest_child = 0
older_sibling = 0
younger_sibling = 0
uid = 1000
older_sibling = 0
comm = processinfo
uid = 1000
start_time = 776638834447
comm = processinfo
user_time = 0
start_time = 776640151609
sys_time = 10000
user_time = 0
cutime = 551258752
sys_time = 0
cstime = 551258752
cutime = 551258752


cstime = 551258752
Original parent process


Original parent process

Members:

state = 0
Members:
pid = 5307
state = 0
parent_pid = 5306
pid = 5308
youngest_child = 0
parent_pid = 5306
younger_sibling = 0
youngest_child = 0
older_sibling = 0
younger_sibling = 0
uid = 1000
older_sibling = 0
comm = processinfo
uid = 1000
start_time = 776638834447
comm = processinfo
user_time = 0
start_time = 776640151609
sys_time = 10000
user_time = 0
cutime = 551258752
sys_time = 0
cstime = 551258752
cutime = 551258752
cstime = 551258752


Parent process after second fork

Members:
state = 0
pid = 5306
parent_pid = 3865
youngest_child = 0
younger_sibling = 0
older_sibling = 0
uid = 1000
comm = processinfo
start_time = 776630892898
user_time = 0
sys_time = 10000
cutime = 1639680640
cstime = 0


Original parent process after wait

Members:
state = 0
pid = 5306
parent_pid = 3865
youngest_child = 0
younger_sibling = 0
older_sibling = 0
uid = 1000
comm = processinfo
start_time = 776630892898
user_time = 0
sys_time = 10000
cutime = 1639680640
cstime = 0


Original parent process

Members:
state = 0
pid = 5306
parent_pid = 3865
youngest_child = 0
younger_sibling = 0
older_sibling = 0
uid = 1000
comm = processinfo
start_time = 776630892898
user_time = 0
sys_time = 10000
cutime = 1639680640
cstime = 0
student@linux-zudt:~> 

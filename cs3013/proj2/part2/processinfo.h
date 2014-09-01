#ifndef USER_SPACE_PRINFO_H
#define USER_SPACE_PRINFO_H

#include <unistd.h>
#include <sys/types.h>

struct prinfo {
    long state;			// current state of process
    pid_t pid;			// process ID of this process
    pid_t parent_pid;		// process ID of parent
    pid_t youngest_child;	// process ID of youngest child
    pid_t younger_sibling;	// process ID of next younger sibling
    pid_t older_sibling;		// process ID of next older sibling
    uid_t uid;			// user ID of process owner
    char comm[16];		// name of program executed
    long long start_time;	// process start time in nanosecond since boot time
    long long user_time;	// CPU time spent in user mode (microseconds)
    long long sys_time;	// CPU time spend in system mode (microseconds)
    long long cutime;	// total user time of children (microseconds)
    long long cstime;	// total system time of children (microseconds)
};	// struct prinfo


long getprocessinfo(struct prinfo *info);

#endif

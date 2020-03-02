# 1 "bfac.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 314 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "bfac.c" 2
# 24 "bfac.c"
# 1 "/usr/include/pthread.h" 1 3 4
# 21 "/usr/include/pthread.h" 3 4
# 1 "/usr/include/features.h" 1 3 4
# 342 "/usr/include/features.h" 3 4
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 343 "/usr/include/features.h" 2 3 4
# 364 "/usr/include/features.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/sys/cdefs.h" 1 3 4
# 402 "/usr/include/x86_64-linux-gnu/sys/cdefs.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/wordsize.h" 1 3 4
# 403 "/usr/include/x86_64-linux-gnu/sys/cdefs.h" 2 3 4
# 365 "/usr/include/features.h" 2 3 4
# 388 "/usr/include/features.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/gnu/stubs.h" 1 3 4
# 10 "/usr/include/x86_64-linux-gnu/gnu/stubs.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/gnu/stubs-64.h" 1 3 4
# 11 "/usr/include/x86_64-linux-gnu/gnu/stubs.h" 2 3 4
# 389 "/usr/include/features.h" 2 3 4
# 22 "/usr/include/pthread.h" 2 3 4
# 1 "/usr/include/endian.h" 1 3 4
# 36 "/usr/include/endian.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/endian.h" 1 3 4
# 37 "/usr/include/endian.h" 2 3 4
# 23 "/usr/include/pthread.h" 2 3 4
# 1 "/usr/include/sched.h" 1 3 4
# 25 "/usr/include/sched.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/types.h" 1 3 4
# 27 "/usr/include/x86_64-linux-gnu/bits/types.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/wordsize.h" 1 3 4
# 28 "/usr/include/x86_64-linux-gnu/bits/types.h" 2 3 4


typedef unsigned char __u_char;
typedef unsigned short int __u_short;
typedef unsigned int __u_int;
typedef unsigned long int __u_long;


typedef signed char __int8_t;
typedef unsigned char __uint8_t;
typedef signed short int __int16_t;
typedef unsigned short int __uint16_t;
typedef signed int __int32_t;
typedef unsigned int __uint32_t;

typedef signed long int __int64_t;
typedef unsigned long int __uint64_t;







typedef long int __quad_t;
typedef unsigned long int __u_quad_t;
# 121 "/usr/include/x86_64-linux-gnu/bits/types.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/typesizes.h" 1 3 4
# 122 "/usr/include/x86_64-linux-gnu/bits/types.h" 2 3 4


typedef unsigned long int __dev_t;
typedef unsigned int __uid_t;
typedef unsigned int __gid_t;
typedef unsigned long int __ino_t;
typedef unsigned long int __ino64_t;
typedef unsigned int __mode_t;
typedef unsigned long int __nlink_t;
typedef long int __off_t;
typedef long int __off64_t;
typedef int __pid_t;
typedef struct { int __val[2]; } __fsid_t;
typedef long int __clock_t;
typedef unsigned long int __rlim_t;
typedef unsigned long int __rlim64_t;
typedef unsigned int __id_t;
typedef long int __time_t;
typedef unsigned int __useconds_t;
typedef long int __suseconds_t;

typedef int __daddr_t;
typedef int __key_t;


typedef int __clockid_t;


typedef void * __timer_t;


typedef long int __blksize_t;




typedef long int __blkcnt_t;
typedef long int __blkcnt64_t;


typedef unsigned long int __fsblkcnt_t;
typedef unsigned long int __fsblkcnt64_t;


typedef unsigned long int __fsfilcnt_t;
typedef unsigned long int __fsfilcnt64_t;


typedef long int __fsword_t;

typedef long int __ssize_t;


typedef long int __syscall_slong_t;

typedef unsigned long int __syscall_ulong_t;



typedef __off64_t __loff_t;
typedef __quad_t *__qaddr_t;
typedef char *__caddr_t;


typedef long int __intptr_t;


typedef unsigned int __socklen_t;
# 26 "/usr/include/sched.h" 2 3 4


# 1 "/home/tao/tools/llvm.optO2/bin/../lib/clang/3.7.0/include/stddef.h" 1 3 4
# 62 "/home/tao/tools/llvm.optO2/bin/../lib/clang/3.7.0/include/stddef.h" 3 4
typedef long unsigned int size_t;
# 29 "/usr/include/sched.h" 2 3 4





# 1 "/usr/include/time.h" 1 3 4
# 37 "/usr/include/time.h" 3 4
# 1 "/home/tao/tools/llvm.optO2/bin/../lib/clang/3.7.0/include/stddef.h" 1 3 4
# 38 "/usr/include/time.h" 2 3 4



# 1 "/usr/include/x86_64-linux-gnu/bits/time.h" 1 3 4
# 42 "/usr/include/time.h" 2 3 4
# 59 "/usr/include/time.h" 3 4
typedef __clock_t clock_t;
# 75 "/usr/include/time.h" 3 4
typedef __time_t time_t;
# 133 "/usr/include/time.h" 3 4
struct tm
{
  int tm_sec;
  int tm_min;
  int tm_hour;
  int tm_mday;
  int tm_mon;
  int tm_year;
  int tm_wday;
  int tm_yday;
  int tm_isdst;





  long int __tm_gmtoff;
  const char *__tm_zone;

};
# 189 "/usr/include/time.h" 3 4
extern clock_t clock (void) __attribute__ ((__nothrow__ ));


extern time_t time (time_t *__timer) __attribute__ ((__nothrow__ ));


extern double difftime (time_t __time1, time_t __time0)
     __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern time_t mktime (struct tm *__tp) __attribute__ ((__nothrow__ ));





extern size_t strftime (char *__restrict __s, size_t __maxsize,
   const char *__restrict __format,
   const struct tm *__restrict __tp) __attribute__ ((__nothrow__ ));
# 239 "/usr/include/time.h" 3 4
extern struct tm *gmtime (const time_t *__timer) __attribute__ ((__nothrow__ ));



extern struct tm *localtime (const time_t *__timer) __attribute__ ((__nothrow__ ));
# 261 "/usr/include/time.h" 3 4
extern char *asctime (const struct tm *__tp) __attribute__ ((__nothrow__ ));


extern char *ctime (const time_t *__timer) __attribute__ ((__nothrow__ ));
# 282 "/usr/include/time.h" 3 4
extern char *__tzname[2];
extern int __daylight;
extern long int __timezone;
# 35 "/usr/include/sched.h" 2 3 4


typedef __pid_t pid_t;






# 1 "/usr/include/x86_64-linux-gnu/bits/sched.h" 1 3 4
# 72 "/usr/include/x86_64-linux-gnu/bits/sched.h" 3 4
struct sched_param
  {
    int __sched_priority;
  };
# 103 "/usr/include/x86_64-linux-gnu/bits/sched.h" 3 4
struct __sched_param
  {
    int __sched_priority;
  };
# 118 "/usr/include/x86_64-linux-gnu/bits/sched.h" 3 4
typedef unsigned long int __cpu_mask;






typedef struct
{
  __cpu_mask __bits[1024 / (8 * sizeof (__cpu_mask))];
} cpu_set_t;
# 203 "/usr/include/x86_64-linux-gnu/bits/sched.h" 3 4
extern int __sched_cpucount (size_t __setsize, const cpu_set_t *__setp)
  __attribute__ ((__nothrow__ ));
extern cpu_set_t *__sched_cpualloc (size_t __count) __attribute__ ((__nothrow__ )) ;
extern void __sched_cpufree (cpu_set_t *__set) __attribute__ ((__nothrow__ ));
# 44 "/usr/include/sched.h" 2 3 4







extern int sched_setparam (__pid_t __pid, const struct sched_param *__param)
     __attribute__ ((__nothrow__ ));


extern int sched_getparam (__pid_t __pid, struct sched_param *__param) __attribute__ ((__nothrow__ ));


extern int sched_setscheduler (__pid_t __pid, int __policy,
          const struct sched_param *__param) __attribute__ ((__nothrow__ ));


extern int sched_getscheduler (__pid_t __pid) __attribute__ ((__nothrow__ ));


extern int sched_yield (void) __attribute__ ((__nothrow__ ));


extern int sched_get_priority_max (int __algorithm) __attribute__ ((__nothrow__ ));


extern int sched_get_priority_min (int __algorithm) __attribute__ ((__nothrow__ ));


extern int sched_rr_get_interval (__pid_t __pid, struct timespec *__t) __attribute__ ((__nothrow__ ));
# 24 "/usr/include/pthread.h" 2 3 4


# 1 "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h" 1 3 4
# 21 "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/wordsize.h" 1 3 4
# 22 "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h" 2 3 4
# 60 "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h" 3 4
typedef unsigned long int pthread_t;


union pthread_attr_t
{
  char __size[56];
  long int __align;
};

typedef union pthread_attr_t pthread_attr_t;





typedef struct __pthread_internal_list
{
  struct __pthread_internal_list *__prev;
  struct __pthread_internal_list *__next;
} __pthread_list_t;
# 90 "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h" 3 4
typedef union
{
  struct __pthread_mutex_s
  {
    int __lock;
    unsigned int __count;
    int __owner;

    unsigned int __nusers;



    int __kind;

    short __spins;
    short __elision;
    __pthread_list_t __list;
# 125 "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h" 3 4
  } __data;
  char __size[40];
  long int __align;
} pthread_mutex_t;

typedef union
{
  char __size[4];
  int __align;
} pthread_mutexattr_t;




typedef union
{
  struct
  {
    int __lock;
    unsigned int __futex;
    __extension__ unsigned long long int __total_seq;
    __extension__ unsigned long long int __wakeup_seq;
    __extension__ unsigned long long int __woken_seq;
    void *__mutex;
    unsigned int __nwaiters;
    unsigned int __broadcast_seq;
  } __data;
  char __size[48];
  __extension__ long long int __align;
} pthread_cond_t;

typedef union
{
  char __size[4];
  int __align;
} pthread_condattr_t;



typedef unsigned int pthread_key_t;



typedef int pthread_once_t;
# 27 "/usr/include/pthread.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/setjmp.h" 1 3 4
# 26 "/usr/include/x86_64-linux-gnu/bits/setjmp.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/wordsize.h" 1 3 4
# 27 "/usr/include/x86_64-linux-gnu/bits/setjmp.h" 2 3 4




typedef long int __jmp_buf[8];
# 28 "/usr/include/pthread.h" 2 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/wordsize.h" 1 3 4
# 29 "/usr/include/pthread.h" 2 3 4



enum
{
  PTHREAD_CREATE_JOINABLE,

  PTHREAD_CREATE_DETACHED

};



enum
{
  PTHREAD_MUTEX_TIMED_NP,
  PTHREAD_MUTEX_RECURSIVE_NP,
  PTHREAD_MUTEX_ERRORCHECK_NP,
  PTHREAD_MUTEX_ADAPTIVE_NP
# 59 "/usr/include/pthread.h" 3 4
};
# 157 "/usr/include/pthread.h" 3 4
enum
{
  PTHREAD_INHERIT_SCHED,

  PTHREAD_EXPLICIT_SCHED

};



enum
{
  PTHREAD_SCOPE_SYSTEM,

  PTHREAD_SCOPE_PROCESS

};



enum
{
  PTHREAD_PROCESS_PRIVATE,

  PTHREAD_PROCESS_SHARED

};
# 192 "/usr/include/pthread.h" 3 4
struct _pthread_cleanup_buffer
{
  void (*__routine) (void *);
  void *__arg;
  int __canceltype;
  struct _pthread_cleanup_buffer *__prev;
};


enum
{
  PTHREAD_CANCEL_ENABLE,

  PTHREAD_CANCEL_DISABLE

};
enum
{
  PTHREAD_CANCEL_DEFERRED,

  PTHREAD_CANCEL_ASYNCHRONOUS

};
# 235 "/usr/include/pthread.h" 3 4
extern int pthread_create (pthread_t *__restrict __newthread,
      const pthread_attr_t *__restrict __attr,
      void *(*__start_routine) (void *),
      void *__restrict __arg) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 3)));





extern void pthread_exit (void *__retval) __attribute__ ((__noreturn__));







extern int pthread_join (pthread_t __th, void **__thread_return);
# 273 "/usr/include/pthread.h" 3 4
extern int pthread_detach (pthread_t __th) __attribute__ ((__nothrow__ ));



extern pthread_t pthread_self (void) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern int pthread_equal (pthread_t __thread1, pthread_t __thread2)
  __attribute__ ((__nothrow__ )) __attribute__ ((__const__));







extern int pthread_attr_init (pthread_attr_t *__attr) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


extern int pthread_attr_destroy (pthread_attr_t *__attr)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


extern int pthread_attr_getdetachstate (const pthread_attr_t *__attr,
     int *__detachstate)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));


extern int pthread_attr_setdetachstate (pthread_attr_t *__attr,
     int __detachstate)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));



extern int pthread_attr_getguardsize (const pthread_attr_t *__attr,
          size_t *__guardsize)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));


extern int pthread_attr_setguardsize (pthread_attr_t *__attr,
          size_t __guardsize)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));



extern int pthread_attr_getschedparam (const pthread_attr_t *__restrict __attr,
           struct sched_param *__restrict __param)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));


extern int pthread_attr_setschedparam (pthread_attr_t *__restrict __attr,
           const struct sched_param *__restrict
           __param) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));


extern int pthread_attr_getschedpolicy (const pthread_attr_t *__restrict
     __attr, int *__restrict __policy)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));


extern int pthread_attr_setschedpolicy (pthread_attr_t *__attr, int __policy)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


extern int pthread_attr_getinheritsched (const pthread_attr_t *__restrict
      __attr, int *__restrict __inherit)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));


extern int pthread_attr_setinheritsched (pthread_attr_t *__attr,
      int __inherit)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));



extern int pthread_attr_getscope (const pthread_attr_t *__restrict __attr,
      int *__restrict __scope)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));


extern int pthread_attr_setscope (pthread_attr_t *__attr, int __scope)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


extern int pthread_attr_getstackaddr (const pthread_attr_t *__restrict
          __attr, void **__restrict __stackaddr)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2))) __attribute__ ((__deprecated__));





extern int pthread_attr_setstackaddr (pthread_attr_t *__attr,
          void *__stackaddr)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1))) __attribute__ ((__deprecated__));


extern int pthread_attr_getstacksize (const pthread_attr_t *__restrict
          __attr, size_t *__restrict __stacksize)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));




extern int pthread_attr_setstacksize (pthread_attr_t *__attr,
          size_t __stacksize)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));
# 431 "/usr/include/pthread.h" 3 4
extern int pthread_setschedparam (pthread_t __target_thread, int __policy,
      const struct sched_param *__param)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (3)));


extern int pthread_getschedparam (pthread_t __target_thread,
      int *__restrict __policy,
      struct sched_param *__restrict __param)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (2, 3)));


extern int pthread_setschedprio (pthread_t __target_thread, int __prio)
     __attribute__ ((__nothrow__ ));
# 496 "/usr/include/pthread.h" 3 4
extern int pthread_once (pthread_once_t *__once_control,
    void (*__init_routine) (void)) __attribute__ ((__nonnull__ (1, 2)));
# 508 "/usr/include/pthread.h" 3 4
extern int pthread_setcancelstate (int __state, int *__oldstate);



extern int pthread_setcanceltype (int __type, int *__oldtype);


extern int pthread_cancel (pthread_t __th);




extern void pthread_testcancel (void);




typedef struct
{
  struct
  {
    __jmp_buf __cancel_jmp_buf;
    int __mask_was_saved;
  } __cancel_jmp_buf[1];
  void *__pad[4];
} __pthread_unwind_buf_t __attribute__ ((__aligned__));
# 542 "/usr/include/pthread.h" 3 4
struct __pthread_cleanup_frame
{
  void (*__cancel_routine) (void *);
  void *__cancel_arg;
  int __do_it;
  int __cancel_type;
};
# 682 "/usr/include/pthread.h" 3 4
extern void __pthread_register_cancel (__pthread_unwind_buf_t *__buf)
                            ;
# 694 "/usr/include/pthread.h" 3 4
extern void __pthread_unregister_cancel (__pthread_unwind_buf_t *__buf)
                         ;
# 735 "/usr/include/pthread.h" 3 4
extern void __pthread_unwind_next (__pthread_unwind_buf_t *__buf)
                             __attribute__ ((__noreturn__))

     __attribute__ ((__weak__))

     ;



struct __jmp_buf_tag;
extern int __sigsetjmp (struct __jmp_buf_tag *__env, int __savemask) __attribute__ ((__nothrow__));





extern int pthread_mutex_init (pthread_mutex_t *__mutex,
          const pthread_mutexattr_t *__mutexattr)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


extern int pthread_mutex_destroy (pthread_mutex_t *__mutex)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


extern int pthread_mutex_trylock (pthread_mutex_t *__mutex)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));


extern int pthread_mutex_lock (pthread_mutex_t *__mutex)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
# 775 "/usr/include/pthread.h" 3 4
extern int pthread_mutex_unlock (pthread_mutex_t *__mutex)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));



extern int pthread_mutex_getprioceiling (const pthread_mutex_t *
      __restrict __mutex,
      int *__restrict __prioceiling)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));



extern int pthread_mutex_setprioceiling (pthread_mutex_t *__restrict __mutex,
      int __prioceiling,
      int *__restrict __old_ceiling)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 3)));
# 808 "/usr/include/pthread.h" 3 4
extern int pthread_mutexattr_init (pthread_mutexattr_t *__attr)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


extern int pthread_mutexattr_destroy (pthread_mutexattr_t *__attr)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


extern int pthread_mutexattr_getpshared (const pthread_mutexattr_t *
      __restrict __attr,
      int *__restrict __pshared)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));


extern int pthread_mutexattr_setpshared (pthread_mutexattr_t *__attr,
      int __pshared)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));
# 840 "/usr/include/pthread.h" 3 4
extern int pthread_mutexattr_getprotocol (const pthread_mutexattr_t *
       __restrict __attr,
       int *__restrict __protocol)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));



extern int pthread_mutexattr_setprotocol (pthread_mutexattr_t *__attr,
       int __protocol)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


extern int pthread_mutexattr_getprioceiling (const pthread_mutexattr_t *
          __restrict __attr,
          int *__restrict __prioceiling)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));


extern int pthread_mutexattr_setprioceiling (pthread_mutexattr_t *__attr,
          int __prioceiling)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));
# 970 "/usr/include/pthread.h" 3 4
extern int pthread_cond_init (pthread_cond_t *__restrict __cond,
         const pthread_condattr_t *__restrict __cond_attr)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


extern int pthread_cond_destroy (pthread_cond_t *__cond)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


extern int pthread_cond_signal (pthread_cond_t *__cond)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));


extern int pthread_cond_broadcast (pthread_cond_t *__cond)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));






extern int pthread_cond_wait (pthread_cond_t *__restrict __cond,
         pthread_mutex_t *__restrict __mutex)
     __attribute__ ((__nonnull__ (1, 2)));
# 1002 "/usr/include/pthread.h" 3 4
extern int pthread_cond_timedwait (pthread_cond_t *__restrict __cond,
       pthread_mutex_t *__restrict __mutex,
       const struct timespec *__restrict __abstime)
     __attribute__ ((__nonnull__ (1, 2, 3)));




extern int pthread_condattr_init (pthread_condattr_t *__attr)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


extern int pthread_condattr_destroy (pthread_condattr_t *__attr)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


extern int pthread_condattr_getpshared (const pthread_condattr_t *
     __restrict __attr,
     int *__restrict __pshared)
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1, 2)));


extern int pthread_condattr_setpshared (pthread_condattr_t *__attr,
     int __pshared) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));
# 1113 "/usr/include/pthread.h" 3 4
extern int pthread_key_create (pthread_key_t *__key,
          void (*__destr_function) (void *))
     __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (1)));


extern int pthread_key_delete (pthread_key_t __key) __attribute__ ((__nothrow__ ));


extern void *pthread_getspecific (pthread_key_t __key) __attribute__ ((__nothrow__ ));


extern int pthread_setspecific (pthread_key_t __key,
    const void *__pointer) __attribute__ ((__nothrow__ )) ;
# 1147 "/usr/include/pthread.h" 3 4
extern int pthread_atfork (void (*__prepare) (void),
      void (*__parent) (void),
      void (*__child) (void)) __attribute__ ((__nothrow__ ));
# 24 "bfac.c" 2

//#include "libittnotify.h"


 typedef struct {
  volatile int gsense;
  volatile long count;
} barrier_t;




# 1 "./matrix.h" 1
# 23 "./matrix.h"
# 1 "/usr/include/stdio.h" 1 3 4
# 33 "/usr/include/stdio.h" 3 4
# 1 "/home/tao/tools/llvm.optO2/bin/../lib/clang/3.7.0/include/stddef.h" 1 3 4
# 34 "/usr/include/stdio.h" 2 3 4
# 44 "/usr/include/stdio.h" 3 4
struct _IO_FILE;



typedef struct _IO_FILE FILE;
# 64 "/usr/include/stdio.h" 3 4
typedef struct _IO_FILE __FILE;
# 74 "/usr/include/stdio.h" 3 4
# 1 "/usr/include/libio.h" 1 3 4
# 31 "/usr/include/libio.h" 3 4
# 1 "/usr/include/_G_config.h" 1 3 4
# 15 "/usr/include/_G_config.h" 3 4
# 1 "/home/tao/tools/llvm.optO2/bin/../lib/clang/3.7.0/include/stddef.h" 1 3 4
# 16 "/usr/include/_G_config.h" 2 3 4




# 1 "/usr/include/wchar.h" 1 3 4
# 82 "/usr/include/wchar.h" 3 4
typedef struct
{
  int __count;
  union
  {

    unsigned int __wch;



    char __wchb[4];
  } __value;
} __mbstate_t;
# 21 "/usr/include/_G_config.h" 2 3 4
typedef struct
{
  __off_t __pos;
  __mbstate_t __state;
} _G_fpos_t;
typedef struct
{
  __off64_t __pos;
  __mbstate_t __state;
} _G_fpos64_t;
# 32 "/usr/include/libio.h" 2 3 4
# 49 "/usr/include/libio.h" 3 4
# 1 "/home/tao/tools/llvm.optO2/bin/../lib/clang/3.7.0/include/stdarg.h" 1 3 4
# 30 "/home/tao/tools/llvm.optO2/bin/../lib/clang/3.7.0/include/stdarg.h" 3 4
typedef __builtin_va_list va_list;
# 50 "/home/tao/tools/llvm.optO2/bin/../lib/clang/3.7.0/include/stdarg.h" 3 4
typedef __builtin_va_list __gnuc_va_list;
# 50 "/usr/include/libio.h" 2 3 4
# 144 "/usr/include/libio.h" 3 4
struct _IO_jump_t; struct _IO_FILE;
# 154 "/usr/include/libio.h" 3 4
typedef void _IO_lock_t;





struct _IO_marker {
  struct _IO_marker *_next;
  struct _IO_FILE *_sbuf;



  int _pos;
# 177 "/usr/include/libio.h" 3 4
};


enum __codecvt_result
{
  __codecvt_ok,
  __codecvt_partial,
  __codecvt_error,
  __codecvt_noconv
};
# 245 "/usr/include/libio.h" 3 4
struct _IO_FILE {
  int _flags;




  char* _IO_read_ptr;
  char* _IO_read_end;
  char* _IO_read_base;
  char* _IO_write_base;
  char* _IO_write_ptr;
  char* _IO_write_end;
  char* _IO_buf_base;
  char* _IO_buf_end;

  char *_IO_save_base;
  char *_IO_backup_base;
  char *_IO_save_end;

  struct _IO_marker *_markers;

  struct _IO_FILE *_chain;

  int _fileno;



  int _flags2;

  __off_t _old_offset;



  unsigned short _cur_column;
  signed char _vtable_offset;
  char _shortbuf[1];



  _IO_lock_t *_lock;
# 293 "/usr/include/libio.h" 3 4
  __off64_t _offset;
# 302 "/usr/include/libio.h" 3 4
  void *__pad1;
  void *__pad2;
  void *__pad3;
  void *__pad4;
  size_t __pad5;

  int _mode;

  char _unused2[15 * sizeof (int) - 4 * sizeof (void *) - sizeof (size_t)];

};


typedef struct _IO_FILE _IO_FILE;


struct _IO_FILE_plus;

extern struct _IO_FILE_plus _IO_2_1_stdin_;
extern struct _IO_FILE_plus _IO_2_1_stdout_;
extern struct _IO_FILE_plus _IO_2_1_stderr_;
# 338 "/usr/include/libio.h" 3 4
typedef __ssize_t __io_read_fn (void *__cookie, char *__buf, size_t __nbytes);







typedef __ssize_t __io_write_fn (void *__cookie, const char *__buf,
     size_t __n);







typedef int __io_seek_fn (void *__cookie, __off64_t *__pos, int __w);


typedef int __io_close_fn (void *__cookie);
# 390 "/usr/include/libio.h" 3 4
extern int __underflow (_IO_FILE *);
extern int __uflow (_IO_FILE *);
extern int __overflow (_IO_FILE *, int);
# 434 "/usr/include/libio.h" 3 4
extern int _IO_getc (_IO_FILE *__fp);
extern int _IO_putc (int __c, _IO_FILE *__fp);
extern int _IO_feof (_IO_FILE *__fp) __attribute__ ((__nothrow__ ));
extern int _IO_ferror (_IO_FILE *__fp) __attribute__ ((__nothrow__ ));

extern int _IO_peekc_locked (_IO_FILE *__fp);





extern void _IO_flockfile (_IO_FILE *) __attribute__ ((__nothrow__ ));
extern void _IO_funlockfile (_IO_FILE *) __attribute__ ((__nothrow__ ));
extern int _IO_ftrylockfile (_IO_FILE *) __attribute__ ((__nothrow__ ));
# 464 "/usr/include/libio.h" 3 4
extern int _IO_vfscanf (_IO_FILE * __restrict, const char * __restrict,
   __gnuc_va_list, int *__restrict);
extern int _IO_vfprintf (_IO_FILE *__restrict, const char *__restrict,
    __gnuc_va_list);
extern __ssize_t _IO_padn (_IO_FILE *, int, __ssize_t);
extern size_t _IO_sgetn (_IO_FILE *, void *, size_t);

extern __off64_t _IO_seekoff (_IO_FILE *, __off64_t, int, int);
extern __off64_t _IO_seekpos (_IO_FILE *, __off64_t, int);

extern void _IO_free_backup_area (_IO_FILE *) __attribute__ ((__nothrow__ ));
# 75 "/usr/include/stdio.h" 2 3 4
# 110 "/usr/include/stdio.h" 3 4
typedef _G_fpos_t fpos_t;
# 164 "/usr/include/stdio.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/stdio_lim.h" 1 3 4
# 165 "/usr/include/stdio.h" 2 3 4



extern struct _IO_FILE *stdin;
extern struct _IO_FILE *stdout;
extern struct _IO_FILE *stderr;







extern int remove (const char *__filename) __attribute__ ((__nothrow__ ));

extern int rename (const char *__old, const char *__new) __attribute__ ((__nothrow__ ));
# 195 "/usr/include/stdio.h" 3 4
extern FILE *tmpfile (void) ;
# 209 "/usr/include/stdio.h" 3 4
extern char *tmpnam (char *__s) __attribute__ ((__nothrow__ )) ;
# 237 "/usr/include/stdio.h" 3 4
extern int fclose (FILE *__stream);




extern int fflush (FILE *__stream);
# 272 "/usr/include/stdio.h" 3 4
extern FILE *fopen (const char *__restrict __filename,
      const char *__restrict __modes) ;




extern FILE *freopen (const char *__restrict __filename,
        const char *__restrict __modes,
        FILE *__restrict __stream) ;
# 332 "/usr/include/stdio.h" 3 4
extern void setbuf (FILE *__restrict __stream, char *__restrict __buf) __attribute__ ((__nothrow__ ));



extern int setvbuf (FILE *__restrict __stream, char *__restrict __buf,
      int __modes, size_t __n) __attribute__ ((__nothrow__ ));
# 356 "/usr/include/stdio.h" 3 4
extern int fprintf (FILE *__restrict __stream,
      const char *__restrict __format, ...);




extern int printf (const char *__restrict __format, ...);

extern int sprintf (char *__restrict __s,
      const char *__restrict __format, ...) __attribute__ ((__nothrow__));





extern int vfprintf (FILE *__restrict __s, const char *__restrict __format,
       __gnuc_va_list __arg);




extern int vprintf (const char *__restrict __format, __gnuc_va_list __arg);

extern int vsprintf (char *__restrict __s, const char *__restrict __format,
       __gnuc_va_list __arg) __attribute__ ((__nothrow__));
# 425 "/usr/include/stdio.h" 3 4
extern int fscanf (FILE *__restrict __stream,
     const char *__restrict __format, ...) ;




extern int scanf (const char *__restrict __format, ...) ;

extern int sscanf (const char *__restrict __s,
     const char *__restrict __format, ...) __attribute__ ((__nothrow__ ));
# 531 "/usr/include/stdio.h" 3 4
extern int fgetc (FILE *__stream);
extern int getc (FILE *__stream);





extern int getchar (void);
# 573 "/usr/include/stdio.h" 3 4
extern int fputc (int __c, FILE *__stream);
extern int putc (int __c, FILE *__stream);





extern int putchar (int __c);
# 622 "/usr/include/stdio.h" 3 4
extern char *fgets (char *__restrict __s, int __n, FILE *__restrict __stream)
          ;
# 638 "/usr/include/stdio.h" 3 4
extern char *gets (char *__s) __attribute__ ((__deprecated__));
# 689 "/usr/include/stdio.h" 3 4
extern int fputs (const char *__restrict __s, FILE *__restrict __stream);





extern int puts (const char *__s);






extern int ungetc (int __c, FILE *__stream);






extern size_t fread (void *__restrict __ptr, size_t __size,
       size_t __n, FILE *__restrict __stream) ;




extern size_t fwrite (const void *__restrict __ptr, size_t __size,
        size_t __n, FILE *__restrict __s);
# 749 "/usr/include/stdio.h" 3 4
extern int fseek (FILE *__stream, long int __off, int __whence);




extern long int ftell (FILE *__stream) ;




extern void rewind (FILE *__stream);
# 798 "/usr/include/stdio.h" 3 4
extern int fgetpos (FILE *__restrict __stream, fpos_t *__restrict __pos);




extern int fsetpos (FILE *__stream, const fpos_t *__pos);
# 826 "/usr/include/stdio.h" 3 4
extern void clearerr (FILE *__stream) __attribute__ ((__nothrow__ ));

extern int feof (FILE *__stream) __attribute__ ((__nothrow__ )) ;

extern int ferror (FILE *__stream) __attribute__ ((__nothrow__ )) ;
# 846 "/usr/include/stdio.h" 3 4
extern void perror (const char *__s);







# 1 "/usr/include/x86_64-linux-gnu/bits/sys_errlist.h" 1 3 4
# 854 "/usr/include/stdio.h" 2 3 4
# 24 "./matrix.h" 2






typedef struct {
 int n, m, *col, *startrow, *row;
 double *nz;
 } SMatrix;

struct Pair {
 int block_num;
 struct Pair *next;
 };

typedef struct {
        int i, j, owner, remaining, nmod;
 int length;
 int parent;
 double checksum;
 volatile unsigned int done;
 int *structure, *relative;
 double *nz;
 struct Pair *pair;
      } Block;

typedef union {
        Block *block;
 double nz;
      } Entry;

typedef struct {
        int n, *col, *row, n_blocks, n_entries, entries_allocated;
 int *partition_size, *renumbering, *mapI, *mapJ;
 int *domain, *domains, n_domains, *proc_domains;
 int n_partitions, max_partition;
 double **proc_domain_storage;
 Entry *entry;
      } BMatrix;






struct Update {
 int i, j, src, remaining;
 int dimi, dimj, *structi, *structj;
 double *update;
 struct Update *next;
      };

struct Task {
  int block_num, desti, destj, src;
  struct Update *update;
  struct Task *next;
  };

struct GlobalMemory {
 barrier_t (start);
 pthread_mutex_t (waitLock);
 pthread_mutex_t (memLock);
 unsigned int runtime[128];
 };

struct BlockList {
 int theBlock, row, col, length;
 int *structure;
 double *nz;
 struct BlockList *next;
 };

struct LocalCopies {
       double *blktmp;
       int max_panel;
       int *link;
       int *first;
       double *storage;
       double *updatetmp;
       int *relative;
       struct Update *freeUpdate;
       struct Task *freeTask;
       unsigned int rs;
       unsigned int rf;
       unsigned int us;
       unsigned int uf;
       unsigned int ss;
       unsigned int sf;
       unsigned int runtime;
       unsigned int runs;
       };

SMatrix ReadSparse(), NewMatrix();
SMatrix SymbolicFactor();
double *NewVector();
char *MyMalloc();
# 135 "./matrix.h"
int PreAllocate(int,struct LocalCopies *);
int BNumericSolve(int,struct LocalCopies *);
int DriveParallel(int,struct LocalCopies *);
int DiagReady(int, int, int,struct LocalCopies *);
int LowerReady(int, int, int, int,struct LocalCopies *);
int BFac(int, int,struct LocalCopies *);
int BDiv(int, int, int, int, double *, double *, int,struct LocalCopies *);
int BMod(int, int, int, int, int, double *, double *, double *, int,struct LocalCopies *);
int CopyBlock(double *, double *, int, int, int, int, int, int,struct LocalCopies *);
int BLMod(int, int, int, double *, double *, int,struct LocalCopies *);
int PreProcessFO(int,struct LocalCopies *);
int PreAllocateFO(int,struct LocalCopies *);
int BNumericSolveFO(int,struct LocalCopies *);
int DriveParallelFO(int,struct LocalCopies *);
int DriveSequentialFO(int,struct LocalCopies *);
int HandleTaskFO(int,struct LocalCopies *);
int DiagReceived(int, int,struct LocalCopies *);
int BlockReceived(int, int,struct LocalCopies *);
struct BlockList *CopyOneBlock(int, int,struct LocalCopies *);
int DecrementRemaining(int, int,struct LocalCopies *);
int PerformUpdate(struct BlockList *, struct BlockList *, int,struct LocalCopies *);
int HandleUpdateFO(int, int, struct Update *, int,struct LocalCopies *);
int HandleUpdate2FO(int, int, int, int,struct LocalCopies *);
int BlockReadyFO(int, int,struct LocalCopies *);
int BlockDoneFO(int, int,struct LocalCopies *);
int InitRemainingFO(int,struct LocalCopies *);
int InitReceivedFO(int,struct LocalCopies *);
int RemoveUpdate(int, int, int, struct Update **, int,struct LocalCopies *);
int FindUpdate(int, int, int, struct Update *, int *, struct Update **, int,struct LocalCopies *);
int PrimeQueue(int,struct LocalCopies *);
int Send(int, int, int, int, struct Update *, int, int,struct LocalCopies *);
int TaskWaiting(int,struct LocalCopies *);
int ActiveSpin(volatile unsigned int *, int,struct LocalCopies *);
int GetBlock(int *, int *, int *, struct Update **, int,struct LocalCopies *);
int RemoveUpdate(int, int, int, struct Update **, int,struct LocalCopies *);
int FactorLLDomain(int, int,struct LocalCopies *);
int HandleUpdate(int, int, int, int, double *,struct LocalCopies *);
int HandleDiag(int, int, double *,struct LocalCopies *);
int HandleBlock(int, int, double *,struct LocalCopies *);
int DecrementRemainingSimFO(int, int, double *,struct LocalCopies *);
int BlockReadySimFO(int, int, double *,struct LocalCopies *);
int BlockDoneSimFO(int, int, double *,struct LocalCopies *);
int SendProbe(int, int, int,struct LocalCopies *);
int ReceiveProbe(int, int, int,struct LocalCopies *);
int SendPing(int, int, int,struct LocalCopies *);
int ReceivePing(int, int, int,struct LocalCopies *);
int HandleTask(int,struct LocalCopies *);
int DoOneMod(int, int, int,struct LocalCopies *);
int DoOneLMod(int, int,struct LocalCopies *);
int UpdateFinished(int, int, int, int,struct LocalCopies *);
int PropOne(int, int, int, struct Update *, int,struct LocalCopies *);
int DistributeUpdateFO(int, int,struct LocalCopies *);
int DistributeUpdate(int, int, int,struct LocalCopies *);
int DistributeUpdateOld(double *, int, int, int,struct LocalCopies *);
int FactorMFDomain(int, int,struct LocalCopies *);
int DumpUpdate(int, struct Update *, int,struct LocalCopies *);
char *MyMalloc(int, int);
int SimBlockFO(int, int, double *, double *, double *, struct LocalCopies *);
int AssignBlocks3(int, int, int, struct LocalCopies *);
int FireOffLeafs(double *, struct LocalCopies *);
# 36 "bfac.c" 2
# 1 "/usr/include/math.h" 1 3 4
# 32 "/usr/include/math.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/huge_val.h" 1 3 4
# 33 "/usr/include/math.h" 2 3 4
# 45 "/usr/include/math.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/mathdef.h" 1 3 4
# 46 "/usr/include/math.h" 2 3 4
# 69 "/usr/include/math.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 1 3 4
# 54 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern double acos (double __x) __attribute__ ((__nothrow__ )); extern double __acos (double __x) __attribute__ ((__nothrow__ ));

extern double asin (double __x) __attribute__ ((__nothrow__ )); extern double __asin (double __x) __attribute__ ((__nothrow__ ));

extern double atan (double __x) __attribute__ ((__nothrow__ )); extern double __atan (double __x) __attribute__ ((__nothrow__ ));

extern double atan2 (double __y, double __x) __attribute__ ((__nothrow__ )); extern double __atan2 (double __y, double __x) __attribute__ ((__nothrow__ ));


extern double cos (double __x) __attribute__ ((__nothrow__ )); extern double __cos (double __x) __attribute__ ((__nothrow__ ));

extern double sin (double __x) __attribute__ ((__nothrow__ )); extern double __sin (double __x) __attribute__ ((__nothrow__ ));

extern double tan (double __x) __attribute__ ((__nothrow__ )); extern double __tan (double __x) __attribute__ ((__nothrow__ ));




extern double cosh (double __x) __attribute__ ((__nothrow__ )); extern double __cosh (double __x) __attribute__ ((__nothrow__ ));

extern double sinh (double __x) __attribute__ ((__nothrow__ )); extern double __sinh (double __x) __attribute__ ((__nothrow__ ));

extern double tanh (double __x) __attribute__ ((__nothrow__ )); extern double __tanh (double __x) __attribute__ ((__nothrow__ ));
# 100 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern double exp (double __x) __attribute__ ((__nothrow__ )); extern double __exp (double __x) __attribute__ ((__nothrow__ ));


extern double frexp (double __x, int *__exponent) __attribute__ ((__nothrow__ )); extern double __frexp (double __x, int *__exponent) __attribute__ ((__nothrow__ ));


extern double ldexp (double __x, int __exponent) __attribute__ ((__nothrow__ )); extern double __ldexp (double __x, int __exponent) __attribute__ ((__nothrow__ ));


extern double log (double __x) __attribute__ ((__nothrow__ )); extern double __log (double __x) __attribute__ ((__nothrow__ ));


extern double log10 (double __x) __attribute__ ((__nothrow__ )); extern double __log10 (double __x) __attribute__ ((__nothrow__ ));


extern double modf (double __x, double *__iptr) __attribute__ ((__nothrow__ )); extern double __modf (double __x, double *__iptr) __attribute__ ((__nothrow__ )) __attribute__ ((__nonnull__ (2)));
# 153 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern double pow (double __x, double __y) __attribute__ ((__nothrow__ )); extern double __pow (double __x, double __y) __attribute__ ((__nothrow__ ));


extern double sqrt (double __x) __attribute__ ((__nothrow__ )); extern double __sqrt (double __x) __attribute__ ((__nothrow__ ));
# 178 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern double ceil (double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern double __ceil (double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern double fabs (double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern double __fabs (double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern double floor (double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__)); extern double __floor (double __x) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern double fmod (double __x, double __y) __attribute__ ((__nothrow__ )); extern double __fmod (double __x, double __y) __attribute__ ((__nothrow__ ));




extern int __isinf (double __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));


extern int __finite (double __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));
# 230 "/usr/include/x86_64-linux-gnu/bits/mathcalls.h" 3 4
extern int __isnan (double __value) __attribute__ ((__nothrow__ )) __attribute__ ((__const__));
# 70 "/usr/include/math.h" 2 3 4
# 37 "bfac.c" 2

int vMiss=0, wMiss=0, xMiss=0, yMiss=0;
extern int BS;
extern struct GlobalMemory *Global;
extern BMatrix LB;
extern int solution_method;
extern int *node, *firstchild;
int *block_start, *all_blocks;


extern int *T, P;

BFac(diag, MyNum, lc)
int MyNum;
struct LocalCopies *lc;
{
  int n, is, il, js, jl, ks, kl;
  double *A;

  n = (LB.entry[diag].block)->length;
  A = (LB.entry[diag].block)->nz;

  for (js=0; js<n; js+=BS) {
    jl = js+BS; if (jl > n) jl = n;

    OneFac(&A[js+n*js], jl-js, n);

    for (is=jl; is<n; is+=BS) {
      il = is+BS; if (il > n) il = n;

      CopyBlock(A, lc->blktmp, n, is, js, il, jl, MyNum, lc);

      OneDiv(&A[js+n*js], lc->blktmp, jl-js, il-is, n);

      CopyBlockBack(A, lc->blktmp, n, is, js, il, jl, MyNum, lc);

      for (ks=jl; ks<is; ks+=BS) {
        kl = ks+BS; if (kl > n) kl = n;

 OneMatmat(lc->blktmp, &A[ks+n*js], &A[is+n*ks], kl-ks, jl-js, il-is, n, n);

      }

      OneLower(lc->blktmp, &A[is+n*is], il-is, jl-js, n);

    }

  }
}



OneFac(A, n1, n2)
double *A;
{
  int i, j, k;

  for (j=0; j<n1; j++) {
    for (k=0; k<j; k++)
      for (i=j; i<n1; i++)
 A[i+n2*j] -= A[j+n2*k]*A[i+n2*k];
    A[k+n2*k] = sqrt(A[k+n2*k]);
    for (i=j+1; i<n1; i++)
      A[i+n2*k] /= A[k+n2*k];
  }
}


BDiv(diag, below, n1, n3, diag_nz, below_nz, MyNum, lc)
int diag, below, MyNum;
int n1, n3;
double *diag_nz, *below_nz;
struct LocalCopies *lc;
{
  int is, il, js, jl, ks, kl;
  double *A, *B;




  A = diag_nz; B = below_nz;

  if (n1*n3 <= BS*BS) {
    OneDiv(A, B, n1, n3, n1);
  }
  else {

    for (js=0; js<n1; js+=BS) {
      jl = js+BS; if (jl > n1) jl = n1;
      for (is=0; is<n3; is+=BS) {
        il = is+BS; if (il > n3) il = n3;

        CopyBlock(B, lc->blktmp, n3, is, js, il, jl, MyNum, lc);

        OneDiv(&A[js+js*n1], lc->blktmp, jl-js, il-is, n1);

        CopyBlockBack(B, lc->blktmp, n3, is, js, il, jl, MyNum, lc);

        for (ks=jl; ks<n1; ks+=BS) {
          kl = ks+BS; if (kl > n1) kl = n1;
          OneMatmat(lc->blktmp, &A[ks+js*n1], &B[is+ks*n3], kl-ks, jl-js, il-is,
  n3, n1);
        }
      }
    }
  }
}





OneDiv(A, B, n1, n3, n4)
double *A, *B;
{
  int i, j, k;
  double a_j0k0, a_j0k1, a_j0k2, a_j0k3;
  double a_j1k0, a_j1k1, a_j1k2, a_j1k3;
  double *b0, *b1, *b2, *b3;
  double *dest0, *dest1, *last;
  double *tmp;
  double t0, t1, tmp0, tmp1;

  for (j=0; j<n1-1; j+=2) {
    for (k=0; k<j-3; k+=4) {
      tmp = &A[j+n4*k];
      a_j0k0 = *tmp; a_j1k0 = *(tmp+1); tmp += n4;
      a_j0k1 = *tmp; a_j1k1 = *(tmp+1); tmp += n4;
      a_j0k2 = *tmp; a_j1k2 = *(tmp+1); tmp += n4;
      a_j0k3 = *tmp; a_j1k3 = *(tmp+1);

      dest0 = &B[n3*j]; dest1 = last = dest0+n3;

      b0 = &B[n3*k]; b1 = b0+n3; b2 = b1+n3; b3 = b2+n3;

      while (dest0 != last) {
 t0 = *dest0; t1 = *dest1;
 tmp0 = *b0++; t0 -= a_j0k0*tmp0; t1 -= a_j1k0*tmp0;
 tmp1 = *b1++; t0 -= a_j0k1*tmp1; t1 -= a_j1k1*tmp1;
 tmp0 = *b2++; t0 -= a_j0k2*tmp0; t1 -= a_j1k2*tmp0;
 tmp1 = *b3++; t0 -= a_j0k3*tmp1; t1 -= a_j1k3*tmp1;
 *dest0++ = t0; *dest1++ = t1;
      }
    }
    for (; k<j; k++) {
      a_j0k0 = A[j+n4*k];
      a_j1k0 = A[j+1+n4*k];
      for (i=0; i<n3; i++) {
 B[i+n3*(j+0)] -= a_j0k0*B[i+n3*k];
 B[i+n3*(j+1)] -= a_j1k0*B[i+n3*k];
      }
    }
    tmp0 = 1.0/A[j+n4*j];
    for (i=0; i<n3; i++)
      B[i+n3*j] *= tmp0;
    for (i=0; i<n3; i++) {
      a_j1k0 = A[j+1+n4*k];
      B[i+n3*(j+1)] -= a_j1k0*B[i+n3*j];
    }
    tmp0 = 1.0/A[j+1+n4*(j+1)];
    for (i=0; i<n3; i++)
      B[i+n3*(j+1)] *= tmp0;
  }
  for (; j<n1; j++) {
    for (k=0; k<j; k++) {
      a_j0k0 = A[j+n4*k];
      for (i=0; i<n3; i++)
 B[i+n3*j] -= a_j0k0*B[i+n3*k];
    }
    for (i=0; i<n3; i++)
      B[i+n3*j] /= A[j+n4*j];
  }

}

BMod(top, bend, n1, n2, n3, top_nz, bend_nz, dest_nz, MyNum, lc)
int top, bend, MyNum;
int n1, n2, n3;
double *top_nz, *bend_nz, *dest_nz;
struct LocalCopies *lc;
{
  int is, il, ks, kl, hbs;
  double *B, *A, *C;






  A = top_nz;
  B = bend_nz;
  C = dest_nz;

  if (n2*n3 <= BS*BS) {
    OneMatmat(B, A, C, n1, n2, n3, n3, n1);
  }
  else if (n3 < 2048/16) {
    hbs = 2048/n3;

    for (ks=0; ks<n2; ks+=hbs) {
      kl = ks+hbs; if (kl > n2) kl = n2;
      OneMatmat(&B[ks*n3], &A[ks*n1], C, n1, kl-ks, n3, n3, n1);
    }
  }
  else {

    for (is=0; is<n3; is+=BS) {
      il = is+BS; if (il > n3) il = n3;
      for (ks=0; ks<n2; ks+=BS) {
        kl = ks+BS; if (kl > n2) kl = n2;
        CopyBlock(B, lc->blktmp, n3, is, ks, il, kl, MyNum, lc);
        OneMatmat(lc->blktmp, &A[ks*n1], &C[is], n1, kl-ks, il-is, n3, n1);
      }
    }
  }
}


CopyBlock(B, dest, n3, is, ks, il, kl,MyNum,lc)
double *B, *dest;
int MyNum;
struct LocalCopies *lc;
{
  int i, k, bs;
  double *destination, *bptr, *top_of_B;

  bs = il-is;
  for (k=ks; k<kl; k++)
    for (i=is; i<il; i++) {
      dest[(i-is)+(k-ks)*bs] = B[i+k*n3];
    }
}



CopyBlockBack(B, src, n3, is, ks, il, kl)
double *B, *src;
{
  int i, k, bs;

  bs = il-is;
  for (k=ks; k<kl; k++)
    for (i=is; i<il; i++)
      B[i+k*n3] = src[(i-is)+(k-ks)*bs];
}





OneMatmat(B, A, C, n1, n2, n3, n4, n5)
double *B, *A, *C;
{
  int i, j, k;
  double a_j0k0, a_j0k1, a_j0k2, a_j0k3;
  double a_j0k4, a_j0k5, a_j0k6, a_j0k7;
  double a_j1k0, a_j1k1, a_j1k2, a_j1k3;
  double a_j1k4, a_j1k5, a_j1k6, a_j1k7;
  double *b0, *b1, *b2, *b3, *b4, *b5, *b6, *b7;
  double *dest0, *dest1, *last;
  double *tmp;
  double t0, t1, tmp0, tmp1;

  for (j=0; j<n1-1; j+=2) {
    k = 0;
    for (; k<n2-7; k+=8) {
      tmp = &A[j+n5*k];
      a_j0k0 = *tmp; a_j1k0 = *(tmp+1); tmp += n5;
      a_j0k1 = *tmp; a_j1k1 = *(tmp+1); tmp += n5;
      a_j0k2 = *tmp; a_j1k2 = *(tmp+1); tmp += n5;
      a_j0k3 = *tmp; a_j1k3 = *(tmp+1); tmp += n5;
      a_j0k4 = *tmp; a_j1k4 = *(tmp+1); tmp += n5;
      a_j0k5 = *tmp; a_j1k5 = *(tmp+1); tmp += n5;
      a_j0k6 = *tmp; a_j1k6 = *(tmp+1); tmp += n5;
      a_j0k7 = *tmp; a_j1k7 = *(tmp+1);

      dest0 = &C[n4*j]; dest1 = dest0 + n4;
      last = dest0 + n3;

      b0 = &B[n3*k]; b1 = b0+n3; b2 = b1+n3; b3 = b2+n3;
      b4 = b3+n3; b5 = b4+n3; b6 = b5+n3; b7 = b6+n3;

      while (dest0 != last) {
 t0 = *dest0; t1 = *dest1;
 tmp0 = *b0++; t0 -= a_j0k0*tmp0; t1 -= a_j1k0*tmp0;
 tmp1 = *b1++; t0 -= a_j0k1*tmp1; t1 -= a_j1k1*tmp1;
 tmp0 = *b2++; t0 -= a_j0k2*tmp0; t1 -= a_j1k2*tmp0;
 tmp1 = *b3++; t0 -= a_j0k3*tmp1; t1 -= a_j1k3*tmp1;
 tmp0 = *b4++; t0 -= a_j0k4*tmp0; t1 -= a_j1k4*tmp0;
 tmp1 = *b5++; t0 -= a_j0k5*tmp1; t1 -= a_j1k5*tmp1;
 tmp0 = *b6++; t0 -= a_j0k6*tmp0; t1 -= a_j1k6*tmp0;
 tmp1 = *b7++; t0 -= a_j0k7*tmp1; t1 -= a_j1k7*tmp1;
 *dest0++ = t0; *dest1++ = t1;
      }
    }
    for (; k<n2-3; k+=4) {
      tmp = &A[j+n5*k];
      a_j0k0 = *tmp; a_j1k0 = *(tmp+1); tmp += n5;
      a_j0k1 = *tmp; a_j1k1 = *(tmp+1); tmp += n5;
      a_j0k2 = *tmp; a_j1k2 = *(tmp+1); tmp += n5;
      a_j0k3 = *tmp; a_j1k3 = *(tmp+1);

      dest0 = &C[n4*j]; dest1 = dest0 + n4;
      last = dest0 + n3;

      b0 = &B[n3*k]; b1 = b0+n3; b2 = b1+n3; b3 = b2+n3;

      while (dest0 != last) {
 t0 = *dest0; t1 = *dest1;
 tmp0 = *b0++; t0 -= a_j0k0*tmp0; t1 -= a_j1k0*tmp0;
 tmp1 = *b1++; t0 -= a_j0k1*tmp1; t1 -= a_j1k1*tmp1;
 tmp0 = *b2++; t0 -= a_j0k2*tmp0; t1 -= a_j1k2*tmp0;
 tmp1 = *b3++; t0 -= a_j0k3*tmp1; t1 -= a_j1k3*tmp1;
 *dest0++ = t0; *dest1++ = t1;
      }
    }
    for (; k<n2; k++) {
      a_j0k0 = A[j+n5*k];
      a_j1k0 = A[j+1+n5*k];
      for (i=0; i<n3; i++) {
 t0 = B[i+n3*k];
 C[i+n4*j] -= a_j0k0*t0;
 C[i+n4*(j+1)] -= a_j1k0*t0;
      }
    }
  }
  for (;j<n1; j++) {
    for (k=0; k<n2-3; k+=4) {
      tmp = &A[j+n5*k];
      a_j0k0 = *tmp; tmp += n5;
      a_j0k1 = *tmp; tmp += n5;
      a_j0k2 = *tmp; tmp += n5;
      a_j0k3 = *tmp; tmp += n5;

      b0 = &B[n3*k]; b1 = b0+n3; b2 = b1+n3; b3 = b2+n3;
      dest0 = &C[n4*j]; last = dest0 + n3;

      while (dest0 != last) {
 t0 = *dest0;
 t0 -= a_j0k0*(*b0++);
 t0 -= a_j0k1*(*b1++);
 t0 -= a_j0k2*(*b2++);
 t0 -= a_j0k3*(*b3++);
 *dest0++ = t0;
      }
    }
    for (; k<n2; k++) {
      a_j0k0 = A[j+n5*k];
      for (i=0; i<n3; i++)
 C[i+n4*j] -= a_j0k0*B[i+n3*k];
    }
  }

}





BLMod(left, n1, n2, left_nz, dest_nz, MyNum, lc)
int left, n1, n2, MyNum;
double *left_nz, *dest_nz;
struct LocalCopies *lc;
{
  int is, ks, il, kl;
  double *A, *C;

  A = left_nz;
  C = dest_nz;

  if (n1*n2 <= BS*BS) {
    OneLower(A, C, n1, n2, n1);
  }
  else {
    for (is=0; is<n1; is+=BS) {
      il = is+BS; if (il > n1) il = n1;
      for (ks=0; ks<n2; ks+=BS) {
        kl = ks+BS; if (kl > n2) kl = n2;
        CopyBlock(A, lc->blktmp, n1, is, ks, il, kl, MyNum, lc);
        OneMatmat(lc->blktmp, &A[ks*n1], &C[is], is, kl-ks, il-is, n1, n1);
 OneLower(lc->blktmp, &C[is+is*n1], il-is, kl-ks, n1);
      }
    }
  }
}






OneLower(A, C, n1, n2, n3)
double *A, *C;
{
  int i, j, k;
  double *tmp;
  double a_j0k0, a_j0k1, a_j0k2, a_j0k3;
  double a_j1k0, a_j1k1, a_j1k2, a_j1k3;
  double *b0, *b1, *b2, *b3;
  double t0, t1, tmp0, tmp1;
  double *dest0, *dest1, *last;

  for (j=0; j<n1-1; j+=2) {
    for (k=0; k<n2-3; k+=4) {
      tmp = &A[j+n1*k];
      a_j0k0 = *tmp; a_j1k0 = *(tmp+1); tmp += n1;
      a_j0k1 = *tmp; a_j1k1 = *(tmp+1); tmp += n1;
      a_j0k2 = *tmp; a_j1k2 = *(tmp+1); tmp += n1;
      a_j0k3 = *tmp; a_j1k3 = *(tmp+1);

      b0 = &A[j+n1*k]; b1 = b0+n1; b2 = b1+n1; b3 = b2+n1;

      dest0 = &C[j+n3*j];
      last = dest0+n1-j;
      *dest0++ -= a_j0k0**b0++ + a_j0k1**b1++ + a_j0k2**b2++ + a_j0k3**b3++;
      dest1 = dest0 + n3;
      while (dest0 != last) {
 t0 = *dest0; t1 = *dest1;
 tmp0 = *b0++; t0 -= a_j0k0*tmp0; t1 -= a_j1k0*tmp0;
 tmp1 = *b1++; t0 -= a_j0k1*tmp1; t1 -= a_j1k1*tmp1;
 tmp0 = *b2++; t0 -= a_j0k2*tmp0; t1 -= a_j1k2*tmp0;
 tmp1 = *b3++; t0 -= a_j0k3*tmp1; t1 -= a_j1k3*tmp1;
 *dest0++ = t0; *dest1++ = t1;
      }
    }
    for (; k<n2; k++) {
      a_j0k0 = A[j+n1*k];
      a_j1k0 = A[j+1+n1*k];
      C[j+n3*j] -= a_j0k0*A[j+n1*k];
      for (i=j+1; i<n1; i++) {
 C[i+n3*j] -= a_j0k0*A[i+n1*k];
 C[i+n3*(j+1)] -= a_j1k0*A[i+n1*k];
      }
    }
  }
  for (; j<n1; j++)
    for (k=0; k<n2; k++) {
      a_j0k0 = A[j+n1*k];
      for (i=j; i<n1; i++)
 C[i+n3*j] -= a_j0k0*A[i+n1*k];
    }

}


FindBlockUpdate(domain, bli, blj, update, stride)
int domain, blj, bli;
double **update;
int *stride;
{
  int i;
  int into_i, into_j, update_len;
  double *domain_update;

  into_j = 0;
  for (i=LB.col[LB.n+domain]; i<blj; i++)
    into_j += (LB.entry[i].block)->length;
  into_i = into_j;
  for (; i<bli; i++)
    into_i += (LB.entry[i].block)->length;
  update_len = into_i;
  for (; i<LB.col[LB.n+domain+1]; i++)
    update_len += (LB.entry[i].block)->length;

  domain_update = LB.proc_domain_storage[domain];
  *update = &domain_update[into_j*update_len - into_j*(into_j+1)/2 + into_i];
  *stride = update_len - into_j - 1;
}

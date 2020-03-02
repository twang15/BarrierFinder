# 1 "isect.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 314 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "isect.c" 2
# 35 "isect.c"
# 1 "/usr/include/stdio.h" 1 3 4
# 27 "/usr/include/stdio.h" 3 4
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
# 28 "/usr/include/stdio.h" 2 3 4





# 1 "/home/tao/tools/llvm.optO2/bin/../lib/clang/3.7.0/include/stddef.h" 1 3 4
# 62 "/home/tao/tools/llvm.optO2/bin/../lib/clang/3.7.0/include/stddef.h" 3 4
typedef long unsigned int size_t;
# 34 "/usr/include/stdio.h" 2 3 4

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
# 36 "/usr/include/stdio.h" 2 3 4








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
# 36 "isect.c" 2
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
# 37 "isect.c" 2
# 1 "./rt.h" 1
# 56 "./rt.h"
# 1 "/usr/include/pthread.h" 1 3 4
# 22 "/usr/include/pthread.h" 3 4
# 1 "/usr/include/endian.h" 1 3 4
# 36 "/usr/include/endian.h" 3 4
# 1 "/usr/include/x86_64-linux-gnu/bits/endian.h" 1 3 4
# 37 "/usr/include/endian.h" 2 3 4
# 23 "/usr/include/pthread.h" 2 3 4
# 1 "/usr/include/sched.h" 1 3 4
# 28 "/usr/include/sched.h" 3 4
# 1 "/home/tao/tools/llvm.optO2/bin/../lib/clang/3.7.0/include/stddef.h" 1 3 4
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
# 56 "./rt.h" 2

//#include "libittnotify.h"


 typedef struct {
  volatile int gsense;
  volatile long count;
} barrier_t;
# 269 "./rt.h"
typedef char CHAR;
typedef char S8;
typedef unsigned char UCHAR;
typedef unsigned char U8;

typedef short SHORT;
typedef short S16;
typedef unsigned short USHORT;
typedef unsigned short U16;

typedef long INT;
typedef unsigned long UINT;
typedef unsigned long BOOL;

typedef long LONG;
typedef long S32;
typedef unsigned long ULONG;
typedef unsigned long U32;

typedef float FLOAT;
typedef float R32;
typedef double DOUBLE;
typedef double R64;
typedef double REAL;


typedef REAL UV[2];
typedef REAL VEC3[3];
typedef REAL VEC4[4];
typedef REAL MATRIX[4][4];

typedef VEC4 POINT;
typedef VEC3 COLOR;







typedef struct pprocs
 {
 CHAR *(*name)();
 void (*print)();
 void (*read)();
 void (*binread)();
 void (*transform)();
 INT (*intersect)();
 INT (*pe_intersect)();
 void (*normal)();
 void (*normalize)();
 void (*bbox)();
 }
 PPROCS;






typedef struct surf
 {
 COLOR fcolor;
 COLOR bcolor;
 REAL kdiff;
 REAL kspec;
 REAL ktran;
 REAL refrindex;
 REAL kspecn;
 }
 SURF;







typedef struct light
 {
 VEC4 pos;
 COLOR col;
 BOOL shadow;
 struct light *next;
 }
 LIGHT;







typedef struct pixel
 {
 R32 r;
 R32 g;
 R32 b;
 }
 PIXEL;







typedef struct voxel
 {
 INT id;
 CHAR *cell;
 CHAR celltype;


 INT numelements;
 struct voxel *next;
 }
 VOXEL;







typedef struct bbox
 {
 REAL dnear[3];
 REAL dfar[3];
 }
 BBOX;







typedef struct view
 {
 POINT eye;
 POINT coi;
 MATRIX vtrans;
 MATRIX vtransInv;
 MATRIX model;
 COLOR bkg;
 INT projection;
 REAL vang;
 COLOR ambient;
 BOOL shad;
 BOOL shading;
 }
 VIEW;






typedef struct display
 {
 INT maxlevel;
 INT maxAAsubdiv;
 INT aarow;
 INT aacol;
 REAL aatolerance;
 INT xres,yres;
 INT numpixels;
 REAL minweight;
 REAL scrDist;
 REAL scrWidth;
 REAL scrHeight;
 REAL scrHalfWidth;
 REAL scrHalfHeight;
 REAL vWscale;
 REAL vHscale;
 PIXEL *framebuffer;
 }
 DISPLAY;







typedef struct element
 {
 INT index;
 BBOX bv;
 struct object *parent;
 CHAR *data;
 }
 ELEMENT;






typedef struct object
 {
 INT index;
 CHAR name[30];
 BBOX bv;
 ELEMENT *pelem;
 INT numelements;
 PPROCS *procs;
 SURF *surf;
 struct object *next;
 }
 OBJECT;






typedef struct irecord
 {
 REAL t;
 ELEMENT *pelem;
 REAL b1;
 REAL b2;
 REAL b3;
 }
 IRECORD;







typedef struct btnode
 {
 ELEMENT **pe;
 REAL p[3];

 INT nprims;
 INT n[3];
 INT i[3];

 INT axis;
 INT totalPrimsAllocated;
 struct btnode *btn[2];
 }
 BTNODE;



typedef struct grid
 {
 INT id;
 VOXEL **hashtable;





 UINT *emptycells;






 ELEMENT **pepa;
 INT num_prims;

 INT indx_inc[3];



 INT num_buckets;
 REAL min[3];
 REAL cellsize[3];

 INT subdiv_level;


 BTNODE *bintree;
 struct grid *next;
 }
 GRID;
# 563 "./rt.h"
typedef struct rayinfo
 {
 GRID *grid;
 REAL d[3];

 INT entry_plane;

 REAL t_in;

 INT exit_plane;

 REAL t_out;

 REAL delta[3];
 INT index3D[3];
 INT index1D;


 INT indx_inc1D[3];
 struct rayinfo *next;
 }
 RAYINFO;







typedef struct ray
 {
 LONG id;
 INT x, y;
 VEC3 P;
 VEC3 D;
 INT level;
 R32 weight;
 INT indx_inc3D[3];
 RAYINFO *ri;
 INT ri_indx;
 RAYINFO rinfo[(3 + 1) + 1];
 }
 RAY;







typedef struct rayjob
 {
 INT x, y;
 INT xlen, ylen;
 INT xcurr, ycurr;
 }
 RAYJOB;







typedef struct wpjob
 {
 INT ypix, xpix;
 INT xdim, ydim;
 struct wpjob *next;
 }
 WPJOB;







typedef struct node
 {
 struct node *next;
 UINT size;
 BOOL free;
 UINT cksm;
 }
 NODE;







typedef struct gmem
 {
 INT nprocs;
 INT pid;
 INT rid;
 OBJECT *modelroot;
 GRID *world_level_grid;
 NODE *freelist;
 INT wpstat[128][256];


 WPJOB *workpool[128][256];



 barrier_t (start);
 pthread_mutex_t (pidlock);
 pthread_mutex_t (ridlock);
 pthread_mutex_t (memlock);
 pthread_mutex_t (wplock)[(128)];
    UINT par_start_time;
    UINT partime[128];
 }
 GMEM;







INT DataType;

INT TraversalType;

INT bundlex, bundley;
INT blockx, blocky;
INT NumSubRays;

BOOL GeoFile;
BOOL PicFile;
BOOL ModelNorm;
BOOL ModelTransform;
BOOL AntiAlias;

CHAR *ProgName;
CHAR GeoFileName[80];
CHAR PicFileName[80];

VIEW View;
DISPLAY Display;
LIGHT *lights;
INT nlights;

GMEM *gm;



GRID *world_level_grid;
GRID *gridlist;

INT hu_max_prims_cell;
INT hu_gridsize;
INT hu_numbuckets;
INT hu_max_subdiv_level;
INT hu_lazy;

INT prim_obj_cnt;
INT prim_elem_cnt;
INT subdiv_cnt;
INT bintree_cnt;

INT grids;
INT total_cells;
INT empty_voxels;
INT nonempty_voxels;
INT nonempty_leafs;
INT prims_in_leafs;

UINT empty_masks[sizeof(UINT)*8];
UINT nonempty_masks[sizeof(UINT)*8];







extern void InquireBoundBoxValues(struct bbox *pbb,double *minx,double *miny,double *minz,double *maxx,double *maxy,double *maxz);
extern void NormalizeBoundBox(struct bbox *pbb,double (*mat)[4]);

extern void prn_gridlist(void );
extern void prn_ds_stats(void );
extern void init_masks(void );
extern struct grid *init_world_grid(struct voxel *v,ELEMENT **pepa,long num_pe);
extern struct voxel *init_world_voxel(ELEMENT **pepa, INT numelements);
extern void mark_empty(long index1D,struct grid *g);
extern void mark_nonempty(long index1D,struct grid *g);
extern void insert_in_hashtable(struct voxel *v,struct grid *g);
extern struct element * *prims_in_box2(struct element * *pepa,long n_in,struct bbox b,long *n);
extern struct btnode *init_bintree(struct grid *ng);
extern void subdiv_bintree(struct btnode *btn,struct grid *g);
extern void create_bintree(struct btnode *root,struct grid *g);
extern ELEMENT **bintree_lookup(struct btnode *root,long i,long j,long k,struct grid *g,long *n);
extern struct grid *create_grid(struct voxel *v,struct grid *g,long num_prims);

extern void PrintEnv(void );
extern void InitEnv(void );
extern void InitLights(void );
extern void InitDisplay(void );
extern unsigned long VerifyColorRange(double *c);
extern void TransformLights(double (*m)[4]);
extern void ViewRotate(double (*M)[4],double x,double y,double z);
extern void CreateViewMatrix(void );
extern void TransformViewRay(double *tray);
extern void NormalizeEnv(double (*normMat)[4]);
extern char LookupCommand(char *s);
extern void ReadEnvFile(char *EnvFileName);

extern void RunLengthEncode(FILE *pf,struct pixel *fb,long xsize);
extern void OpenFrameBuffer(void);
extern void AddPixelColor(double *c,long x,long y);
extern void CloseFrameBuffer(char *PicFileName);

extern ELEMENT **MakeElementArray(long *totalElements);
extern void PrintGeo(struct object *head);
extern void NormalizeGeo(struct object *po, double (*model)[4],double (*modelInvT)[4]);
extern void ReadGeoFile(char *mname);

extern void prn_voxel(struct voxel *v);
extern void prn_grid(struct grid *g);
extern void prn_ray(struct ray *r);
extern void prn_PrimElem(struct element *p);
extern void prn_bintree_node(struct btnode *b);
extern void prn_bintree_leaves(struct btnode *root);
extern void prn_pepa_prim_list(struct element * *pepa,long nprims);

extern void Huniform_defaults(void );
extern void BuildHierarchy_Uniform(void );
extern void IntersectHuniformPrimlist(long *intersectPrim,struct irecord *hit,VOXEL *v,struct ray *r,long pid);
extern double HuniformShadowIntersect(struct ray *r,double lightlength,struct element *pe,long pid);
extern unsigned long TraverseHierarchyUniform(struct ray *r,struct irecord *hit,long pid);

extern void prn_tv_stats(void );
extern long send_ray(struct ray *r,struct voxel *v);
extern struct voxel *lookup_hashtable(long indx,struct grid *g);
extern long lookup_emptycells(long indx,struct grid *g);
extern void pop_up_a_grid(struct ray *r);
extern void push_down_grid(struct ray *r,struct voxel *v);
extern long step_grid(struct ray *r);
extern long next_voxel(struct ray *r);
extern struct voxel *next_nonempty_voxel(struct ray *r);
extern struct voxel *next_nonempty_leaf(struct ray *r,long step,long *status);
extern struct voxel *init_ray(struct ray *r,struct grid *g);

extern unsigned long Intersect(struct ray *pr,struct irecord *hit);
extern double ShadowIntersect(struct ray *pr,double lightdist,struct element *pe);

extern void Usage(void );
extern void PrintStatistics(void );
extern void StartRayTrace(void );
extern int main(int argc,char * *argv);

extern void VecNorm(double *V);
extern void VecMatMult(double *Vt,double (*M)[4],double *V);
extern void PrintMatrix(double (*M)[4],char *s);
extern void MatrixIdentity(double (*M)[4]);
extern void MatrixCopy(double (*A)[4],double (*B)[4]);
extern void MatrixTranspose(double (*MT)[4],double (*M)[4]);
extern void MatrixMult(double (*C)[4],double (*A)[4],double (*B)[4]);
extern void MatrixInverse(double (*Minv)[4],double (*Mat)[4]);
extern void Translate(double (*M)[4],double dx,double dy,double dz);
extern void Scale(double (*M)[4],double sx,double sy,double sz);
extern void Rotate(long axis,double (*M)[4],double angle);

extern void *LocalMalloc(UINT, CHAR *);
extern void LocalFree(void *);
extern void GlobalHeapWalk(void);
extern BOOL GlobalHeapInit(UINT);
extern void *GlobalMalloc(UINT, CHAR *);
extern void *GlobalCalloc(UINT, UINT);
extern void *GlobalRealloc(void *, UINT);
extern void GlobalFree(void *);
extern UINT GlobalMemAvail(void);
extern UINT GlobalMemMax(void);
extern void *ObjectMalloc(INT, INT);
extern void ObjectFree(INT, INT, void *);

extern struct rayinfo *ma_rayinfo(struct ray *r);
extern void free_rayinfo(struct ray *r);
extern void reset_rayinfo(struct ray *r);
extern void ma_print(void );




typedef struct poly POLY;
extern char *PolyName(void );
extern void PolyPrint(struct object *po);
extern void PolyElementBoundBox(struct element *pe, POLY *pp);
extern void PolyBoundBox(struct object *po);
extern void PolyNormal(struct irecord *hit,double *Pi,double *Ni);
extern void PolyDataNormalize(struct object *po,double (*normMat)[4]);
extern long PolyPeIntersect(struct ray *pr,struct element *pe,struct irecord *hit);
extern long PolyIntersect(struct ray *pr,struct object *po,struct irecord *hit);
extern void PolyTransform(struct object *po,double (*xtrans)[4],double (*xinvT)[4]);
extern void PolyRead(struct object *po,FILE *pf);

extern void CopyRayMsg(struct ray *rdst,struct ray *rsrc);
extern void InitRayTreeStack(long TreeDepth, INT pid);
extern void PushRayTreeStack(struct ray *rmsg, INT pid);
extern long PopRayTreeStack(struct ray *rmsg, INT pid);

extern void SpecularDirection(double *R,double *N,double *I);
extern unsigned long TransmissionDirection(double *T,double *N,double *I,double kn);
extern void Shade(double *iP,double *N,struct ray *ray,struct irecord *hit,long pid);




typedef struct sphere SPHERE;
extern char *SphName(void );
extern void SphPrint(struct object *po);
extern void SphElementBoundBox(struct element *pe, SPHERE *ps);
extern void SphBoundBox(struct object *po);
extern void SphNormal(struct irecord *hit,double *Pi,double *Ni);
extern void SphDataNormalize(struct object *po,double (*normMat)[4]);
extern long SphPeIntersect(struct ray *pr,struct element *pe,struct irecord *hit);
extern long SphIntersect(struct ray *pr,struct object *po,struct irecord *hit);
extern void SphTransform(struct object *po,double (*xtrans)[4],double (*xinvT)[4]);
extern void SphRead(struct object *po,FILE *pf);

extern unsigned long GetRayJobFromBundle(struct rayjob *job,long *x,long *y);
extern void ConvertPrimRayJobToRayMsg(struct ray *ray,double x,double y);
extern void RayTrace(long pid);




typedef struct tri TRI;
extern char *TriName(void );
extern void TriPrint(struct object *po);
extern void TriElementBoundBox(struct element *pe,TRI *pt);
extern void TriBoundBox(struct object *po);
extern void TriNormal(struct irecord *hit,double *Pi,double *Ni);
extern void TriDataNormalize(struct object *po,double (*normMat)[4]);
extern long TriPeIntersect(struct ray *pr,struct element *pe,struct irecord *hit);
extern long TriIntersect(struct ray *pr,struct object *po,struct irecord *hit);
extern void TriTransform(struct object *po,double (*xtrans)[4],double (*xinvT)[4]);
extern void TriRead(struct object *po, FILE *pf);

extern void InitWorkPool(long pid);
extern void PrintWorkPool(long pid);
extern void PutJob(long xs,long ys,long xe,long ye,long xbe,long ybe,long pid);
extern long GetJob(struct rayjob *job,long pid);
extern long GetJobs(struct rayjob *job,long pid);
# 38 "isect.c" 2
# 54 "isect.c"
BOOL Intersect(pr, hit)
RAY *pr;
IRECORD *hit;
 {
 OBJECT *po;
 IRECORD newhit;

 po = gm->modelroot;
 hit->t = 1e+32;
 hit->pelem = ((void*)0);

 while (po)
  {
  if ((*po->procs->intersect)(pr, po, &newhit))
   if (newhit.t < hit[0].t)
    *hit = newhit;

  po = po->next;
  }

 if (hit->t < 1e+32)
  return (1);
 else
  return (0);
 }
# 99 "isect.c"
REAL ShadowIntersect(pr, lightdist, pe)
RAY *pr;
REAL lightdist;
ELEMENT *pe;
 {
 REAL trans;
 OBJECT *po;
 IRECORD newhit;

 trans = 1.0;
 po = gm->modelroot;

 while (po && trans > 0.0)
  {
  if ((*po->procs->intersect)(pr, po, &newhit) && newhit.pelem != pe && newhit.t < lightdist)
   trans *= newhit.pelem->parent->surf->ktran;

  po = po->next;
  }

 return (trans);
 }

TARGET = LU
OBJS = lu.o print2.o
#OBJS = lu.o print.o
#CFLAGS = -O2 -Olimit 2000 -w
#LDFLAGS = -lmpc -lm
cc = clang
CFLAGS = -O0 -save-temps -flto -v -Xlinker -plugin-opt=save-temps
LDFLAGS = -lpthread -lm
#MACROS = ../../../null_macros/c.m4.null
MACROS = ../c.m4.ia32


x = *

$(TARGET): $(OBJS)
	${cc} $(OBJS) $(CFLAGS) -o $(TARGET) $(LDFLAGS)

.SUFFIXES:
.SUFFIXES:	.o .c .C .h .H

.H.h:
	m4 ${MACROS} $*.H > $*.h

.C.c:
	m4 $(MACROS) $*.C > $*.c

.c.o:
	${cc} -c $(CFLAGS) $*.c

.C.o:
	m4 $(MACROS) $*.C > $*.c
	${cc} -c $(CFLAGS) $*.c

clean:
	rm -rf *.o *.dot LU *.bc *.i

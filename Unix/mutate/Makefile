#  $Id: Makefile,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $

OBJS = mutate.o
CCFLAGS = -Wall -Werror -O3

all: mutate

mutate: ${OBJS}
	g++ -o mutate ${OBJS}

.cc.o:
	g++ ${CCFLAGS} -c $<

clean:
	rm -fr mutate *.o *~ *core*


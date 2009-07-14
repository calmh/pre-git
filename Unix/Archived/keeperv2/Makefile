#  $Id: Makefile,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $

# Set the following to "no" to disable debugging stuff
DEBUG = yes

ifeq ($(PREFIX),)
PREFIX = /usr/local
endif

OBJS = libKeeper.so cli.o config.o parser.o
KEEPER = keeper.o keeperconnection.o keeperobj.o

ifeq ($(DEBUG),yes)
CFLAGS = -fpic -O0 -Wall -Werror -g -I/usr/include/postgresql
RPATH =  -Xlinker -rpath -Xlinker .
else
CFLAGS = -fpic -s -O2 -Wall -Werror -DNDEBUG=true -I/usr/include/postgresql
# RPATH =  -Xlinker -rpath -Xlinker ${PREFIX}/lib
endif

CCFLAGS = ${CFLAGS} # buggar tyvärr: -fhonor-std
LIBS = -lpq++

all: keeper

.cc.o:
	g++ ${CCFLAGS} -c $<

.c.o:
	gcc ${CFLAGS} -c $<

keeper: ${OBJS}
	g++ ${OBJS} ${LIBS} ${RPATH} -o keeper

libKeeper.so: ${KEEPER}
	g++ -shared ${KEEPER} -o libKeeper.so

clean:
	rm -f *.o *.so *.bb *.bbg *.gcov *.da keeper *~ \#*

install: keeper
	install -o 0 -g 0 -m 4755 keeper $(PREFIX)/bin/keeper
	install -o 0 -g 0 -m 755 libKeeper.so $(PREFIX)/lib/libKeeper.so
	ldconfig

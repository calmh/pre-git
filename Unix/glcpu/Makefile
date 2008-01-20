#  $Id: Makefile,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $

OBJSMAIN = main.o parser.o config.o
OBJSSTATD = statd.o cpu.o
CCFLAGS = -D_GNU_SOURCE -ansi -g -Wall -Werror -DOS_$(shell uname) -I/usr/X11R6/include
# CommonC++ headers fail -pedantic checking
LIBS = -L/usr/X11R6/lib -lX11 -lXext -lXmu
DLIBS = -lccxx -lGL -lGLU -lglut -lpthread
SLIBS = -ldl /usr/lib/libccxx.a /usr/lib/libpthread.a /usr/lib/libglut.a /usr/lib/libGL.a /usr/lib/libGLU.a
PREFIX = /usr/local

all: glcpu statd

static: glcpu-static

.cc.o:
	g++ ${CCFLAGS} -c $<

glcpu: ${OBJSMAIN}
	g++ ${OBJSMAIN} ${LIBS} ${DLIBS} -o glcpu

glcpu-static: ${OBJSMAIN}
	g++ ${OBJSMAIN} ${LIBS} ${SLIBS} -s -o glcpu-static

statd: ${OBJSSTATD}
	g++ ${OBJSSTATD} -o statd

clean:
	rm -f build
	rm -f *.o glcpu *~ \#* statd glcpu-static

install: install-glcpu install-statd

install-glcpu: glcpu
	install -m 755 -o root -g root -s glcpu ${PREFIX}/bin

install-statd: statd
	install -m 755 -o root -g root -s statd ${PREFIX}/sbin


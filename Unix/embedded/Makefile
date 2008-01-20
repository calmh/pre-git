GGE=gge.o
LIBS=-lncurses

all: spaceinvaders

spaceinvaders: spaceinvaders.c ${GGE}
	cc $< ${GGE} ${LIBS} -o spaceinvaders

gge.o:	gge.c gge.h
	cc -c $<

clean:
	rm -f *.o *~ spaceinvaders

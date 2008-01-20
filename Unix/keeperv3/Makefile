# $Id: Makefile,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
# Copyright (c) 2001 Jakob Borg <jakob@borg.pp.se>

OBJS = blob.o ui.o cli.o main.o datastore.o util.o
CFLAGS = -Wall -Werror -g
LIBS = -lreadline -lmysqlclient

all: keeper

keeper: ${OBJS}
	g++ ${OBJS} ${LIBS} -o keeper

%.o : %.cc
	g++ ${CFLAGS} -c $<

clean:
	rm -f *~ *.o keeper

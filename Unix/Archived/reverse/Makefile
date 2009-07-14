#  $Id: Makefile,v 1.1.1.1 2003/03/01 12:55:12 jb Exp $

LIBOBJS = reader.o writer.o reporter.o indexer.o file.o chunkheader.o
SAVEOBJS = save.o libreverse.a
RESTOREOBJS = restore.o libreverse.a
LSCHUNKSOBJS = lschunks.o libreverse.a
LSFILESOBJS = lsfiles.o libreverse.a
ARCHIVEOBJS = archive.o libreverse.a
CCFLAGS = ${CFLAGS} -Wall -O2 # buggar tyvärr: -ansi -fhonor-std
#LIBS = -lefence
#DEBUG = -DDEBUG -g

all: save restore lschunks lsfiles label archive

.cc.o:
	g++ ${CCFLAGS} ${DEBUG} -c $<

label:
	g++ ${CCFLAGS} ${DEBUG} label.cc -o label

libreverse.a: ${LIBOBJS}
	ar r libreverse.a ${LIBOBJS}

save: ${SAVEOBJS}
	g++ ${SAVEOBJS} ${LIBS} -o save

lschunks: ${LSCHUNKSOBJS}
	g++ ${LSCHUNKSOBJS} ${LIBS} -o lschunks

lsfiles: ${LSFILESOBJS}
	g++ ${LSFILESOBJS} ${LIBS} -o lsfiles

restore: ${RESTOREOBJS}
	g++ ${RESTOREOBJS} ${LIBS} -o restore

archive: ${ARCHIVEOBJS}
	g++ ${ARCHIVEOBJS} ${LIBS} -o archive

install: save lschunks lsfiles restore archive label libreverse.a
	cp save lschunks lsfiles restore archive label /usr/local/bin
	mkdir /etc/reverse || true
	mkdir /var/lib/reverse || true
	mkdir /var/lib/reverse/index || true
	mkdir /var/lib/reverse/tmp || true

clean:
	rm -f *.o *~ \#* save restore lschunks lsfiles libreverse.a label archive

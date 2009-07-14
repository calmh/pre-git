# Generated automatically from Makefile.in by configure.
# Makefile  - replay 0.47a

#DEBUG = -DDEBUG

# Make sure the path is correct!
GTK-CONFIG = "gtk-config"

# ---- Linux/i686 ----

CC = gcc
DEFINES = -DNO_BYTE_SWAPPING -DOS_Linux -DARCH_i686 -DDATE="\"`date +%y%m%d`\""
CFLAGS = `$(GTK-CONFIG) --cflags` -O6 -ffast-math -fomit-frame-pointer  ${DEFINES} ${DEBUG}
LDFLAGS =  
RM = /bin/rm -f
CP = /bin/cp -f


#
# uncomment both of these if you want profiling support
#
#PG = -pg
#LDFLAGS+= -pg

#
# you should probably leave these untouched ####################################
#

OBJ = dump.o formats.o getbits.o huffman.o layer3.o getdata.o misc2.o transform.o audio.o buffer.o audioIO.o position.o layer2.o rtbuf.o util.o getopt.o getopt1.o replay.o

LIBS = `$(GTK-CONFIG) --libs` 
SLIBS = static_gtk/libgtk.a static_gtk/libgdk.a static_gtk/libgmodule.a static_gtk/libglib.a -L/usr/lib -L/usr/X11R6/lib -rdynamic -ldl -lXi -lXext -lX11 -lm

all: replay

distall: replay-sgtk replay-dgtk

clean:
	$(RM) $(OBJ) replay core *~
distclean: clean
	$(RM) config.log config.cache config.status config.h Makefile

replay: $(OBJ) 
	$(CC) -o replay $(OBJ) $(LDFLAGS) $(LIBS) 
	strip replay

replay-dgtk: $(OBJ) 
	$(CC) -o replay-dgtk $(OBJ) $(LDFLAGS) $(LIBS) 
	strip replay-dgtk

replay-sgtk: $(OBJ) 
	$(CC) -o replay-sgtk $(OBJ) $(LDFLAGS) $(SLIBS) 
	strip replay-sgtk

.c.o:
	$(CC) -c $(CFLAGS) $< 

.c.s:
	$(CC) -S $(CFLAGS) $< 

install:
	$(CP) ./replay $(DESTDIR)/usr/X11R6/bin

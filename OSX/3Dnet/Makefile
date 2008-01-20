# $Id: //personal/projekt/OSX/Human/Makefile#3 $
# $DateTime: 2005/08/07 08:27:11 $
# $Author: jb $

SOURCES = main.cpp network.cpp link.cpp node.cpp statsreader.cpp

CXXFLAGS = -ansi -g -Wall -Werror -pedantic -DOS_${OS} -O2
LINUX_LIBS = -L/usr/X11R6/lib -lX11 -lXext -lGL -lGLU -lglut
DARWIN_LIBS = -framework OpenGL -framework GLUT

objs := $(SOURCES:.cpp=.o)
os := $(shell uname -s  | awk '{print tolower($$0)}')
OS := $(shell uname -s  | awk '{print toupper($$0)}')
arch := $(shell arch)
platformtarget := 3net.$(os)-$(arch)

all: $(platformtarget) 

$(platformtarget): $(objs)
	g++ $^ $($(OS)_LIBS) -o $@

clean:
	rm -f *.o ${platformtarget} .depend



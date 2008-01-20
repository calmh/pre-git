CLASS = Go.class Board.class AI.class UI.class Move.class Common.class
TARGET = go.jar

all: ${TARGET}

.SUFFIXES: .class .java

${TARGET}: ${CLASS}
	jar cmf Go.manifest ${TARGET} *.class

.java.class:
	javac -O ${.IMPSRC}

clean:
	rm -f *.class *~ go.jar


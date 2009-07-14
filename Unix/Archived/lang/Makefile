OBJS=antlr/LangLexer.o antlr/LangParser.o main.o printer.o symboltable.o

all: lang

lang: ${OBJS}
	g++ -s $^ -lantlr -olang

antlr/LangLexer.cpp antlr/LangParser.cpp: lang.g
	java antlr.Tool -o antlr $<

clean:
	rm -f *.o *~ antlr/*.* lang

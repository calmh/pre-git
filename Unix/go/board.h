// -*- C++ -*-

#include <list>

class Board {
	unsigned size;
	unsigned char* board;
	list<Move> moves;
	
public:
	Board(unsigned size);
}

#include <assert.h>
#include <map>
#include <vector>
#include <antlr/CommonAST.hpp>

class SymbolTable {
	typedef map<string, antlr::RefAST> symbolmap_t;
	typedef vector<symbolmap_t> symboltable_t;

 private:
	symboltable_t table;
	int level;

 public:
	SymbolTable();
	
	void dump();
	void add(string, antlr::RefAST);
	antlr::RefAST lookup(string);
	void enter_block();
	void leave_block();
};

#include "symboltable.h"

SymbolTable::SymbolTable()
{
	level = 0;
}

void SymbolTable::dump()
{
	symboltable_t::const_iterator ti = table.begin();
	symboltable_t::const_iterator te = table.end();

	int l = 0;
	while (ti != te) {
			symbolmap_t::const_iterator mi = ti->begin();
			symbolmap_t::const_iterator me = ti->end();

			while (mi != me) {
				for (int i = 0; i < l; i++)
					cout << "  ";
				cout << mi->first << " -> "
				     << mi->second << endl;
				mi++;
			}
			l++;
			ti++;
	}
}

void SymbolTable::add(string sym, antlr::RefAST ast)
{
	assert(level > 0);
	table.back()[sym] = ast;
}

void SymbolTable::enter_block()
{
	table.push_back(symbolmap_t());
	level++;
}

void SymbolTable::leave_block()
{
	assert(level > 0);
	
	table.pop_back();
	level--;
}

antlr::RefAST SymbolTable::lookup(string sym)
{
	assert(level > 0);

	symboltable_t::iterator ti = table.begin();
	symboltable_t::iterator te = table.end();
	te--;
	
	do {
		if ((*te)[sym] != 0)
			return (*te)[sym];
	} while(te-- != ti);

	return 0;
}

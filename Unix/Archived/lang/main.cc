#include <antlr/AST.hpp>
#include <antlr/CommonAST.hpp>

#include "antlr/LangLexer.hpp"
#include "antlr/LangParser.hpp"
using namespace antlr;

#include "symboltable.h"
#include "printer.h"

int main() {
  	LangLexer* l = new LangLexer(cin);
  	LangParser* p = new LangParser(*l);
  	p->lines();

  	RefAST t = p->getAST();
  	Printer::recurse(t);

	return 0;
}

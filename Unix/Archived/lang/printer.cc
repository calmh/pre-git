#include "printer.h"

namespace Printer {
	void recurse(const antlr::RefAST r0, int l = 0) {
		if (r0) {
			indent(l);
			cout << r0->getType() << ":" << r0->toString() << endl;
			
			recurse(r0->getFirstChild(), l+1);
			recurse(r0->getNextSibling(), l);
		}
	}
	
	void indent(int l) {
		while (l-- > 0)
			cout << " ";
	}
}


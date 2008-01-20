/*
  Copyright (c) 2000   Jakob Borg
  
  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.
  
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  
  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/
    
/** @author Jakob Borg <jborg@df.lth.se>
 ** @version $Revision: 1.1.1.1 $
 **/

#include <iostream>
#include <fstream>
#include <string>
#include <ctime>
#include <cstdlib>

#include "stddefs.h"

#define DEBUG(x) x

typedef struct {
	unsigned id;
	char label[128];
	char reserved[1024 - 128 - sizeof(unsigned)];
} tapelabel;

class Label {
public:
	tapelabel thelabel;

	Label();
	Label(char *label);
	void setLabel(char *label) { strcpy(thelabel.label, label); };
	const char *getLabel() const { return thelabel.label; };
	int get(char *device);
	int set(char *device);
};

Label::Label() {
	thelabel.id = time(0);
};

Label::Label(char *label) {
	thelabel.id = time(0);
	strcpy(thelabel.label, label);
};

int Label::get(char *device) {
	std::ifstream tape(device);
	tape.read(&thelabel, 1024);
	
	if (tape.good())
		return 1;
	else
		return 0;
}

int Label::set(char *device) {
	std::ofstream tape(device);
	tape.write(&thelabel, 1024);
	
	if (tape.good())
		return 1;
	else
		return 0;		
}

int main (int argc, char *argv[]) {
	Label *label = new Label();

	if (argc < 2) {
		cout << "usage: label <device> [-v label]" << endl;
		return 0;
	}

	if (argc > 2 && !strcmp(argv[2], "-v")) {
		label->setLabel(argv[3]);
		if (argc == 5)
			label->thelabel.id = atoi(argv[4]);
		if (label->set(argv[1])) {
			cout << "OK\n";
		}
		else
			cout << "FAIL\n";
	} else {
 		if (label->get(argv[1])){
			cout << "ID=" << label->thelabel.id << " LABEL=\"" << label->thelabel.label << "\"\n";
		} else
			cout << "FAIL\n";
	}
}

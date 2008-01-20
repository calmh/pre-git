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

#include <time.h>
#include <list>
#include <string>
#include <iostream>
#include <string>
using namespace std;

#include "stddefs.h"
#include "indexer.h"
#include "reader.h"
#include "file.h"
#include "reporter.h"

/// Where it all takes place
int main(int argc, char *argv[]) {
	if (argc < 2) {
		cout << "usage: lschunks <volume-name>" << endl << endl;
		Reporter::list_volumes();
		
		return -1;
	}

	list<ChunkHeader> headers;
	try {
		headers = Indexer::read_headers(INDEX_DIR + argv[1] + ".idx");
	} catch (...) {
		cout << "No such volume." << endl;
		return -1;
	}

	if (headers.size() == 0) {
		cout << "No chunks on volume." << endl;
		return 0;
	}
	
	for (list<ChunkHeader>::iterator i = headers.begin(); i != headers.end(); i++) {
		time_t t = i->get_date();
		cout << "chunk " << i->get_chunk() << ": volume " << i->get_volume() << ", tape " << i->get_tape() << ", " << i->get_nfiles() << " files, " << i->get_size() / 1024 << " Mbytes, " << ctime(&t);
	}
}


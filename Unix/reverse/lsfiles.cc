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
using namespace std;

#include "stddefs.h"
#include "indexer.h"
#include "reader.h"
#include "file.h"
#include "reporter.h"

/// Where it all takes place
int main(int argc, char *argv[]) {
	if (argc < 2) {
		cout << "usage: lsfiles <volume-name> [<filespec>]" << endl << endl;
		Reporter::list_volumes();
		
		return -1;
	}

	list<ChunkHeader> headers;
	list<File> files;
	try {
		headers = Indexer::read_headers(INDEX_DIR + argv[1] + ".idx");
		files = Indexer::read_index(INDEX_DIR + argv[1] + ".idx");
	} catch (...) {
		cout << "No such volume." << endl;
		return -1;
	}

	if (headers.size() == 0) {
		cout << "No chunks on volume." << endl;
		return 0;
	}
	
	list<ChunkHeader>::iterator j = headers.begin();
	int chunk = 1, n = 1, lim;
	string volume;
	lim = j->get_nfiles();
	volume = j->get_volume();
	for (list<File>::iterator i = files.begin(); i != files.end(); i++, n++) {
		if (argv[2] == 0 || i->get_name().find(argv[2]) != string::npos)
			cout << volume << ":" << i->get_name() << ", chunk " << chunk << ", modified " << ctime(&(i->get_info().st_mtime));
		if (n == lim) {
			j++;
			if (j == headers.end())
				break;
			n = 0;
			lim = j->get_nfiles();
			volume = j->get_volume();
			chunk = j->get_chunk();
		}
	}

}


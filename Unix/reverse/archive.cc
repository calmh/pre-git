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

#include <list>
#include <string>
#include <iostream>
#include <fstream>
using namespace std;

#include "stddefs.h"
#include "indexer.h"
#include "writer.h"
#include "reader.h"
#include "file.h"

const string tape_dev = "/dev/tape";
	
/// Where it all takes place
int main(int argc, char *argv[]) {
	string dir;
	
	if (argc < 2 || argc > 3) {
		cout << "usage: archive <directory>" << endl;
		return -1;
	} else
		dir = argv[1];

	
	try {
		Reader r(dir);
		list<File> files = r.get_files();

		Writer w("<archive>", tape_dev);
		cout << "Writer for " << w.get_volume() << " attached to tape " << w.get_dest() << endl;

		string index_name = INDEX_DIR + w.get_dest() + ".idx";
		try {
			list<File> old;
			old = Indexer::read_index(index_name);
			files = Indexer::candidates(old, files);
		} catch (...) {
			cout << "There was no old index " << index_name << "." << endl;			
			index_name = "none";
		}
				
		unsigned long tsize = Indexer::size(files)/1024;
		cout << "Going to save " << files.size() << " files, "
		     << tsize << " Mbytes, estimate " << tsize /
			(Writer::get_chunk_size() / 1024) + 1
		     << " chunks." << endl;

		if (index_name != "none") {
			cout << "Winding to end of tape." << endl;
			w.eom();
		}

		w.save(files);
		while (!w.sync());
		
	} catch (Writer::InitError) {
		cout << "There was an error opening the tape device, or the tape was not recognized." << endl
		     << "Please label this tape before using." << endl;
		return -1;
	} catch (Writer::WriteError) {
		cout << "There was an error writing to the tape. Make sure the tape is not broken or write-protected." << endl;
		return -1;
	} catch (...) {
		cout << "An unknown exception occurred during processing." << endl;
		return -1;
	}
	
	return 0;
}

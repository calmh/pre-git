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
#include "reporter.h"

int get_conf(string, list<string>&, list<string>&);
int tape_type(string);

/// Where it all takes place
int main(int argc, char *argv[]) {
	string volume;
	
	if (argc < 2 || argc > 3) {
		cout << "usage: save <volume>" << endl;
		return -1;
	} else
		volume = argv[1];

	list<string> startdirs;
	list<string> prune;

	if (get_conf(volume, startdirs, prune) != 0)
		return -1;
	
	try {
		Writer w(volume, TAPE_DEV);
		cout << "Writer for " << w.get_volume() << " attached to tape " << w.get_dest() << endl;
		if (tape_type(w.get_dest()) != 0)
			return -1;
		
		list<File> files;
		for (list<string>::iterator i = startdirs.begin(); i != startdirs.end(); i++) {
			IFDEBUG(cout << "Getting files from a root... " << endl);
			Reader r(*i);
		 	list<File> tmp = r.get_files();
			IFDEBUG(cout << "\t read files: " << Reporter::get_RSS() << " Kbytes." << endl);
			files.splice(files.end(), tmp);
			IFDEBUG(cout << "\t spliced files: " << Reporter::get_RSS() << " Kbytes." << endl);
			tmp.clear();
			IFDEBUG(cout << "\t cleared tmp: " << Reporter::get_RSS() << " Kbytes." << endl);
		}

		string index_name = INDEX_DIR + w.get_dest() + ".idx";
		try {
			IFDEBUG(cout << "Reading old index... " << endl);
			list<File> old;
			old = Indexer::read_index(index_name);
			IFDEBUG(cout << "\tread index: " << Reporter::get_RSS() << " Kbytes." << endl);
			files = Indexer::candidates(old, files);
			IFDEBUG(cout << "\tran candidates: " << Reporter::get_RSS() << " Kbytes." << endl);
			old.clear();
			IFDEBUG(cout << "\tcleared old: " << Reporter::get_RSS() << " Kbytes." << endl);
		} catch (...) {
			cout << "There was no old index " << index_name << "." << endl;			
			index_name = "none";
		}
				
		IFDEBUG(cout << "Pruning files... " << endl);
		for (list<string>::iterator i = prune.begin(); i != prune.end(); i++) {
//			IFDEBUG(cout << "\tpruning: " << Reporter::get_RSS() << " Kbytes." << endl);
//  			list<File> tmp = Indexer::prune(files, *i);
//  			files.clear();
//  			files = tmp;
//  			tmp.clear();
			files  = Indexer::prune(files, *i);
		}
		IFDEBUG(cout << "\tdone pruning: " << Reporter::get_RSS() << " Kbytes." << endl);
		
		unsigned long tsize = Indexer::size(files)/1024;
		cout << "Going to save " << files.size() << " files, "
		     << tsize << " Mbytes, estimate " << tsize /
			(Writer::get_chunk_size() / 1024) + 1
		     << " chunks." << endl;

		IFDEBUG(cout << "Handing files to writer... " << Reporter::get_RSS() << " Kbytes." << endl);
		w.save(files);
		IFDEBUG(cout << "clear()ing files... " << Reporter::get_RSS() << " Kbytes." << endl);
		files.clear();
		
		IFDEBUG(cout << "Starting writer... " << Reporter::get_RSS() << " Kbytes." << endl);

		if (index_name != "none") {
			list<ChunkHeader> headers;
			int n;
			try {
				headers = Indexer::read_headers(INDEX_DIR + w.get_dest() + ".idx");
				if (headers.size())
					n = headers.back().get_chunk() + 1;
				else
					n = 1;
			} catch (...) {
				cout << "Unexpected error while reading chunk headers." << endl;
				n = 1;
			}

			if (n < 1)
				n = 1;
			cout << "Starting new chunk " << n << "." << endl;
			w.wind_to(n+1);
		}
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

int get_conf(string volume, list<string>& startdirs, list<string>& prune)
{
	char root[80];
	ifstream conf((CONFIG_DIR + volume + ".root").c_str());
	conf.getline(root, 79);
	if (!conf.good()) {
		cout << "Couldn't open " << CONFIG_DIR << volume << ".root." << endl;
		return -1;
	}
	conf.close();
	if (chdir(root) != 0) {
		cout << "Couldn't change root to " << root << endl;
		return -1;
	}
	
	conf.open((CONFIG_DIR + volume + ".startdir").c_str());
	if (!conf.good()) {
		cout << "Couldn't open " << CONFIG_DIR << volume << ".startdir." << endl;
		return -1;
	}
	while (!conf.eof() && conf.good()) {
		char foo[80];
		conf.getline(foo, 79);
		string bar = foo;
		unsigned p = bar.find("#");
		if (p != string::npos)
			bar = bar.substr(0, p);
		if (bar.length() != 0)
			startdirs.push_back(bar);
	}
	conf.close();

	conf.open((CONFIG_DIR + volume + ".prune").c_str());
	if (!conf.good()) {
		cout << "Couldn't open " << CONFIG_DIR << volume << ".prune." << endl;
		return -1;
	}
	while (!conf.eof() && conf.good()) {
		char foo[80];
		conf.getline(foo, 79);
		string bar = foo;
		unsigned p = bar.find("#");
		if (p != string::npos)
			bar = bar.substr(0, p);
		if (bar.length() != 0)
			prune.push_back(bar);
	}
	conf.close();

	return 0;
}

int tape_type(string volume)
{
	list<string> volumes;
	ifstream conf((CONFIG_DIR + "volumes").c_str());
	if (!conf.good()) {
		cout << "Couldn't open " << CONFIG_DIR << "volumes" << endl;
		return -1;
	}
	while (!conf.eof() && conf.good()) {
		char foo[80];
		conf.getline(foo, 79);
		string bar = foo;
		unsigned p = bar.find("#");
		if (p != string::npos)
			bar = bar.substr(0, p);
		if (bar.length() != 0)
			volumes.push_back(bar);
	}
	conf.close();

	for (list<string>::iterator i = volumes.begin(); i != volumes.end(); i++) {
		if (i->find(volume) == 0 || i->find("*") == 0) {
			if (i->find("/backup") != string::npos) {
				cout << volume << " is a backup tape." << endl;
				break;
			} else if (i->find("/archive") != string::npos) {
				cout << volume << " is an archive tape." << endl;
				return -1;
			} else if (i->find("/read-only") != string::npos) {
				cout << volume << " is a read-only tape." << endl;
				return -1;
			}				
		}
	}

	return 0;
}

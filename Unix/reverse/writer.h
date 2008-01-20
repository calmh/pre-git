// -*- c++ -*-

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

#ifndef __writer_h
#define __writer_h

#include <string>
#include <list>
using namespace std;

#include "file.h"

typedef struct {
	unsigned id;
	char label[128];
	char reserved[1024 - 128 - sizeof(unsigned)];
} tapelabel;

/// Writes files to a store of some kind
class Writer {
private:
	string dest;
	list<File> files;
	static const int chunk_size = 100 * 1024;
	tapelabel label;
	int chunk_idx;
	string volume;
	
public:
	/** Konstruerar writern
	 ** @param destination Where to write stuff
	 **/
	Writer(string vol, string destination);

	/** Mark a file for saving
	 ** @param f The file
	 **/
	void save(File&);

	/** Mark a list of files for saving
	 ** @param l The list
	 **/
	void save(list<File>&);

	/** Sync
	 **/
	bool sync();

	string get_volume();
	string get_dest();
	void eom();
	void wind_to(int);
	static unsigned get_chunk_size();

	class InitError {};
	class WriteError {};
};

#endif

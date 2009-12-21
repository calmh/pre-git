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

#ifndef __chunkheader_h
#define __chunkheader_h

#include <sys/types.h>
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fstream>
#include <time.h>
#include <string>
using namespace std;

/// Represents a file object
class ChunkHeader {
 private:
	string volume;
	string tape;
	time_t date;
	unsigned long size;
	unsigned long nfiles;
	int chunk;
	
 public:
	/** Contruct a new file
	 ** @param name The name of the file
	 **/
	ChunkHeader();
	ChunkHeader(string, string, unsigned long, unsigned long, int);

	string get_volume() const;
	string get_tape() const;
	time_t get_date() const;
	unsigned long get_size() const;
	unsigned long get_nfiles() const;
	int get_chunk() const;
	void write_to(ofstream&) const;
	int read_from(ifstream&);
};

#endif

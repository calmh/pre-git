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

#ifndef __file_h
#define __file_h

#include <sys/types.h>
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fstream>

#include <string>
using namespace std;

/// Represents a file object
class File {
 private:
	string name;
	struct stat info;
	
 public:
	/** Contruct a new file
	 ** @param name The name of the file
	 **/
	File(string);
	File();

	/** Read the contents of the file
	 ** @return The contents of the file
	 **/
	char *read();

	/** Read the name of the file
	 ** @return The name of the file
	 **/
	string get_name() const;

	bool File::is_dir();
	bool File::is_file();

	void request_info();
	struct stat get_info() const;
	void write_to(ofstream&) const;
	int read_from(ifstream&);
	bool File::operator==(File& f);
	bool File::operator<(File& f);
};

#endif

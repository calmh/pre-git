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

#ifndef __reader_h
#define __reader_h

#include <string>
#include <list>
using namespace std;

#include "file.h"

/// Reads files & file lists from a source
class Reader {
 private:
	/// The root of the Reader
	string root;
	
	/** Get a list of all files under 'dir'
	 ** @param dir The directory to list
	 ** @return List of all the files
	 **/
	list<File> get_files(File dir);

 public:
	/** Contruct the Reader
	 ** @param root The root of the Reader
	 **/
	Reader(string root);

	/** Get a list of all files under the root
	 ** @return List of all the files
	 **/
	list<File> get_files();
};

#endif

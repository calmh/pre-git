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

#ifndef __indexer_h
#define __indexer_h

#include "chunkheader.h"
#include "file.h"

/// Keeps track of files
class Indexer {
public:
	static void create_index(const ChunkHeader&, const string);
	static void append_index(const list<File>&, const string);
	static void append_index(const ChunkHeader&, const string);
	static list<File> read_index(string);
	static list<ChunkHeader> Indexer::read_headers(string name);
	static list<File> Indexer::candidates(list<File>& l1, list<File>& l2);
	static unsigned long size(list<File>&);
	static list<File> prune(list<File>& files, string spec);
};

#endif

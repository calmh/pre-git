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

#include <fstream>
#include <iostream>
#include <list>
#include <map>
using namespace std;

#include "indexer.h"

void Indexer::create_index(const ChunkHeader& h, const string name)
{
	ofstream outf(name.c_str());
	h.write_to(outf);
	outf.close();
}

void Indexer::append_index(const list<File>& li, const string name)
{
	ofstream outf(name.c_str(), ios::app);
	for (list<File>::const_iterator i = li.begin(); i != li.end(); i++)
		i->write_to(outf);
	outf.close();
}

void Indexer::append_index(const ChunkHeader& h, const string name)
{
	ofstream outf(name.c_str(), ios::app);
	h.write_to(outf);
	outf.close();
}

list<File> Indexer::read_index(string name)
{
	list<File> read;
	ifstream inf(name.c_str());
	if (!inf.good())
		throw "Woops!";
	while (!inf.eof()) {
		File *f = new File();
		if (f->read_from(inf) == 1)
			read.push_back(*f);
	}
	inf.close();

	return read;
}

list<ChunkHeader> Indexer::read_headers(string name)
{
	list<ChunkHeader> read;
	ifstream inf(name.c_str());
	if (!inf.good())
		throw "Woops!";
	while (!inf.eof()) {
		ChunkHeader *f = new ChunkHeader();
		if (f->read_from(inf) == 1) {
			read.push_back(*f);
		}
	}
	inf.close();

	return read;
}

list<File> Indexer::candidates(list<File>& l1, list<File>& l2)
{
	map<string, File*> tmp;
	list<File> cands;
	
	for (list<File>::iterator i = l1.begin(); i != l1.end(); i++)
		tmp[i->get_name()] = &(*i);
		
	for (list<File>::iterator i = l2.begin(); i != l2.end(); i++)
		if (tmp[i->get_name()] == 0 || !(*(tmp[i->get_name()]) == *i))
			cands.push_back(*i);

	return cands;
}

unsigned long Indexer::size(list<File>& files)
{
	unsigned long size = 0;
	for (list<File>::iterator i = files.begin(); i != files.end(); i++)
		size += i->get_info().st_size / 1024;

	return size;
}

list<File> Indexer::prune(list<File>& files, string spec)
{
	list<File> newlist;
	
	for (list<File>::iterator i = files.begin(); i != files.end(); i++)
		if (i->get_name().find(spec) == string::npos)
			newlist.push_back(*i);
	
	return newlist;
}

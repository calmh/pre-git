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

#include "chunkheader.h"

ChunkHeader::ChunkHeader(string v, string t, unsigned long n, unsigned long s, int c)
{
	volume = v;
	tape = t;
	date = time(0);
	nfiles = n;
	size = s;
	chunk = c;
}

ChunkHeader::ChunkHeader()
{
}

string ChunkHeader::get_volume() const
{
	return volume;
}

string ChunkHeader::get_tape() const
{
	return tape;
}

time_t ChunkHeader::get_date() const
{
	return date;
}

unsigned long ChunkHeader::get_size() const
{
	return size;
}

unsigned long ChunkHeader::get_nfiles() const
{
	return nfiles;
}

int ChunkHeader::get_chunk() const
{
	return chunk;
}

void ChunkHeader::write_to(ofstream& file) const
{
	int l = 2;
	file.write(&l, sizeof(l));

	l = volume.length();
	file.write(&l, sizeof(l));
	file.write(volume.c_str(), l + 1);

	l = tape.length();
	file.write(&l, sizeof(l));
	file.write(tape.c_str(), l + 1);

	file.write(&date, sizeof(time_t));
	file.write(&size, sizeof(size));
	file.write(&nfiles, sizeof(nfiles));
	file.write(&chunk, sizeof(chunk));
}

int ChunkHeader::read_from(ifstream& file)
{
	int l = 0;
	file.read(&l, sizeof(l));
	if (l == 0)
		return 2;		
	else if (l == 2) {
		file.read(&l, sizeof(l));
		char *n = new char[l + 1];
		file.read(n, l + 1);
		volume = n;
		
		file.read(&l, sizeof(l));
		n = new char[l + 1];
		file.read(n, l + 1);
		tape = n;
		
		file.read(&date, sizeof(time_t));
		file.read(&size, sizeof(size));
		file.read(&nfiles, sizeof(nfiles));
		file.read(&chunk, sizeof(chunk));
		return (file.good() ? 1 : 0);
	} else {
		file.read(&l, sizeof(l));
		char *n = new char[l + 1];

		file.read(n, l + 1);

		struct stat foo;
		file.read(&foo, sizeof(struct stat));
		return 2;
	}
}

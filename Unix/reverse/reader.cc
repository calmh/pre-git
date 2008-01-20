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

#include <sys/types.h>
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>
#include <iostream>

#include "reader.h"

Reader::Reader(string root)
{
	this->root = root;
}

list<File> Reader::get_files()
{
	return get_files(File(root));
}

list<File> Reader::get_files(File dir)
{
	DIR *d;
	d = opendir(dir.get_name().c_str());
	if (d == 0) {
		list<File> foo;
		return foo;
	}
	struct dirent *entry;
	entry = readdir(d);
	list<File> l;
	
	while (entry != 0) {
		File f(dir.get_name() + "/" + entry->d_name);
		string n = f.get_name();
		if (n.substr(n.length() - 2) != "/." && n.substr(n.length() - 3) != "/..") {
			if (f.is_dir() && f.get_info().st_dev == dir.get_info().st_dev) {
				l.push_back(f);
				list<File> l2 = get_files(f);
				l.splice(l.end(), l2);
			} else {
				l.push_back(f);
			}
		}
		entry = readdir(d);
	}
	closedir(d);
	return l;
}

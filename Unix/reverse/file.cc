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
#include <fstream>

#include "file.h"

File::File(string name)
{
	this->name = name;
	request_info();
}

File::File()
{
	this->name = "";
}

string File::get_name() const
{
	return name;
}

bool File::is_dir() {
	struct stat s;
	lstat(name.c_str(), &s);

	return (S_ISDIR(s.st_mode) && !S_ISLNK(s.st_mode));
}

bool File::is_file() {
	struct stat s;
	stat(name.c_str(), &s);
	
	return S_ISREG(s.st_mode);
}

void File::request_info()
{
	stat(name.c_str(), &info);
}

struct stat File::get_info() const
{
	return info;
}

void File::write_to(ofstream& file) const
{
	int l = 1;
	file.write(&l, sizeof(l));

	l = name.length();
	file.write(&l, sizeof(l));
	file.write(name.c_str(), l + 1);

	file.write(&info, sizeof(struct stat));
}

int File::read_from(ifstream& file)
{
	int l = 0;
	file.read(&l, sizeof(l));

	if (l == 0)
		return 2;		
	else if (l == 1) {
		file.read(&l, sizeof(l));
		char *n = new char[l + 1];
		file.read(n, l + 1);
		name = n;

		file.read(&info, sizeof(info));

		return (file.good() ? 1 : 0);
	} else {
		file.read(&l, sizeof(l));
		char *n = new char[l + 1];
		file.read(n, l + 1);

		file.read(&l, sizeof(l));
		n = new char[l + 1];
		file.read(n, l + 1);

		time_t t;
		file.read(&t, sizeof(t));
		unsigned long foo;
		file.read(&foo, sizeof(foo));
		file.read(&foo, sizeof(foo));
		file.read(&foo, sizeof(int));
		
		return 2;
	}
}

bool File::operator==(File& f)
{
	return ((info.st_dev == f.get_info().st_dev) &&
		(info.st_ino == f.get_info().st_ino) &&
		(info.st_mode == f.get_info().st_mode) &&
		(info.st_uid == f.get_info().st_uid) &&
		(info.st_gid == f.get_info().st_gid) &&
		(info.st_size == f.get_info().st_size) &&
		(info.st_mtime == f.get_info().st_mtime) &&
		(info.st_ctime == f.get_info().st_ctime));
}

bool File::operator<(File& f)
{
	return name < f.get_name();
}


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

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <time.h>

#include "reporter.h"
#include "stddefs.h"
#include "reader.h"
#include "file.h"

unsigned Reporter::get_RSS() {
	char buffer[80];
	ifstream status("/proc/self/status");
	for (int i = 0; i < 12; i++) // loop to VmRSS line
		status.getline(buffer, 79);
	status.close();

	unsigned offs = string(buffer).find_first_of("0123456789");
	if (offs != string::npos)
		return atoi(string(buffer).substr(offs).c_str());
	else
		return (unsigned) -1;
}

void Reporter::list_volumes() {
	Reader vols(INDEX_DIR);
	list<File> l = vols.get_files();
	l.sort();
	cout << "Available volumes are:" << endl;
	for (list<File>::iterator i = l.begin(); i != l.end(); i++) {
		string n = i->get_name();
		struct stat s = i->get_info();
		struct tm* t = localtime(&s.st_mtime);
		n = n.substr(n.find_last_of("/") + 1);
		n = n.substr(0, n.length() - 4);
		if (s.st_size)
			cout << "\t" << n << " (last modified " << t->tm_mday << "/" << t->tm_mon << " " << t->tm_year + 1900 << ", "  <<  t->tm_hour << ":" << t->tm_min << ")" << endl;
		else
			cout << "\t" << n << " (empty)" << endl;
	}	
}

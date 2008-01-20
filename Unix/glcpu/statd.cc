/** Copyright (c) 2000 Jakob Borg
 **
 ** This file implements a small daemon to be run from inetd.
 **
 ** This program is free software; you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation; either version 2 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program; if not, write to the Free Software
 ** Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 **
 ** $Id: statd.cc,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
 **/

#include <unistd.h>
#include <iostream>
#include <string>
#include <vector>
using namespace std;

int NCPU = 1;
extern const int HISTORY = 20;

extern vector<int>* get_cpu_percent();

/**
 ** When user says DATA, return an array of bytes of the form <n> n*<data>,
 ** that is first the number of data streams, then the raw data.
 ** This data is then smoothed by glcpu before plotting.
 **/

int main()
{
	while (true && cin.good()) {
                // if user disconnects w/o saying QUIT, we will get !cin.good()
		vector<int>* data = get_cpu_percent();
		string foo;
		cin >> foo;
		if (foo == "DATA") {
			cout << data->size() << " ";
			for (unsigned i = 0; i < data->size(); i++) {
				cout << (*data)[i] << " ";
			}
			cout << endl;
		} else if (foo == "QUIT")
			return 0;
		else
			cout << foo << "?" << endl;
	}
	return 0;
}

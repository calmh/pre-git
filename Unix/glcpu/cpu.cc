/** Copyright (c) 2000 Jakob Borg
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
 ** $Id: cpu.cc,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
 **/

#include <fstream>
#include <string>
#include <vector>
#include <assert.h>
using namespace std;

extern int HISTORY;
extern int NCPU;

/**
 ** Get CPU usage in % since last call.
 ** Slightly ugly.
 **/

vector<int>* get_cpu_percent()
{
#ifdef OS_Linux
	static int *tempcpu = new int[(NCPU+1)*4];
	static int *oldcpu = new int[(NCPU+1)*4];
	int cpu[(NCPU+1) * 4];
	string foo;
	static vector<int>* data = new vector<int>;
	data->clear();
	
	ifstream stat("/proc/stat");
	for (int i = 0; i < ((NCPU > 1) ? NCPU + 1 : 1); i++)
		stat >> foo >> tempcpu[i* 4 + 0] >> tempcpu[i* 4 + 1] >> tempcpu[i* 4 + 2] >> tempcpu[i* 4 + 3];
	stat.close();

	for (int i = (NCPU > 1) ? 1 : 0; i < ((NCPU > 1) ? NCPU + 1 : 1); i++) {
		for (int j = 0; j < 4; j++) {
			cpu[i* 4 + j] = tempcpu[i* 4 + j] - oldcpu[i* 4 + j];
			oldcpu[i* 4 + j] = tempcpu[i* 4 + j];
		}
	}
	for (int i = (NCPU > 1) ? 1 : 0; i < ((NCPU > 1) ? NCPU + 1 : 1); i++) {
		int use = (cpu[i* 4 + 0] + cpu[i* 4 + 1] + cpu[i* 4 + 2]);
		int total = (cpu[i* 4 + 0] + cpu[i* 4 + 1] + cpu[i* 4 + 2] + cpu[i* 4 + 3]);		
		if (total != 0) {
			double p = use / total;
			assert(p >= 0);
			// HISTORY is also the granularity
			data->push_back((int) (HISTORY * p));
		} else
			data->push_back(0);
	}
	
	return data;
#else
	return 0;
#endif
}

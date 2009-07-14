/** (c) 2000 Jakob Borg
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
 ** $Id: keeperobj.h,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
 **/

#ifndef __keeperobj_h
#define __keeperobj_h

#include <string>

class KeeperObj {
 private:
	char* data;
	int size;
	string type;
	string description;
	int priv_level;
	int id;

 public:
	KeeperObj(string, int);
	~KeeperObj();
	KeeperObj(const KeeperObj&);
	KeeperObj& operator=(const KeeperObj&)
		throw (not_init);

	void import(string)
		throw (bad_state, io_error, not_init);
	void set_description(string);
	void set_data(char*, int, string, int);
	
	string get_description() const
		throw (not_init);
	char* get_data() const
		throw (not_init);
	int get_size() const
		throw (not_init);
	int get_priv_level() const
		throw (not_init);
	string get_type() const
		throw (not_init);
	int get_id() const
		throw (not_init);
	void save() const
		throw (not_init, io_error);
};

#endif

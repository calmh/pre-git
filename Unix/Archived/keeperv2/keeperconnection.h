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
 ** $Id: keeperconnection.h,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
 **/

#ifndef __keeperconnection_h
#define __keeperconnection_h

#include <string>
#include <list>
#include <libpq-fe.h>
#include <libpq/libpq-fs.h>

#include "keeperobj.h"

class KeeperConnection {
 private:
	string pghost;
	string pgport;
	string pgoptions;
	string pgtty;
	string db_name;
	string user;
	string password;
	PGconn* connection;
	int priv_level;

 public:
	KeeperConnection(string, string, string, string, string)
		throw (auth_system);
	~KeeperConnection()
		throw (db_error);
	int login(string, string)
		throw (not_connected, auth_user, db_error);
	list<KeeperObj>* KeeperConnection::query_description(string)
		throw (not_connected, db_error);
	list<KeeperObj>* KeeperConnection::query_id(int)
		throw (not_connected, db_error);
	void store(const KeeperObj&)
		throw (not_connected, db_error, auth_user);
	KeeperObj& retrieve(int)
		throw (not_connected, db_error, auth_user);
	void remove(int)
		throw (not_connected, db_error);
	int get_num_objects()
		throw (not_connected, db_error);
	void purge()
		throw (not_connected, db_error);
	bool set_priv_level(int);
	int get_priv_level() const
		throw (not_init);
};

#endif

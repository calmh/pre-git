/** (c) 2000 Jakob Borg
 **
 ** This file implements the database connection abstraction
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
 ** $Id: keeperconnection.cc,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
 **/

#include <assert.h>
#include <cstdlib>
#include <iostream>
#include <list>

#include "keeper.h"
#include "keeperobj.h"
#include "keeperconnection.h"

/**
 ** Initialize a KeeperConnection, including setting up the connection to the
 ** database backend. Throw a auth_system exception if this fails.
 **/

KeeperConnection::KeeperConnection(string ipghost, string ipgport,
				   string idb_name, string iuser,
				   string ipassword)
	throw (auth_system)
{
	pghost = ipghost;
	pgport = ipgport;
	db_name = idb_name;
	user = iuser;
	password = ipassword;

	pgoptions = "";
	pgtty = "";
	
	connection = PQsetdbLogin(pghost.c_str(), pgport.c_str(),
				  pgoptions.c_str(), pgtty.c_str(),
				  db_name.c_str(), user.c_str(),
				  password.c_str());

	Assert<auth_system>(PQstatus(connection) == CONNECTION_OK, "Could not connect to database backend; authorization failure?\n" + string(PQerrorMessage(connection)));
}

/**
 ** Destroy the connection
 **/

KeeperConnection::~KeeperConnection()
	throw (db_error)
{
	if (PQstatus(connection) == CONNECTION_OK)
		PQfinish(connection);

	assert(db_error, PQstatus(connection) != CONNECTION_OK);
}

/**
 ** Attempt a user login, returning the privilege level for that user if the
 ** login succeeds. In case of failure, throw auth_user.
 **/

int KeeperConnection::login(string vuser, string vpassword)
	throw (not_connected, auth_user, db_error)
{
	assert(not_connected, PQstatus(connection) == CONNECTION_OK);
	
	// begin a transaction block
	PGresult* res = PQexec(connection, "BEGIN");
	assert(db_error, res && PQresultStatus(res) == PGRES_COMMAND_OK);
 	PQclear(res);

	// declare the cursor for our select
 	res = PQexec(connection, ("DECLARE mycursor CURSOR FOR select priv_level from users where name='" + vuser + "' and password='" + vpassword + "'").c_str());
	assert(db_error, res && PQresultStatus(res) == PGRES_COMMAND_OK);
 	PQclear(res);

	// fetch all rows mathing
 	res = PQexec(connection, "FETCH ALL in mycursor");
	assert(db_error, res && PQresultStatus(res) == PGRES_TUPLES_OK);
 	PQclear(res);

	// 0 means no such user/password combo found
	Assert<auth_user>(PQntuples(res) != 0, "Wrong username or password.");

	// get the users priv_level
	priv_level = atoi(PQgetvalue(res, 0, 0));

 	// close the cursor
 	res = PQexec(connection, "CLOSE mycursor");
	assert(db_error, res);
 	PQclear(res);
	
	// commit the transaction
 	res = PQexec(connection, "COMMIT");
	assert(db_error, res);
 	PQclear(res);

	Assert<auth_user>(priv_level >= 0, "Wrong username or password.");
	assert(not_connected, PQstatus(connection) == CONNECTION_OK);

	return priv_level;
}

/**
 ** Retrieve a KeeperObj based on ID
 **/

KeeperObj& KeeperConnection::retrieve(int id)
	throw (not_connected, db_error, auth_user)
{
	assert(not_connected, PQstatus(connection) == CONNECTION_OK);

	// declare the cursor for our select
 	PGresult* res = PQexec(connection, ("SELECT content,description,mimetype,priv_level FROM objects WHERE id = " + i2str(id)).c_str());
	assert(db_error, res && PQresultStatus(res) == PGRES_TUPLES_OK);

	string description = string(PQgetvalue(res, 0, 1));
	string type = string(PQgetvalue(res, 0, 2));
	int priv_level = atoi(PQgetvalue(res, 0, 3));
	if (priv_level < this->priv_level)
		throw auth_user("Requested privilege level too low for current session/user.");
	
	int ofd =  lo_open(connection, atoi(PQgetvalue(res, 0, 0)), INV_READ);
	assert(db_error, ofd >= 0);
	
	int size = lo_lseek(connection, ofd, 0, SEEK_END);	
	lo_lseek(connection, ofd, 0, SEEK_SET);
	char *data = new char[size];
	int r = lo_read(connection, ofd, data, size);
	assert(io_error, r > 0);
	lo_close(connection, ofd);

	KeeperObj* obj = new KeeperObj(description, priv_level);
	obj->set_data(data, size, type, id);

	assert(not_connected, PQstatus(connection) == CONNECTION_OK);

	return *obj;
}

/**
 ** Get a list of KeeperObj:s from a query by description
 **/

list<KeeperObj>* KeeperConnection::query_description(string description)
	throw (not_connected, db_error)
{
	assert(not_connected, PQstatus(connection) == CONNECTION_OK);

	list<KeeperObj>* l = new list<KeeperObj>;

	// declare the cursor for our select
 	PGresult* res = PQexec(connection, ("SELECT description,mimetype,priv_level,id FROM objects WHERE priv_level >= " + i2str(priv_level) + " AND deleted = 0 AND description LIKE '" + description + "' ORDER BY id").c_str());
	assert(db_error, res && PQresultStatus(res) == PGRES_TUPLES_OK);

	// parse the rows
	for (int i = 0; i < PQntuples(res); i++) {
		if (atoi(PQgetvalue(res, i, 2)) >= priv_level) {
			KeeperObj foo(PQgetvalue(res, i, 0), atoi(PQgetvalue(res, i, 2)));
			
			int id = atoi(PQgetvalue(res, i , 3));
			string type = string(PQgetvalue(res, i , 1));
			foo.set_data(0, 0, type, id);
			l->push_back(foo);
		}
	}
 	PQclear(res);

	assert(not_connected, PQstatus(connection) == CONNECTION_OK);
 	return l;
}

/**
 ** Get a "list" (one item, but for consistency...) of KeeperObj:s from query
 ** by ID.
 ** Note: this is NOT the same as retrieve(id). (FIXME: But maybe it could be...)
 **/

list<KeeperObj>* KeeperConnection::query_id(int id)
	throw (not_connected, db_error)
{
	assert(not_connected, PQstatus(connection) == CONNECTION_OK);

	list<KeeperObj>* l = new list<KeeperObj>;

	// declare the cursor for our select
 	PGresult* res = PQexec(connection, ("SELECT description,mimetype,priv_level,id FROM objects WHERE priv_level >= " + i2str(priv_level) + " AND deleted = 0 AND id = '" + i2str(id) + "' ORDER BY id").c_str());
	assert(db_error, res && PQresultStatus(res) == PGRES_TUPLES_OK);

	// parse the rows
	for (int i = 0; i < PQntuples(res); i++) {
		if (atoi(PQgetvalue(res, i, 2)) >= priv_level) {
			KeeperObj foo(PQgetvalue(res, i, 0), atoi(PQgetvalue(res, i, 2)));
			
			int id = atoi(PQgetvalue(res, i , 3));
			string type = string(PQgetvalue(res, i , 1));
			foo.set_data(0, 0, type, id);
			l->push_back(foo);
		}
	}
 	PQclear(res);

	assert(not_connected, PQstatus(connection) == CONNECTION_OK);
 	return l;
}

/**
 ** Mark an object selected by ID as deleted. This does not remove it from the
 ** databas until a purge is done.
 **/

void KeeperConnection::remove(int id)
	throw (not_connected, db_error)
{
	assert(not_connected, PQstatus(connection) == CONNECTION_OK);

	// begin a transaction block
	PGresult* res = PQexec(connection, "BEGIN");
	assert(db_error, res && PQresultStatus(res) == PGRES_COMMAND_OK);
 	PQclear(res);

	// fetch all rows mathing
 	res = PQexec(connection, ("UPDATE objects SET deleted = 1 WHERE id = " + i2str(id)).c_str());
	if (!res || PQresultStatus(res) != PGRES_COMMAND_OK) {
		res = PQexec(connection, "ABORT TRANSACTION");
		PQclear(res);
		throw db_error("UPDATE (" + string(PQerrorMessage(connection)) + ")");
	}
 	PQclear(res);
	
 	// commit the transaction
 	res = PQexec(connection, "COMMIT");
	assert(db_error, res);
 	PQclear(res);

	assert(not_connected, PQstatus(connection) == CONNECTION_OK);
}

/**
 ** Store a KeeperObj in the database
 **/

void KeeperConnection::store(const KeeperObj& obj)
	throw (not_connected, db_error, auth_user)
{
	assert(not_connected, PQstatus(connection) == CONNECTION_OK);

	if (obj.get_priv_level() < priv_level)
		throw auth_user("Requested privilege level too low for current session/user.");
	
	// begin a transaction block
	PGresult* res = PQexec(connection, "BEGIN");
	assert(db_error, res && PQresultStatus(res) == PGRES_COMMAND_OK);
 	PQclear(res);

	// create the large object
	Oid oid = lo_creat(connection, INV_READ|INV_WRITE);
	assert(db_error, oid > 0);

	int ofd = lo_open(connection, oid, INV_WRITE);
	if (ofd < 0) {
		res = PQexec(connection, "ABORT TRANSACTION");
		PQclear(res);
		throw db_error("lo_open [aborting transaction]");
	}
	// FIXME: add error detection&correction to statements below
	lo_write(connection, ofd, obj.get_data(), obj.get_size());
	lo_close(connection, ofd);
	
	// fetch all rows mathing
 	res = PQexec(connection, ("INSERT INTO objects (deleted, mimetype, description, content, created, priv_level) VALUES (0, '" + obj.get_type() + "', '" + obj.get_description() + "', " + i2str(oid) + ", now(), " + i2str(obj.get_priv_level()) + ")").c_str());
 	if (!res || PQresultStatus(res) != PGRES_COMMAND_OK)
 	{
 		PQclear(res);
		res = PQexec(connection, "ABORT TRANSACTION");
		PQclear(res);
		throw db_error("INSERT INTO [aborting transaction]");
 	}

	
 	// commit the transaction
 	res = PQexec(connection, "COMMIT");
	assert(db_error, res);
 	PQclear(res);

	assert(not_connected, PQstatus(connection) == CONNECTION_OK);
 	return;
}

/**
 ** Find out the number of objects in the database.
 **/

int KeeperConnection::get_num_objects()
	throw (not_connected, db_error)
{
	assert(not_connected, PQstatus(connection) == CONNECTION_OK);

	// begin a transaction block
	PGresult* res = PQexec(connection, "BEGIN");
	assert(db_error, res && PQresultStatus(res) == PGRES_COMMAND_OK);
 	PQclear(res);

	// declare the cursor for our select
 	res = PQexec(connection, ("DECLARE mycursor CURSOR FOR SELECT count(*) FROM objects"));
	assert(db_error, res && PQresultStatus(res) == PGRES_COMMAND_OK);
 	PQclear(res);

	// fetch all rows mathing
 	res = PQexec(connection, "FETCH ALL in mycursor");
	assert(db_error, res && PQresultStatus(res) == PGRES_TUPLES_OK);
 	PQclear(res);

	int n = atoi(PQgetvalue(res, 0 , 0));

 	// close the cursor
 	res = PQexec(connection, "CLOSE mycursor");
	assert(db_error, res);
 	PQclear(res);
	
 	// commit the transaction
 	res = PQexec(connection, "COMMIT");
	assert(db_error, res);
 	PQclear(res);

	assert(not_connected, PQstatus(connection) == CONNECTION_OK);
 	return n;
}

/**
 ** Purge all objects marked as deleted from the database.
 ** Note that this should be a level zero operation but that that is enforced
 ** by the client.
 **/

void KeeperConnection::purge()
	throw (not_connected, db_error)
{
	assert(not_connected, PQstatus(connection) == CONNECTION_OK);

	// Purge all..
 	PGresult*res = PQexec(connection, ("DELETE FROM objects WHERE deleted = 1"));
	assert(db_error, res && PQresultStatus(res) == PGRES_COMMAND_OK);
	PQclear(res);
	
	assert(not_connected, PQstatus(connection) == CONNECTION_OK);
}

/**
 ** Lower the privilege level of this session.
 ** Impossible to raise level.
 **/

bool KeeperConnection::set_priv_level(int p) {
	if (p >= priv_level) {
		priv_level = p;
		return true;
	} else
		return false;
}

/**
 ** Get the current session's privilege level.
 **/

int KeeperConnection::get_priv_level() const
	throw (not_init)
{
	assert(not_init, priv_level >= 0);
	return priv_level;
}

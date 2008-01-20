/** (c) 2000 Jakob Borg
 **
 ** This file implements the keeper object abstraction
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
 ** $Id: keeperobj.cc,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
 **/

//#include <ios>
#include <string>
#include <fstream>
#include <cstdlib>
#include <cstdio>
#include <assert.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#include "keeper.h"
#include "keeperobj.h"

/**
 ** Create an empty object with a description and a priv_level.
 ** It needs to be filled with data later.
 **/

KeeperObj::KeeperObj(string idescription, int ipriv_level)
{
	data = 0;
	size = -1;
	id = -1;
	type = "";
	description = idescription;

	// no checking of allowed priv_level; needs to be done by caller
	priv_level = ipriv_level;
}

/**
 ** Copy constructor: construct an object from another existing object.
 **/

KeeperObj::KeeperObj(const KeeperObj& t)
{
	if (this != &t) {
		if (size != 0 && data != 0) {
			size = t.size;
			data = new char[size];
			for (int i = 0; i < size; i++)
				data[i] = t.data[i];
		} else {
			data = 0;
			size = 0;
		}
		description = t.description;
		type = t.type;
		priv_level = t.priv_level;
		id = t.id;
	}
}

/**
 ** Assignment operator: implemented so that we see when we need a real
 ** operator.
 **/

KeeperObj& KeeperObj::operator=(const KeeperObj&)
	throw (not_init)
{
	throw not_init("ASSIGNMENT OPERATOR NEEDED IN KeeperObj");
}

/**
 ** Destructor: erase the data to avoid memory leak
 **/

KeeperObj::~KeeperObj()
{
	if (data)
		delete data;
}

/**
 ** Import a file on disk to the object. Autodetect MIME-type
 **/

void KeeperObj::import(string filename)
	throw (bad_state, io_error, not_init)
{
	Assert<bad_state>(data == 0, "Trying to import() on a fully constructed KeeperObj.");
	Assert<bad_state>(size = -1, "Trying to import() on a fully constructed KeeperObj.");

	struct stat s;
	if (stat(filename.c_str(), &s) != 0) {
		throw io_error("File stat operation failed in import. No file?");
	}	
	size = s.st_size;
	
	FILE* ppipe;
	ppipe = popen((file_binary + " -b " + mime_magic + " " + filename).c_str(), "r");
	Assert<io_error>(ppipe, "Pipe open operation failed.");

	char* typetmp = new char[80];
	Assert<not_init>(typetmp, "char* typetmp");

	fread(typetmp, 80, 1, ppipe);
	if (ferror(ppipe)) {
		pclose(ppipe);
		delete[] typetmp;
		throw io_error("Pipe read operation failed.");
	}
	type = string(typetmp);
	delete[] typetmp;
	pclose(ppipe);

	// trim type
	unsigned n;
	if ((n = type.find_first_of(",")) != string::npos)
		type = type.substr(0,n);

	ifstream from(filename.c_str());
	Assert<io_error>(from != 0, "File open operation failed.");

	data = new char[size];
	Assert<not_init>(data, "char* data in import");

	from.read(data, size);
	Assert<io_error>(from.good(), "File read operation failed.");
	
	from.close();
}

/**
 ** Return description
 **/

string KeeperObj::get_description() const
	throw (not_init)
{
	Assert<not_init>(description != "", "KeeperObj::description");
	return description;
}

/**
 ** Change description
 **/

void KeeperObj::set_description(string idescription)
{
	description = idescription;
}

/**
 ** Return data
 **/

char* KeeperObj::get_data() const
	throw (not_init)
{
	Assert<not_init>(data, "KeeperObj::data");
	return data;
}

/**
 ** Return data size
 **/

int KeeperObj::get_size() const
	throw (not_init)
{
	Assert<not_init>(size != 0, "KeeperObj::size");
	return size;
}

/**
 ** Return priv_level
 **/

int KeeperObj::get_priv_level() const
	throw (not_init)
{
	Assert<not_init>(priv_level >= 0,  "KeeperObj::priv_level");
	return priv_level;
}

/**
 ** Return data type
 **/

string KeeperObj::get_type() const
	throw (not_init)
{
	Assert<not_init>(type != "",  "KeeperObj::type");
	return type;
}

/**
 ** Return ID
 **/

int KeeperObj::get_id() const
	throw (not_init)
{
	Assert<not_init>(id >= 0,  "KeeperObj::id");
	return id;
}

/**
 ** Set a few parameters
 **/

void KeeperObj::set_data(char* idata, int isize, string itype, int iid)
{
	// deallocate any previous data before losing the pointer into space
	if (data)
		delete[] data;
	data = idata;
	size = isize;
	type = itype;
	id = iid;
}

/**
 ** Save an object to disk
 **/

void KeeperObj::save() const
	throw (not_init, io_error)
{
	Assert<not_init>(data, "KeeperObj::data");
	Assert<not_init>(size != 0, "KeeperObj::size");
	Assert<not_init>(description != "", "KeeperObj::description");
	
	ofstream f;
	const char* filename = (description + ":" + i2str(id) + "," +
				i2str(priv_level)).c_str();
	try {
		f.open(filename);
		if (f.bad())
			throw io_error("opening " + string(filename) + " in save");
		f.write(data, size);
		if (f.bad())
			throw io_error("writing to " + string(filename) + " in save");
		f.close();
	}
	catch (exception& e) {
		unlink(filename);
		string error = string(e.what()) +
			" when saving to file " + string(filename);
		delete[] filename;
		throw;
	}
	delete[] filename;
}

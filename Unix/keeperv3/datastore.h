/* -*- c++ -*-
** $Id: datastore.h,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
** Copyright (c) 2001 Jakob Borg <jakob@borg.pp.se>
*/

#include <mysql/mysql.h>
#include <string>
#include <list>
#include "blob.h"

class Datastore {
public:
	static Datastore* instance();
	list<Blob> query(const string&);
	void store(const Blob&);
	Blob* load(const int);
	void remove(const int);
	void comment(const int, const string&);
	
private:
	static Datastore* _instance;
	MYSQL _db;
	Datastore();
};

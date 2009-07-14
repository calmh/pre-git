/*
** $Id: datastore.cc,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
** Copyright (c) 2001 Jakob Borg <jakob@borg.pp.se>
*/

#include "datastore.h"
#include "util.h"

#include <iostream>
#include <strstream>
#include <cstdio>

Datastore* Datastore::_instance;

Datastore::Datastore()
{
	mysql_init(&_db);
	if (!mysql_real_connect(&_db, 0, "root", 0, "keeper", 0, 0, 0)) {
		cout << mysql_error(&_db)<< "\n";
	}
}

Datastore* Datastore::instance()
{
	if (_instance)
		return _instance;
	else
		return _instance = new Datastore();
}

list<Blob> Datastore::query(const string& qu)
{
	string query = "SELECT Id, Comment, octet_length(Data), Updated, Filename FROM Objects WHERE Comment LIKE \"" + qu + "\"";
	list<Blob> l;

	if (mysql_query(&_db, query.c_str())) {
		cout << mysql_error(&_db) << endl;
		return l;
	}

	MYSQL_RES* result = mysql_store_result(&_db);
	if (result) {
		MYSQL_ROW row = mysql_fetch_row(result);
		while (row) {
			Blob b(parse_int(row[0]), parse_int(row[2]), string(row[1]), row[3]);
			b.set_updated(row[3]);
			l.push_back(b);
			row = mysql_fetch_row(result);
		}
	}
	mysql_free_result(result);

	return l;
}

void Datastore::store(const Blob& blob)
{
	char* ndata = new char[2 * blob.size() + 1];
	mysql_real_escape_string(&_db, ndata, blob.data(), blob.size());
	string query = "INSERT INTO Objects VALUES (" + to_str(blob.id()) + ", \"" + blob.comment() + "\", \"" + blob.filename() + "\", \"" + string(ndata) + "\", null)";
	if (mysql_query(&_db, query.c_str())) {
		cout << mysql_error(&_db) << endl;
	}
	delete[] ndata;
}

void Datastore::comment(const int id, const string& comment)
{
	string query = "UPDATE Objects SET Comment = \"" + comment + "\" WHERE Id = " + to_str(id);
	if (mysql_query(&_db, query.c_str())) {
		cout << mysql_error(&_db) << endl;
	}
	
}

Blob* Datastore::load(const int id)
{
	string query = "SELECT Comment, Data, Filename FROM Objects WHERE Id = " + to_str(id);
	if (mysql_query(&_db, query.c_str())) {
		cout << mysql_error(&_db) << endl;
		return 0;
	}

	string comment;
	Blob* b;
	MYSQL_RES* result = mysql_store_result(&_db);
	if (result) {
		MYSQL_ROW row = mysql_fetch_row(result);
		unsigned long* lengths = mysql_fetch_lengths(result);
		comment = strdup(row[0]);
		b = new Blob(id, lengths[1], comment, row[2]);
		b->set_data(row[1], lengths[1]);
	} else {
		cout << mysql_error(&_db) << endl;
		return 0;
	}
	mysql_free_result(result);

	return b;
}

void Datastore::remove(const int id)
{
	string query = "DELETE FROM Objects WHERE ID = " + to_str(id);
	if (mysql_query(&_db, query.c_str())) {
		cout << mysql_error(&_db) << endl;
	}
}

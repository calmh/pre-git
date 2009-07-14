/* -*- c++ -*-
** $Id: blob.h,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
** Copyright (c) 2001 Jakob Borg <jakob@borg.pp.se>
*/

#include <string>

class Blob {
private:
	int _id;
	int _size;
	string _comment;
	char* _data;
	string _updated;
	string _filename;

public:
	Blob(const int, const int, const string&, const string&);
	~Blob();

	void set_data(const char*, const int);
	void set_updated(const string&);

	const int& id() const;
	const int& size() const;
	const string& comment() const;
	const char* data() const;
	const string& updated() const;
	const string& filename() const;
};

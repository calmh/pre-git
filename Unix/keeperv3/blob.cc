/*
** $Id: blob.cc,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
** Copyright (c) 2001 Jakob Borg <jakob@borg.pp.se>
*/

#include "blob.h"

Blob::Blob(const int iid, const int isize, const string& icomment, const string& filename)
{
	_id = iid;
	_size = isize;
	_comment = icomment;
	_filename = filename;
	_data = 0;
}

Blob::~Blob()
{
	if (_data)
		delete[] _data;
}

void Blob::set_updated(const string& updated)
{
	_updated = updated;
}

void Blob::set_data(const char* data, const int size)
{
	if (_data)
		delete[] _data;
	_data = new char[size];
	memcpy(_data, data, size);
	_size = size;
}

const int& Blob::id() const
{
	return _id;
}

const int& Blob::size() const
{
	return _size;
}

const char* Blob::data() const
{
	return _data;
}

const string& Blob::comment() const
{
	return _comment;
}

const string& Blob::updated() const
{
	return _updated;
}

const string& Blob::filename() const
{
	return _filename;
}


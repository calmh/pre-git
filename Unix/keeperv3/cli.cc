/*
** $Id: cli.cc,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
** Copyright (c) 2001 Jakob Borg <jakob@borg.pp.se>
*/

#include "cli.h"
#include "util.h"

#include <stdlib.h>
#include <cstdio>
#include <unistd.h>
#include <readline/readline.h>
#include <readline/history.h>
#include <strstream>
#include <iostream>
#include <fstream>

CLI::CLI()
{
	_ds = Datastore::instance();
}

CLI::~CLI()
{
}

void CLI::run()
{
	char* line = readline("> ");
	while (line) {
		add_history(line);
		istrstream str(line);
		string cmd;
		str >> cmd;
		if (cmd == "ls") {
			string tmp;
			str >> tmp;
			if (tmp == "")
				ls("%");
			else
				ls("%" + tmp + "%");
		}
		else if (cmd == "load") {
			string tmp;
			str >> tmp;
			load(tmp);
		} else if (cmd == "save") {
			string tmp;			
			str >> tmp;
			int id = parse_int(tmp);
			save(id);
		} else if (cmd == "view") {
			string tmp;			
			str >> tmp;
			int id = parse_int(tmp);
			view(id);
		} else if (cmd == "rm") {
			string tmp;			
			str >> tmp;
			int id = parse_int(tmp);
			_ds->remove(id);
		} else if (cmd == "comment") {
			string tmp;			
			str >> tmp;
			int id = parse_int(tmp);
			comment(id);
		} else
			cout << "?\n";
		free(line);
		line = readline("> ");
	}
}

void CLI::ls(const string& q)
{
	list<Blob> l = _ds->query(q);
	list<Blob>::const_iterator i = l.begin();
	cout << "ID\tSize\tUpdated\t\tComment\n";
	while (i != l.end()) {
		cout << i->id() << "\t" << i->size() << "\t" << i->updated() << "\t" << i->comment() << endl;
		i++;
	}
}

void CLI::load(const string& file)
{
	cout << "Loading " << file << "... ";
	cout.flush();
	ifstream f(file.c_str());
	int size;
	if (!f.good()) {
		cout << "failed.\n";
		return;
	}
	
	f.seekg(0, ios::end);
	size = f.tellg();
	f.seekg(0);
	char* data = new char[size];
	f.read(data, size);
	f.close();
	cout << size << " bytes.\n";

	char* comment = readline("Comment: ");
	Blob b(0, size, string(comment), file);
	b.set_data(data, size);
	delete[] data;

	_ds->store(b);
}

void CLI::save(const int id)
{
	Blob* blob = _ds->load(id);
	ofstream file(blob->filename().c_str());
	file.write(blob->data(), blob->size());
	file.close();
}

void CLI::view(const int id)
{
	Blob* b = _ds->load(id);
	save(id);
	system((string("kview ") + b->filename()).c_str());
	unlink(b->filename().c_str());
}

void CLI::comment(const int id)
{
	char* comment = readline("Comment: ");
	_ds->comment(id, string(comment));
}


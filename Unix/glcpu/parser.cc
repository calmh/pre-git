/** (c) 2000 Jakob Borg
 **
 ** This file implements a sort-of general config-file parser.
 ** At the moment it only understands key=value pairs, optionally with quoted
 ** values key="foo bar".
 ** Keys and unquoted values may not contain spaces.
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
 ** $Id: parser.cc,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
 **/

#include <iostream>
#include <fstream>
using namespace std;

#include "parser.h"

/**
 ** Load a config-file and parse it fully.
 ** (public)
 **/

Config* Parser::parse(string filename)
{
	Config* c = new Config();

	ifstream file;

	file.open(filename.c_str());

	unsigned lineno = 0;
	while (!file.eof() && !file.bad()) {
		unsigned n;
		string temp;
		
		getline(file, temp);
		lineno++;
		
		if ((n = temp.find_first_of("#")) != string::npos)
			temp = temp.substr(0, n);
		if (temp.find_first_not_of(" \t") != string::npos)
			parse_line(temp, lineno, c);
	}
	file.close();
	return c;
}

/**
 ** Parse a line
 ** (private)
 **/

void Parser::parse_line(string line, unsigned lineno, Config* c)
{
	try {
		line = subparse_line(line);
	} catch (string s) {
		cerr << "Parse error on line " << lineno
		     << " of config file: \"" << s << "\"." << endl;
		return;
	}
	
	// there can be no error here; the string is already confirmed to be correct
	unsigned n = line.find_first_of("=");
	c->set_value(line.substr(0, n), line.substr(n + 1));
}

/**
 ** Remove trailing and leading whitespace, as well as around the '='.
 ** With error checking.
 ** (private)
 **/

string Parser::subparse_line(string s)
{
	string tmp;
	unsigned state = 0;

	for (string::const_iterator i = s.begin(); i != s.end(); i++) {
		switch (state) {
		case 0: // leading space
			if (!isspace(*i)) {
				tmp.append(i, 1);
				state = 1;
			}
			break;
		case 1: // keyname
			if (*i == '=') {
				tmp.append(i, 1);
				state = 2;
			} else if (!isspace(*i))
				tmp.append(i, 1);
			else
				state = 6;
			break;
		case 6: // after space after keyname
			if (*i == '=') {
				tmp.append(i, 1);
				state = 2;
			} else if (isspace(*i))
				throw(string("illegal space in key name"));
			break;
				
		case 2: // after '='
			if (*i == '"')
				state = 4;
			else if (!isspace(*i)) {
				tmp.append(i, 1);
				state = 3;
			}
			break;
		case 3: // inside unquoted value;
			if (*i == '"')
				throw(string("illegal loose quote in value"));
			else if (isspace(*i))
				state = 5;
			else
				tmp.append(i, 1);
			break;
			
		case 4: // inside quoted value
			if (*i == '"')
				state = 5;
			else
				tmp.append(i, 1);
			break;
		case 5: // after value
			if (!isspace(*i))
				throw(string("garbage after end of value (need quotes?)"));
			break;
		}
	}
	if (state != 5 && state != 3)
		throw(string("unexpected end of line"));
	
	return tmp;
}

/** (c) 2000 Jakob Borg
 **
 ** This file implements a general config-file parser
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

#include <fstream>
#include "parser.h"
#include "keeper.h"

/**
 ** Load a config-file and parse it fully
 **/

Config* Parser::parse(string filename)
{
	Config* c = new Config();
	assert(not_init, c);

	ifstream file;

	file.open(filename.c_str());
	if (file.bad()) {
		throw io_error("opening " + filename + " in parser");
	}
	
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
 **/

void Parser::parse_line(string line, unsigned lineno, Config* c)
{
	assert(not_init, line != "");
	assert(not_init, lineno > 0);
	
	unsigned n;
	// FIXME: we should strip heading and trailing spaces around here
	// and perhaps allow (require?) double quotes around values
	if ((n = line.find_first_of("=")) != string::npos)
	        c->set_value(line.substr(0, n), line.substr(n + 1));
	else
	        // think about whether an exception would be a better action
	        // here. if so, it should be handled internally by the parser
		cerr << "Parse error on line " << lineno
		     << " of config file: '=' expected." << endl;
}

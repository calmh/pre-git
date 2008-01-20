/** (c) 2000 Jakob Borg
 **
 ** This file implements a general config-file wrapper class
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
 ** $Id: config.cc,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
 **/

#include "config.h"
using namespace std;

/**
 ** Return the value of an option
 **/

string Config::get_value(string opt) const
{
	// No, we can't use "return conf[opt]" here, RTFB to find out why
	map<string,string>::const_iterator i = conf.find(opt);
	if (i == conf.end())
		return "";
	else
		return i->second;
}

/**
 ** Set the value of an option
 **/

void Config::set_value(string opt, string val)
{
	conf[opt] = val;
}

/**
 ** Merge in another config object, overriding our settings.
 **/

void Config::merge(const Config& c)
{
	map<string, string>::const_iterator i;
	for (i  = c.conf.begin(); i != c.conf.end(); i++)
		conf[i->first] = i->second;
}





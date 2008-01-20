/** (c) 2000 Jakob Borg
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
 ** $Id: keeper.h,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
 **/

#ifndef __keeper_h
#define __keeper_h

#include <string>
#include <iostream>
#include <exception>

const string file_binary = "/usr/bin/file";
const string mime_magic = "-m /etc/mime-magic";

class keeper_exception : public exception
{
 protected:
	string spec;	
 public:
	virtual char* what() const { return "keeper_exception"; };
	virtual void debug_print() { cout << spec << endl; };
	keeper_exception() { spec = "(unknown)"; };
	keeper_exception(string s) { spec = s; };
};

// classes for Assert
class not_connected : public keeper_exception
{ // KeeperConnection, db suddenly not connected
 public:
	char* what() const { return "not_connected"; };
	not_connected(const string& s) { spec = s; };
};

class auth_system : public keeper_exception
{ // KeeperConnection, could not connect
 public:
	char* what() const { return "auth_system"; };
	auth_system(const string& s) { spec = s; };
};

class auth_user : public keeper_exception
{ // KeeperConnection, could not log in user
 public:
	char* what() const { return "auth_user"; };
	auth_user(const string& s) { spec = s; };
};

class db_error : public keeper_exception
{ // KeeperConnection, command error
 public:
	char* what() const { return "db_error"; };
	db_error(const string& s) { spec = s; };
};

class not_init : public keeper_exception
{ // KeeperObj, obj not sufficiently initialized
 public:
	char* what() const { return "not_init"; };
	not_init(const string& s) { spec = s; };
};

class io_error : public keeper_exception
{ // KeeperObj, file operation error
 public:
	char* what() const { return "io_error"; };
	io_error(const string& s) { spec = s; };
};

class bad_state : public keeper_exception
{ // KeeperObj, an object is in a bad state for the current operation
 public:
	char* what() const { return "bad_state"; };
	bad_state(const string& s) { spec = s; };
};

template <class X, class A> inline void Assert(A assertion, string error, string message)
{
	if (!(assertion))
		throw X(error);
}

template <class X, class A> inline void Assert(A assertion, string error)
{
	if (!(assertion))
		throw X(error);
}

#undef assert
#define assert(a, b) Assert<a>(b, "Assertion failed: " + string(__FILE__) + "[" + i2str(__LINE__) + "]: " + #b);

string i2str(int v);

#endif

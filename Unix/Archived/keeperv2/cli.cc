/**
 ** (c) 2000 Jakob Borg
 **
 ** This file implements the simple command-line interface
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
 ** $Id: cli.cc,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
 **/

#include <exception>
#include <typeinfo>
#include <iostream>
#include <cstdlib>
#include <unistd.h>
#include <map>
#include "keeper.h"
#include "keeperconnection.h"
#include "keeperobj.h"
#include "config.h"
#include "parser.h"

void parse_options(int&, char **&, Config*);
void import(KeeperConnection*, Config*);
void query(KeeperConnection*, Config*);
void backup(KeeperConnection*, Config*);
void purge(KeeperConnection*, Config*);

const string version = "1.0 DR1";

/**
 ** CLI
 **
 ** The liberal use of auto_ptr is to be safe against being interrupted by
 ** an exception and not beign able to delete pointers.
 **/

int main(int argc, char *argv[])
{
	Config* globalrc  = 0;
	try {
		globalrc = Parser::parse("/etc/keeper.cf");
	}
	catch (...) { // make sure we have a valid globalrc, no matter what
		globalrc = new Config();
	}
	
	// drop root privs as soon as possible
	if (!geteuid())
		seteuid(getuid());
	
	Config* options = new Config();
	parse_options(argc, argv, options);

	if (options->get_value("help") == "yes") { // user requested help, or entered an invalid command
		cout << "Keeper MkII " << version << " (c) 2000 Jakob Borg" << endl << endl
		     << "  keeper [-h] [-o configfile] [-i filename] [-d description] [-l priv_level]" << endl
		     << "         [-P] [-q] [-B <dir>] {[-r] | [-s]} {[-I <id>] | [\"query\"]}" << endl
		     << "\t-h\tGives help." << endl
		     << "\t-i\tImport the selected file." << endl
		     << "\t-d\tSet the description for the imported object." << endl
		     << "\t-l\tSet the privilege level for the current operation." << endl
		     << "\t-q\tBe quiet." << endl
		     << "\t-P\tPurge deleted objects." << endl
		     << "\t-B\tMake a backup of all objects to the specified directory." << endl
//		     << "\t-v\tView the results of the query." << endl
		     << "\t-r\tRemove the objects found in the query." << endl
		     << "\t-s\tSave (export) the objects found in the query." << endl
		     << "\t-o\tUse the selected config-file (instead of /etc/keeper.cf)." << endl
		     << "\t-I\tSelect object by ID." << endl
		     << "\t\"query\"\tSelect objects by SQL query syntax (% is wildcard)." << endl;
		return 0;
	}

 	try {
		if (options->get_value("config file") != "") {
			globalrc = Parser::parse(options->get_value("config file"));
		}
		
		char* user = getenv("LOGNAME");
		char* home = getenv("HOME");
		assert(not_init, user);
		assert(not_init, home);
		Config* userrc = Parser::parse(string(home) + "/.keeperrc");
		globalrc->merge(*userrc);

		assert(not_init, globalrc->get_value("user") != "");
		assert(not_init, globalrc->get_value("password") != "");
		assert(not_init, globalrc->get_value("database") != "");

		// connect to the backend
		KeeperConnection* keeper =
			new KeeperConnection(globalrc->get_value("hostname"),
					     globalrc->get_value("port"),
					     globalrc->get_value("database"),
					     globalrc->get_value("user"),
					     globalrc->get_value("password"));

		// validate current user
		keeper->login(user, userrc->get_value("user_password"));
		if (options->get_value("requested priv_level") != "")
			if (!keeper->set_priv_level(atoi(options->get_value("requested priv_level").c_str())))
				cerr << "Requested privilege level denied, using default." << endl;

		if (options->get_value("import") != "")
			import(keeper, options);
		else if (options->get_value("backup") != "")
			backup(keeper, options);
		else if (options->get_value("purge") == "yes")
			purge(keeper, options);
		else
			query(keeper, options);
		
		return 0;
 	}
 	catch (keeper_exception& e) {
 		cout << "Keeper exception: " << e.what() << endl;
 		e.debug_print();		
 		return -1;
 	}
 	catch (std::exception& e) {
 		cout << "Exception: " << e.what() << endl;
 		throw;
 	}
 	catch (...) {
 		cerr << "Whoah! An unknown exception, not able to handle it, not good!" << endl;
 		throw;
 	}
}

/**
 ** Parse the command-line options and put them into a map
 ** for easy access
 **/

void parse_options(int& argc, char **& argv, Config* options)
{
	if (argc == 1) {
		options->set_value("help", "yes");
		return;
	}
	
	while (true) {
		char c = getopt(argc, argv, "i:d:l:vrso:hI:B:qP");
		if (c == -1)
			break;
		switch (c) {
		case '?':
			options->set_value("help", "yes");
			break;
		case 'i':
			options->set_value("import", string(optarg));
			break;
		case 'I':
			options->set_value("id", string(optarg));
			break;
		case 'd':
			options->set_value("description", string(optarg));
			break;
		case 'l':
			options->set_value("requested priv_level", string(optarg));
			break;
		case 'v':
			options->set_value("view", "yes");
			break;
		case 'r':
			options->set_value("remove", "yes");
			break;
		case 's':
			options->set_value("save", "yes");
			break;
		case 'o':
			options->set_value("config file", string(optarg));
			break;
		case 'h':
			options->set_value("help", "yes");
			break;
		case 'B':
			options->set_value("backup", string(optarg));
			break;
		case 'q':
			options->set_value("quiet", "yes");
			break;
		case 'P':
			options->set_value("purge", "yes");
			break;
		}
	}

	// put all unrecognized parameter in the query
	while (optind < argc)
		options->set_value("query", options->get_value("query") + string(argv[optind++]));

	// set the help options if we supplied both query and ID (illegal)
	if (options->get_value("query") != "" && options->get_value("id") != "")
		options->set_value("help", "yes");
}

/**
 ** Import a new object into the DB from a file
 **/

void import(KeeperConnection* keeper, Config* options)
{ // import object
	if (options->get_value("description") == "")
		options->set_value("description", options->get_value("import"));

	KeeperObj foo(options->get_value("description"), keeper->get_priv_level());
	foo.import(options->get_value("import"));
	keeper->store(foo);
}

/**
 ** Perform a search, displaying the results and optionally processing them somehow
 **/

void query(KeeperConnection* keeper, Config* options)
{
	list<KeeperObj>* l;

	if (options->get_value("id") != "") {
		l = keeper->query_id(atoi(options->get_value("id").c_str()));
		cout<<"Search results for ID=" << options->get_value("id") << ":" << endl;
	}
	else {
		l = keeper->query_description(options->get_value("query"));
		cout<<"Search results for '" << options->get_value("query") << "':" << endl;
	}

	// process results	
	for (list<KeeperObj>::const_iterator i = l->begin(); i != l->end(); i++) {
		// print information about the object
		if (options->get_value("quiet") != "yes") {
			cout << i->get_id() << "\t'" << i->get_description() << "' (" << i->get_priv_level() << ")";
			cout.flush();
		}

		// save the object?
		if (options->get_value("save") == "yes") {
			keeper->retrieve(i->get_id()).save();
			
			if (options->get_value("quiet") != "yes") {
				cout << " (saved)";
				cout.flush();
			}
		}

		// remove the object?
		if (options->get_value("remove") == "yes") {
			keeper->remove(i->get_id());
			if (options->get_value("quiet") != "yes") {
				cout << " (removed)";
				cout.flush();
			}
		}

		if (options->get_value("quiet") != "yes")
			cout << endl;
	}
	cout << "(" + i2str(l->size()) + " hit" + (l->size() == 1 ? "" : "s") + " total)" << endl;
}

/**
 ** Do a complete backup of the system
 **/

void backup(KeeperConnection* keeper, Config* options)
{

 	if (keeper->get_priv_level() != 0) {
 		cout << "You need to have a privilege level of 0 for this operation." << endl;
 		return;
 	} 	

	int n = keeper->get_num_objects();

	// get a list of all objects in the DB
	list<KeeperObj>* l;
	l = keeper->query_description("%");
	
	// changes made by other keeper clients after this point won't get backed

	int d = 0;
	if (options->get_value("quiet") != "yes") {
		cout << "Backup...";
		cout.flush();
	}

	int r = chdir(options->get_value("backup").c_str());
	assert(io_error, r == 0);
	
	for (list<KeeperObj>::const_iterator i = l->begin(); i != l->end(); i++) {
		// as one operation to avoid temp copies of the object
		keeper->retrieve(i->get_id()).save();
		
		d++;
		if (options->get_value("quiet") != "yes") {
			cout << "\rBackup: " << int(100 * d / n) << "% complete.";
			cout.flush();
		}
	}
	
	if (options->get_value("quiet") != "yes")
		cout << "\rBackup: 100% complete." << endl;
}

/**
 ** Purge deleted objects.
 **/

void purge(KeeperConnection* keeper, Config* options)
{

 	if (keeper->get_priv_level() != 0) {
 		cout << "You need to have a privilege level of 0 for this operation." << endl;
 		return;
 	} 	

	if (options->get_value("quiet") != "yes") {
		cout << "All items marked for deletion will be purged in 10 s. Press Ctrl-C to abort." << endl;
		for (int i = 10; i > 0; i--) {
			cout << "\r" << i << "... ";
			cout.flush();
			sleep(1);
		}
	}

	int n1 = keeper->get_num_objects();
	keeper->purge();
	int n2 = keeper->get_num_objects();
	
	if (options->get_value("quiet") != "yes") {
		cout << "\rPurge complete, " << n1 - n2 << " objects removed (" << n2 << " left in dbase)." << endl;
	}
}

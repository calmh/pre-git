/* -*- c++ -*-
** $Id: cli.h,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
** Copyright (c) 2001 Jakob Borg <jakob@borg.pp.se>
*/

#include "datastore.h"
#include "ui.h"

class CLI : public UI {
 public:
	CLI();
	~CLI();
	void run();
private:
	Datastore* _ds;
	void ls(const string&);
	void load(const string&);
	void save(const int);
	void view(const int);
	void comment(const int);
};

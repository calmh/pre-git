/* -*- c++ -*-
** $Id: ui.h,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
** Copyright (c) 2001 Jakob Borg <jakob@borg.pp.se>
*/

class UI {
public:
	UI();
	virtual ~UI();
	virtual void run() = 0;
};

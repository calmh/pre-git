/*
** $Id: main.cc,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
** Copyright (c) 2001 Jakob Borg <jakob@borg.pp.se>
*/

#include "cli.h"

int main()
{
	UI* ui = new CLI();
	ui->run();
}

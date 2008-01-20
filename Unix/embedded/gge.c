#include "gge.h"

void setpixel(unsigned x, unsigned y)
{
	assert(x < 128);
	assert(y < 64);
	mvaddch(y, x, '#');
}

void clearpixel(unsigned x, unsigned y)
{
	assert(x < 128);
	assert(y < 64);
	mvaddch(y, x, ' ');
}

void start()
{
	initscr();
	cbreak();
	noecho();
	nonl();
	intrflush(stdscr, FALSE);
	keypad(stdscr, TRUE);
	nodelay(stdscr, 1);
	erase();
	curs_set(0);
	refresh();
}

void end()
{
	endwin();
}

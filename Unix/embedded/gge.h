#ifndef GGE_H
#define GGE_H

#include <curses.h>
#include <assert.h>

#define KEY_SP1 KEY_ENTER

void setpixel(unsigned x, unsigned y);
void clearpixel(unsigned x, unsigned y);
void start();
void end();

#endif // GGE_H

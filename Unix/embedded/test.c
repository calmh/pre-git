#include "gge.h"

int main()
{
	start();

	setpixel(0,0);
	setpixel(1,1);
	setpixel(20,20);
	setpixel(25,50);
	setpixel(50,25);
	setpixel(50,50);
	refresh();
	sleep(5);
	
	end();
}

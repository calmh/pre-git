#include "gge.h"

void addshot(int x, int y);
void paintship(int x, int y);
void paintshots();

int shots[5][2] = {{-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}, {-1, -1}};
int shotnum;
int shipx, shipy;

int main()
{
	start();
	shipx = 64;
	shipy = 60;
	
	while (1) {
		int key = getch();
		switch (key) {
		case KEY_UP:
			if (shipy > 40)
				shipy--;
			break;
		case KEY_DOWN:
			if (shipy < 62)
				shipy++;
			break;
		case KEY_LEFT:
			if (shipx > 1)
				shipx--;
			break;
		case KEY_RIGHT:
			if (shipx < 126)
				shipx++;
			break;
		case KEY_SP1: // first special key
			addshot(shipx, shipy);
			break;
		}
		paintship(shipx, shipy);
		paintshots();
		refresh();
		usleep(10000);
	}

	
	refresh();
	sleep(5);
	
	end();
}

void addshot(int x, int y)
{
	static int shotnum = 0;

	if (shots[shotnum][1] == -1)
	{
		shots[shotnum][0] = x;
		shots[shotnum][1] = y - 2; // in front of ship
		shotnum = (shotnum == 4) ? 0 : shotnum + 1;
	}
}

void paintshots()
{
	int i;
	
	for (i = 0; i < 5; i++) {
		if (shots[i][1] != -1) {
			clearpixel(shots[i][0], shots[i][1]);
			shots[i][1]--;
			if (shots[i][1] != -1)
				setpixel(shots[i][0], shots[i][1]);
		}
	}
}

void paintship(int x, int y)
{
	static int ox = 2, oy = 2;
	if (ox != x || oy != y) {
		clearpixel(ox, oy - 1);
		
		clearpixel(ox, oy);
		clearpixel(ox - 1, oy);
		clearpixel(ox + 1, oy);
		
		clearpixel(ox, oy + 1);
		clearpixel(ox - 1, oy + 1);
		clearpixel(ox + 1, oy + 1);
		clearpixel(ox - 2, oy + 1);
		clearpixel(ox + 2, oy + 1);

		ox = x;
		oy = y;
		
		setpixel(x, y - 1);
		
		setpixel(x, y);
		setpixel(x - 1, y);
		setpixel(x + 1, y);
		
		setpixel(x, y + 1);
		setpixel(x - 1, y + 1);
		setpixel(x + 1, y + 1);
		setpixel(x - 2, y + 1);
		setpixel(x + 2, y + 1);
	}
}

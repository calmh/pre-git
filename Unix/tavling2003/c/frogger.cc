#include <iostream>
using namespace std;

int sx, sy;
int ex, ey;
int nrounds;
int nlanes;
int length;
char* lanes;
int* state;
int depth;

void print() {
	for (int y = 0; y < nlanes; y++) {
		for (int x = 0; x < length; x++) {
			cout << lanes[y * length + x];
		}
		cout << endl;
	}
	cout << endl;
}

void stepup(int d) {
	char t;
	for (int y = 1; y < nlanes - 1; y++) {
		if ((y + 1 + d) % 2) {
			for (int x = 0; x < length; x++) {
				if (x == 0) {
					t = lanes[y * length + x];
					lanes[y * length + x] = lanes[y * length + x + 1];
				} else if (x == length - 1) {
					lanes[y * length + x] = t;
				} else {
					lanes[y * length + x] = lanes[y * length + x + 1];
				}
			}
		} else {
			for (int x = length - 1; x >= 0; x--) {
				if (x == length - 1) {
					t = lanes[y * length + x];
					lanes[y * length + x] = lanes[y * length + x - 1];
				} else if (x == 0) {
					lanes[y * length + x] = t;
				} else {
					lanes[y * length + x] = lanes[y * length + x - 1];
				}
			}
		}
	}
}

int solve(int x, int y) {
//	print();
	stepup(0);
	if (depth > nrounds || lanes[y * length + x] == 'X')
		return 999999999;

	depth++;

	int t = state[(nlanes * length * depth) + y * length + x];
	if (t != 0) {
		depth--;
		stepup(1);
		return t;
	}

	if (lanes[y * length + x] == 'G') {
		state[(nlanes * length * depth) + y * length + x] = 1;
		depth--;
		stepup(1);
		return 1;
	}
	
	int minx = 10000000;
	int res;
	
	if (y + 1 <= nlanes - 1)
		res = solve(x, y - 1);
		if (res < minx)
			minx = res;
	}
	for (int dx = -1; dx <= 1; dx+=2) {
		if (x + dx > length - 1 || x + dx < 0)
			continue;
		res = solve(x + dx, y);
		if (res < minx)
			minx = res;
	}
	res = solve(x, y);
	if (res < minx)
		minx = res;

	state[(nlanes * length * depth) + y * length + x] = 1 + minx;
	depth--;

	stepup(1);
	return 1 + minx;
}

int main() {
	int ncases;
	cin >> ncases;
	for (int i = 0; i < ncases; i++) {		
		cin >> nrounds >> nlanes >> length;
		nlanes += 2;
		lanes = new char[nlanes * length];	       
		state = new int[nlanes * length * nrounds];	       
		for (int i = 0; i < nlanes; i++) {
			string lane;
			cin >> lane;
			for (int j = 0; j < lane.size(); j++) {
				lanes[i * length + j] = lane[j];
				if (lane[j] == 'F') {
					sx = j;
					sy = i;
				}
				if (lane[j] == 'G') {
					ex = j;
					ey = i;
				}
			}
		}
		depth = 0;
		int res = solve(sx, sy);
		if (res > nrounds)
			cout << "The problem has no solution." << endl;
		else
			cout << "The minimum number of turns is " << res + 1 << "." << endl;
	}
}

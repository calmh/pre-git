#include <iostream>
using namespace std;

struct Ring {
	double x, y, r;
	int group;
};

/*
** Kolla om två ringar överlappar: tillräckligt nära men inte helt inuti varandra.
*/
bool overlaps(Ring* a, Ring* b) {
	double dist = (a->x - b->x) * (a->x - b->x) + (a->y - b->y) * (a->y - b->y);
	double rads = (a->r + b->r) * (a->r + b->r);
	double radiff = (a->r - b->r) * (a->r - b->r);
	return (dist <= rads) && (dist >= radiff);
}

/*
** Hitta rekursivt alla medlemmar i en grupp.
*/
int findgroup(Ring* rings[], int nrings, int group, int n) {
	int size = 1;
	rings[n]->group = group;
	for (int i = 0; i < nrings; i++) {
		if (rings[i]->group == -1 && overlaps(rings[n], rings[i]))
			size += findgroup(rings, nrings, group, i);
	}
	return size;
}

/*
** Läs in ringarna och hitta en grupp för varje ring.
*/
int process(int nrings) {
	Ring* rings[nrings];
	int curgroup = 0;
	for (int i = 0; i < nrings; i++) {
		Ring* a = new Ring;
		cin >> a->x >> a->y >> a->r;
		a->group = -1;
		rings[i] = a;
	}

	int maxg = 0;
	for (int i = 0; i < nrings; i++) {
		if (rings[i]->group == -1) {
			int size = findgroup(rings, nrings, curgroup++, i);
			if (size > maxg)
				maxg = size;
		}

	}
	return maxg;
}

int main() {
	int nrings;
	while(cin >> nrings, nrings != -1)
		cout << "The largest component contains " << process(nrings) << " rings" << endl;
		
}

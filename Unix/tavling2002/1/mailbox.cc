#include <iostream>
#include <math.h>

void solve(int low, int high, int box, int cost);

int worst = 0;
int highest;

int main()
{
	int k = 3;
	int m = 73;

	highest = m;

	worst = 0;
	solve(1, m, k, 0);
	cout << endl << worst << endl;
}

void solve(int low, int high, int box, int cost)
{
	cout << "solve: " << low << " " << high << " " << box << " " << cost << endl;

	if (low > high)
		return;
	
	if (box == 1) {
		int mm = high - low + 1;
		cost += mm * (mm + 1) / 2 + (low-1) * mm;
		if (cost > worst) {
			worst = cost;
			cout <<"w1: " << worst << endl;
		}
		return;
	}

	if (low+1 == high) {
		cost += low; // + high;
		if (cost > worst)
			worst = cost;
		return;
	}

	if (low == high) {
		cost += low;
		if (cost > worst)
			worst = cost;
		return;
		
	}

//	int mid = (high - low) / (1 + 2.72/box) + low;
	int best_worst = 9999999;
	
	for (int ii=low+10; ii<high-10; ii++) {
		int mid = ii;
		solve(low, mid-1, box - 1, cost + mid);
		solve(mid+1, high, box, cost + mid);
		if (worst < best_worst)
			best_worst = worst;
	}
	worst = best_worst;
}


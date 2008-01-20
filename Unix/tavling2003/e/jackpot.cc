#include <iostream>
using namespace std;

int eucgcd(int a, int b) {
	if (b == 0)
		return a;
	else
		return eucgcd(b, a % b);
}

int check(int* pers, int n) {
//	unsigned long f = 1;
	int maxw = 0;
	int maxg = 0;
	for (int i = 0; i < n; i++) {
		if (pers[i] > maxw)
			maxw = pers[i];		
		for (int j = i + 1; j < n; j++) {
			int a = pers[j];
			int b = pers[i];
			int gcd = eucgcd(a, b);
//			cout << "gcd " << gcd << endl;
/*			if (f % gcd != 0)
//				f *= gcd;
//			if (f > 1e9)
			return 0;*/
			if (gcd > maxg)
				maxg = gcd;
		}
			
	}

	unsigned long q;
	int fail = 1;
	int m = (maxw > maxg) ? maxw : maxg;
	for (q = m; fail; q += m) {
		if (q > 1e9)
			return q;
		fail = 0;
		for (int i = 0; i < n; i++)
			if (q % pers[i]) {
				fail = 1;
				break;
			}
	}
	
	return q - m;
}

int exists(int* lst, int item, int n) {
	for (int i = 0; i < n; i++)
		if (lst[i] == item)
			return 1;
	return 0;
}

int main() {
	int ncases;
	cin >> ncases;
	for (int i = 0; i < ncases; i++) {		
		int nwheels;
		cin >> nwheels;
		int nn = 0;
		int* pers = new int[nwheels];
		for (int j = 0; j < nwheels; j++) {
			int tmp;
			cin >> tmp;
			if (!exists(pers, tmp, nn)) {
				pers[nn] = tmp;
				nn ++;
			}
		}
		int res = check(pers, nn);
		if (res > 0 && res <= 1e9)
			cout << res << endl;
		else
			cout << "More than a billion." << endl;
	}
}

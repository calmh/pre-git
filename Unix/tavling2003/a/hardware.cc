#include <iostream>
#include <string>
#include <list>
using namespace std;

int digs[10];

void countDigits(int i) {
	char* foo = new char[15];
	sprintf(foo, "%d", i);
	for (int i = 0; i < strlen(foo); i++)
		digs[foo[i] - '0'] += 1;
}

void solve() {
	for (int i = 0; i < 10; i++)
		digs[i] = 0;
	char* addr = new char[55];
	cin.getline(addr, 50, '\n');
	cin.getline(addr, 50, '\n');
//	cin.get(addr, 50, '\n');
//	cin >> addr;
//	string str;
//	cin.getline(cin,str);
//	cout << addr << endl;
	int naddr;
	cin >> naddr;
	string tmp;
	cin >> tmp;
	int c = 0;
	while (c < naddr) {
		string term;
		cin >> term;
		if (term == "+") {
			int first, last, step;
			cin >> first >> last >> step;
			for (int i = first; i <= last; i+= step) {
				c++;
				countDigits(i);
			}
		} else {
			c++;
			countDigits(atoi(term.c_str()));
		}
	}

	cout << addr << endl;
	cout << naddr << " " << tmp << endl;
	int total = 0;
	for (int i = 0; i < 10; i++) {
		cout << "Make " << digs[i] << " digit " << i << endl;
		total += digs[i];
	}
	cout << "In total " << total << (total == 1 ? " digit" : " digits") << endl;
}

int main() {
	int ncases;
	cin >> ncases;
	for (int i = 0 ; i < ncases; i++)
		solve();	
	return 0;
}

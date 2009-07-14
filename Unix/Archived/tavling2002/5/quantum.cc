#include <iostream>
#include <list>
#include <string>
#include <map>

int solve(list<string> words, list<int> cost, string str1, string str2, int nop, int res);

map<string, int> mmap;

int main()
{
	int nbr_tests;
	cin >> nbr_tests;
	cout << "Number tests: " << nbr_tests;

	for (int i=0; i<nbr_tests; i++) {
		int length;
		int nop;
		int nw;
		cin >> length >> nop >> nw;
		cout << "Lenght: " << length << " nop: " << nop << " nw: " << nw << endl;
		
		list<string> words;
		list<int> cost;
		string str;
		int i_cost;
		char ch;

		for (int j=0; j<nop; j++) {
			cin >> str >> i_cost;
			cout << "s: " << str << " cost: " << i_cost << endl;
			words.push_back(str);
			cost.push_back(i_cost);
		}

		list<string> data1;
		list<string> data2;
		string str1, str2;
		
		for (int j=0; j<nw; j++) {
			cin >> str1 >> str2;
			cout << "s1: " << str1 << " s2: " << str2 << endl;

			solve(words, cost, str1, str2, nop, res);
		}

//		int res = solve(words, cost, data1, data2, nop, 100000); // INT_MAX!!

		cout << "Res: " << res << endl;
	}
}

int solve(list<string> words, list<int> cost, string str1, string str2, int nop,int res)
{
	if (nop == 0)
		return res;

	int best;
	
	
	return 0;
}

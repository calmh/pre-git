#include <iostream>
#include <deque>
#include <vector>
#include <string>
#include <map>
#include <strstream>

using namespace std;

int quantum, timeslice;
int timeq[5];
int nprogs;
int lock_num = 0;
map<string, int> variables;

struct Program {
	vector<string> stmts;
	int ip;
	int id;

	Program(int id) {
		ip = 0;
		this->id = id;
		string tmp;
		do {
			char buffer[256];
			cin.getline(buffer, 255);
//			cout << " ** " << buffer << endl;
			tmp = buffer;
			if (tmp.find("=") != string::npos)
				tmp.replace(tmp.find("="), 1, " = ");
			stmts.push_back(tmp);
		} while (tmp.find("end") == string::npos);
	}
};


void main()
{
	deque<Program> run;
	deque<Program> block;
	
	cin >> nprogs >> timeq[0] >> timeq[1] >> timeq[2] >> timeq[3] >> timeq[4] >> quantum;
	for (int id = 1; id <= nprogs; id++) {
		run.push_back(Program(id));
	}

	while (!run.empty()) {
		Program p = run.front();
		run.pop_front();
		timeslice = quantum;
		int blocked = 0;
		do {
			string stmt = p.stmts[p.ip];
//			cout << " -- " << stmt << endl;
			p.ip++;
			if (stmt.find("end") != string::npos) {
				timeslice -= timeq[4];
				blocked = 1;
			} else if (stmt.find("print") != string::npos) {
				timeslice -= timeq[1];
				istrstream s(stmt.c_str(), stmt.size());
				string var;
				s >> var;
				s >> var;
				cout << p.id << ": " << variables[var] << endl;
			} else if (stmt.find("=") != string::npos) {
				timeslice -= timeq[0];
				string tmp, var;
				int val;
				istrstream s(stmt.c_str(), stmt.size());
				s >> var;
				s >> tmp;
				s >> val;
				variables[var] = val;
			} else if (stmt.find("unlock") != string::npos) {
				timeslice -= timeq[3];				
				lock_num = 0;
				if (!block.empty()) {
					run.push_front(block.front());
					block.pop_front();
				}
			} else if (stmt.find("lock") != string::npos) {
				timeslice -= timeq[2];
				if (lock_num == 0) {
					lock_num = p.id;
				} else {
					p.ip --;
					block.push_back(p);
					blocked = 1;
				}
			}
		} while (timeslice > 0 && !blocked);
		if (!blocked)
			run.push_back(p);
	}
}


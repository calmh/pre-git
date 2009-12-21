#include <iostream>
#include <vector>
#include <cmath>
#include <sstream>

using namespace std;

double rround(double nbr)
{
	if (nbr - (int)nbr < 0.5)
		return (int)nbr;
	else
		return ceil(nbr);
}

void updown(double nbr, double *up, double *down)
{
	char str[50];
	double round = rround(nbr);
	double diff;
	diff = abs(nbr - round);
	//ostringstream str;
	//       str << diff;
//	strn = str.str();
//	cout << strn << endl;
	sprintf(str, "%.5f", diff);
	cout << str << endl;

	
	if (str[2] == '0') {
		*up = nbr + 0.5;
		*down = nbr - 0.5;
	}
	else if (str[3] == '0') {
		*up = nbr + 0.05;
		*down = nbr - 0.05;
	}
	else if (str[4] == '0') {
		*up = nbr + 0.005;
		*down = nbr - 0.005;
	}
	else if (str[5] == '0') {
		*up = nbr + 0.0005;
		*down = nbr - 0.0005;
	}
	else if (str[6] == '0') {
		*up = nbr + 0.00005;
		*down = nbr - 0.00005;
	}
       else {
		*up = nbr + 0.000005;
		*down = nbr - 0.000005;
	}
	
}

void solve(vector<double>& nbrs)
{//	for (int i=0;i<nbrs.size();i++)
//		cout << nbrs[i] << endl;
	int correct=0;
	for (int i=1;i<100;i++) {
		correct = 0;
		for (int j=0;j<nbrs.size();j++) {
			double up, down;
			updown(nbrs[j],&up,&down);
			//double res = (nbrs[j] * i) / 100.0;

			double l1 = (down * i) / 100.0;
			double l2 = (up * i) / 100.0;
			
				
			//cout << "i: " << i << " res: " << res << ": resround: " << resround << endl;
			//if (abs(res - resround) >= 0.005 * i) {
				//cout << "break: " << i << " j: " << nbrs[j] << endl;
				//cout << "in ";
			//} else {
				//cout << "correct\n";
				//cout << "co ";
				//correct++;
			//}
			cout << "i: " << i << "l1: " << l1 << " l2: " << l2 << endl;
			if ((int)down < (int)up) {
				cout << "in ";
			} else {
				cout << "co ";
				correct++;
			}
			
				
		}
		//cout << "i: " << i << " j: " << j;
		if (correct == nbrs.size()) {
			cout << i << endl;
			return;
		}
	}
	cout << "error\n";
}


int main()
{
	int casenbr = 0;
	while (true) {
			int nbr;
			casenbr++;
			cin >> nbr;
			if (nbr == 0)
				return 0;
			vector<double> nbrs;
			for (int i=0;i<nbr;i++) {
				double tmp;
				cin >> tmp;
				nbrs.push_back(tmp);
			}
			//if (casenbr == 6) {
				
				cout << "Case " << casenbr << ": ";
				solve(nbrs);
				//}
			
	}
	return 0;
}



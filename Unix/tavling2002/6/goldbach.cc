#include <iostream>
#include <cstdlib>
#include <queue>
#include <assert.h>
#include <vector>

priority_queue<int> not;
//vector<int> primes;
char primes[32768];

	
int witness(int a, int i, int n)
{
	if (i == 0)
		return 1;

	int x = witness(a, i/2, n);
	if (x == 0)
		return 0;

	int y = (x * x) % n;
	if (y == 1 && x != 1 && x != (n - 1))
		return 0;

	if (i % 2 != 0)
		y = (a *y) % n;
	return y;
}

int isprime(int n, int trials = 20) {
	for (int i = 0; i < trials; i++) {
		if (witness(2 + (rand() % (n - 2)), n-1, n) != 1)
			return false;
	}
	return true;
}

void calcprimes()
{
	for (int i = 3; i < (2<<14) ; i+=2) {
		if (isprime(i)) {
//			cout << i << endl;
//		primes.push_back(i);
			primes[i] = 1;
		}
		else
			primes[i] = 0;
	}
				  
}

int solve(int n)
{
	int low = 3;
	int high = n / 2;
	int r;
	for (int i = low; i <= high; i += 2) {
//		if (!not.empty() && i == not.top()) {
//			not.pop();
//		} else {
		if (primes[i] && primes[n - i]) {
//				for (int n = 2; n < 10; n++) {
//					int t = n * i;
//					if (t % 2)
//						not.push(t);
//				}
				r++;			
			}
//		}
	}
	return r;
}

int main() {
	int n;
	calcprimes();
	while (1) {
		cin >> n;
		if (n == 0)
			return 0;
		cout << solve(n) << endl;
	}
	return 0;
}

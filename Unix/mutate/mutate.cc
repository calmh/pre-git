#include <cstdio>
#include <string>
#include <unistd.h>
#include <fcntl.h>
#include <math.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fstream>

const int BLOCK = 1000000;

class Mutator {
private:
	double start, end;
	long free_bytes;

public:
	Mutator(double start, double end, long free_bytes = 0);
	void mutate(string filename);
};


int main(int argc, char *argv[])
{
	// seed the random generator
	srand(time(0));

	// create a Mutator with an exponentially increasing
	// mutation probability from 1e-6 to 1e-3, leaving
	// the first and last 20 megs intact.
	Mutator m(1e-6, 1e-3, 1000000*20);

	// mutate the file
	m.mutate(argv[1]);
	return 0;
}

Mutator::Mutator(double start, double end, long free_bytes = 0) {
	this->start = start;
	this->end = end;
	this->free_bytes = free_bytes;
}

void Mutator::mutate(string filename) {
	char *buffer;

	// open the file
	int file = open(filename.c_str(), O_RDWR);
	if (file == -1) {
		perror("Couldn't open file");
		return;
	}

	// find the size of the file
	struct stat s;
	fstat(file, &s);

	// probability that will be increased during loop
	double prob = start;
	// find the number of times we will encrease the probability
	int steps = (s.st_size - free_bytes * 2) / BLOCK;
	// find the multiplier for a nice exponential curve between start and end
	// given that:
	//    end = mult ^ steps * start
	double mult = exp(log(end / start) / steps);

	// keep some statistics
	ofstream errstat("errors.stat");
	long errors = 0;
		
	// map the file into memory
	buffer = (char*) mmap(0, s.st_size, PROT_READ|PROT_WRITE, MAP_SHARED, file, 0);

	// step throught the file byte for byte,
	// excluding the ranges in the beginning and end
	for (long i = free_bytes; i <= s.st_size - free_bytes; i++) {
		double val = (double) rand() / RAND_MAX;
		if (val < prob) {
			buffer[i] = 0;
			errors++;
		}
		if (i % BLOCK == 0) {
			cout << "\rMutating: "
			     << (int) ((double) (i - free_bytes) / (s.st_size - free_bytes * 2) * 100)
			     << " % complete, P(e) = " << prob << ", N(e) = " << errors << ".          " << flush;
			errstat << i/BLOCK << '\t' << errors << endl; 
			prob *= mult;
		}
	}
	cout << endl << "Done." << endl;

	// unmap file and sync it to disk
	munmap(buffer, s.st_size);
	close(file);

	// close the statistics files
	errstat.close();
}


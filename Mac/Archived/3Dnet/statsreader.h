/*
 *  statsreader.h
 *  3Dnet
 *
 *  Created by Jakob Borg on 2005-10-29.
 *  Copyright 2005 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef STATSREADER_H
#define STATSREADER_H

#include <string>
using namespace std;

class StatsReader {
private:
	int sockfd;
	StatsReader();
public:
	static StatsReader* instance();
	~StatsReader();
	double* usage(string target);
};

#endif


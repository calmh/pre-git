/*
 *  link.h
 *  3Dnet
 *
 *  Created by Jakob Borg on 2005-10-28.
 *  Copyright 2005 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef LINK_H
#define LINK_H

#include <string>
using namespace std;

class Link {
public:
	double x1, y1, x2, y2;
	int capacity;
	double uin, uout;
	string target;
	int kind;
	Link();
	Link(double x1, double y1, double x2, double y2, int capacity, string target, int kind);
	void draw(int timer);
};

#endif


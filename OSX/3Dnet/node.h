/*
 *  node.h
 *  3Dnet
 *
 *  Created by Jakob Borg on 2005-10-29.
 *  Copyright 2005 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef NODE_H
#define NODE_H

#include <string>
using namespace std;

class Node {
public:
	string name;
	double x, y;
	int size;
	Node();
	Node(string name, double x, double y, int capacity);
	void draw(double alpha) const;
};

#endif


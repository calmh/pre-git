/*
 *  network.h
 *  3Dnet
 *
 *  Created by Jakob Borg on 2005-10-29.
 *  Copyright 2005 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef NETWORK_H
#define NETWORK_H

#include <string>
#include <map>
#include <list>
#include <fstream>
using namespace std;

#include "node.h"
#include "link.h"

class Network {
private:
	map<string, Node> nodes;
	list<Link> links;
	double minx, miny, maxx, maxy, scale;
public:
	double cx, cy;
	Network(std::string conffile);
	void draw(int timer, double alpha);
	Node random_node();
};

#endif


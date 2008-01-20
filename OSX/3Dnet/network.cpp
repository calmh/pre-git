/*
 *  network.cpp
 *  3Dnet
 *
 *  Created by Jakob Borg on 2005-10-29.
 *  Copyright 2005 __MyCompanyName__. All rights reserved.
 *
 */

#include "stdafx.h"

#ifdef __APPLE__
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

#include "network.h"
#include "statsreader.h"
#include <iostream>
#include <stdlib.h>
using namespace std;

Network::Network(string conffile) : nodes(), links()
{
	ifstream f(conffile.c_str());
	if (!f.good()) {
		cout << "[Network::Network(\"" << conffile << "\")] File open/read error" << endl;
	}
	
	while (!f.eof()) {
		string type;
		f >> type;
		if (type == "")
			continue;
				
		if (type == "n") {
			string name;
			double x, y;
			f >> name >> x >> y;
			nodes[name] = Node(name, x, y, 1);
			minx = x < minx ? x : minx;
			miny = y < miny ? y : miny;
			maxx = x > maxx ? x : maxx;
			maxy = y > maxy ? y : maxy;
		} else if (type == "l") {
			string n1, n2, target;
			int capacity, kind;
			f >> n1 >> n2 >> capacity >> target >> kind;
			Node nn1 = nodes[n1];
			Node nn2 = nodes[n2];
			Link l(nn1.x, nn1.y, nn2.x, nn2.y, capacity, target, kind);
			links.push_back(l);
			nodes[n1].size++;
			nodes[n2].size++;
		} else {
			cout << "[Network::Network(\"" << conffile << "\")] Unknown type code '" << type << "'" << endl;
		}
	}

	/*double dx = maxx - minx;
	double dy = maxy - miny;
	double mxy = dy > dx ? dy : dx;
	scale = 10.0 / mxy;*/
	cx = (minx + maxx) / 2.0;
	cy = (miny + maxy) / 2.0;
	
	srand(time(0));
}

void Network::draw(int timer, double alpha) {
	static int first = 1;
	map<string, Node>::iterator ns;
	for(ns = nodes.begin(); ns != nodes.end(); ns++) {
		if (first) {
			ns->second.x -= cx;
			ns->second.y -= cy;
			/*ns->second.x *= scale;
			ns->second.y *= scale;*/
		}
		ns->second.draw(alpha);
	}

	list<Link>::iterator ls;
	for(ls = links.begin(); ls != links.end(); ls++) {
		if (first) {
			ls->x1 -= cx;
			ls->y1 -= cy;
			ls->x2 -= cx;
			ls->y2 -= cy;
			/*ls->x1 *= scale;
			ls->y1 *= scale;
			ls->x2 *= scale;
			ls->y2 *= scale;*/
		}
		ls->draw(timer);
	}
	first = 0;
}

Node Network::random_node() {
	int n  = rand() % nodes.size();
	map<string, Node>::const_iterator i = nodes.begin();
	for (int j = 0; j < n; j++)
		i++;
	cout << "[Network::random_node()] Random node: " << i->second.name << endl;
	return i->second;
}

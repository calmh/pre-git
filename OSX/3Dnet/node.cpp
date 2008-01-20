/*
 *  node.cpp
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
#include <math.h>
#include "node.h"

#include <iostream>

Node::Node() {
}

Node::Node(string name, double x, double y, int size) {
	this->name = name;
	this->x = x;
	this->y = y;
	this->size = size;
}


void Node::draw(double alpha) const {
	double text_size = 0.0005;
	glPushMatrix();

	if (size == 2)	
		glColor3f(0.7f, 0.7f, 0.5f);
	else
		glColor3f(1.0f, 1.0f, 1.0f);
	glTranslatef(y, 0.1f, x);
	GLUquadricObj* obj = gluNewQuadric();
	gluQuadricDrawStyle(obj, GLU_FILL);
	gluSphere(obj, size * 0.01, 20, 20);

	glDisable(GL_LIGHTING);
	glColor3f(1.0f, 1.0f, 1.0f);
	glTranslatef(0, 0.07f, 0);
	glScalef(text_size, text_size, text_size);
	glRotatef(-alpha * 180.0 / M_PI + 90, 0.0f, 1.0f, 0.0f);
	glTranslatef(name.length() * -35.0, 0.0, 0.0);
	glLineWidth(1.5f);
	for (const char* p = name.c_str(); *p; p++) {
		glutStrokeCharacter(GLUT_STROKE_ROMAN, *p);
	}
	glEnable(GL_LIGHTING);
	
	glPopMatrix();
}


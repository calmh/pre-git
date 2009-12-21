/*
 *  foot.cpp
 *  Human
 *
 *  $Id: //personal/projekt/OSX/Human/foot.cc#3 $
 *  $DateTime: 2005/08/07 08:27:11 $
 *  $Author: jb $
 *
 */

#include "foot.h"

#ifdef OS_DARWIN
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

Foot::Foot(side_t side) {
	ancle_a0 = 95;
	ancle_a1 = 0;
	width = 0.10;
	length = 0.21;
	thickness = 0.04;
	this->side = side;
}

void Foot::draw() {
	glPushMatrix();
	GLUquadricObj* obj = gluNewQuadric();
	glRotatef(ancle_a0, -1.0, 0.0, 0.0);
	glRotatef(side * ancle_a1, 0.0, 0.0, -1.0);
	glTranslatef(0.0, 0.0, length/2);
	glScalef(width, thickness, length);
	gluSphere(obj, 0.5, 10, 10);
	gluDeleteQuadric(obj);
	glPopMatrix();
}

void Foot::constrain() {
	// TODO: constrains
}

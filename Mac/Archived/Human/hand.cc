/*
 *  hand.cpp
 *  Human
 *
 *  $Id: //personal/projekt/OSX/Human/hand.cc#3 $
 *  $DateTime: 2005/08/07 08:27:11 $
 *  $Author: jb $
 *
 */

#include "hand.h"

#ifdef OS_DARWIN
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

Hand::Hand(side_t side) {
	wrist_a0 = 40;
	wrist_a1 = -40;
	width = 0.09;
	length = 0.16;
	thickness = 0.02;
	this->side = side;
}

void Hand::draw() {
	glPushMatrix();
	GLUquadricObj* obj = gluNewQuadric();
	glRotatef(side * wrist_a1, 0.0, 0.0, 1.0);
	glRotatef(wrist_a0, -1.0, 0.0, 0.0);
	glTranslatef(0.0, 0.0, length/2);
	glScalef(width, thickness, length);
	gluSphere(obj, 0.5, 10, 10);
	gluDeleteQuadric(obj);
	glPopMatrix();
}

void Hand::constrain() {
	// TODO: constrains
}

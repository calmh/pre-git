/*
 *  leg.cpp
 *  Human
 *
 *  $Id: //personal/projekt/OSX/Human/leg.cc#3 $
 *  $DateTime: 2005/08/07 08:27:11 $
 *  $Author: jb $
 *
 */

#include "leg.h"

#ifdef OS_DARWIN
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

Leg::Leg(side_t side) : foot(side)
{
	upper_l = 0.38;
	upper_w = 0.15;
	lower_l = 0.42;
	lower_w = 0.10;
	
	hip_a0 = 10;
	hip_a1 = 10;
	hip_a2 = 10;
	knee_a = 15;
	
	this->side = side;
}

void Leg::draw() {
	glPushMatrix();
	GLUquadricObj* obj = gluNewQuadric();
	
	// Rotate around shoulder
	glRotatef(hip_a0, -1.0, 0.0, 0.0);
	glRotatef(side * hip_a1, 0.0, -1.0, 0.0);
	glRotatef(side * hip_a2, 0.0, 0.0, 1.0);
	
	// Draw upper leg
	gluCylinder(obj, upper_w/2, upper_w/2, upper_l, 10, 10);
	glTranslatef(0.0, 0.0, upper_l);
	
	// Rotate elbow
	glRotatef(knee_a,  1.0, 0.0, 0.0);
	
	// Draw lower leg
	gluCylinder(obj, lower_w/2, lower_w/2, lower_l, 10, 10);
	glTranslatef(0.0, 0.0, lower_l);
	
	foot.draw();
	
	gluDeleteQuadric(obj);
	glPopMatrix();
}

void Leg::constrain() {
	// TODO: constrains
	
	foot.constrain();
}

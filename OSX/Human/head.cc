/*
 *  head.cpp
 *  Human
 *
 *  $Id: //personal/projekt/OSX/Human/head.cc#3 $
 *  $DateTime: 2005/08/07 08:27:11 $
 *  $Author: jb $
 *
 */

#include "head.h"

#ifdef OS_DARWIN
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

Head::Head() {
	neck_a0 = 10;
	neck_a1 = 0;
	neck_a2 = 0;
	
	neck_height = 0.10;
	neck_width = 0.10;

	head_width = 0.19;
	head_height = 0.20;
	head_depth = 0.23;
}

void Head::draw() {
	glPushMatrix();
	GLUquadricObj* obj = gluNewQuadric();
	glRotatef(neck_a0, -1.0, 0.0, 0.0);
	glRotatef(neck_a1, 0.0, 1.0, 0.0);
	glRotatef(neck_a2, 0.0, 0.0, 1.0);
	gluCylinder(obj, neck_width/2, neck_width/2, neck_height, 10, 10);
	glTranslatef(0.0, 0.0, neck_height + head_height/2);
	glScalef(head_width, head_depth, head_height);
	gluSphere(obj, 0.5, 10, 10);
	gluDeleteQuadric(obj);
	glPopMatrix();
}

void Head::constrain() {
	// TODO: constrains
}

/*
 *  torso.cpp
 *  Human
 *
 *  $Id: //personal/projekt/OSX/Human/torso.cc#3 $
 *  $DateTime: 2005/08/07 08:27:11 $
 *  $Author: jb $
 *
 */

#include "torso.h"

#ifdef OS_DARWIN
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

Torso::Torso() : left_arm(left), right_arm(right), left_leg(left), right_leg(right)
{
	height = 0.52;
	shoulder_width = 0.40;
	hip_width = 0.24; 
}

void Torso::draw() {
	glPushMatrix();
	GLUquadricObj* obj = gluNewQuadric();

	// Torso
	glColor3f(192.0/256, 160.0/256, 140.0/256);
	glRotatef(-90, 1.0, 0.0, 0.0);
	glPushMatrix();
	glScalef(1.0, 0.5, 1.0);
	gluCylinder(obj, hip_width/2.2, shoulder_width/2.2, height, 10, 10);
	glPopMatrix();
	
	// Shoulders
	glPushMatrix();
	glTranslatef(0.0, 0.0, height);
	glRotatef(90, 0.0, 1.0, 0.0);
	glTranslatef(0.0, 0.0, -shoulder_width/2.0);
	gluCylinder(obj, shoulder_width/10.0, shoulder_width/10.0, shoulder_width, 10, 10);

	// Head
	glPushMatrix();
	glTranslatef(0.0, 0.0, shoulder_width/2);
	glRotatef(-90, 0.0, 1.0, 0.0);
	head.draw();
	glPopMatrix();
	
	// Left Arm
	glPushMatrix();
	glRotatef(90, 0.0, 1.0, 0.0);
	left_arm.draw();
	glPopMatrix();
	
	// Right Arm
	glPushMatrix();
	glTranslatef(0.0, 0.0, shoulder_width);
	glRotatef(90, 0.0, 1.0, 0.0);
	right_arm.draw();
	glPopMatrix();
	glPopMatrix();

	// Hip
	glPushMatrix();
	glRotatef(90, 0.0, 1.0, 0.0);
	glTranslatef(0.0, 0.0, -hip_width/2);
	gluCylinder(obj, hip_width/10.0, hip_width/10.0, hip_width, 10, 10);

	// Left Leg
	glPushMatrix();
	glRotatef(90, 0.0, 1.0, 0.0);
	left_leg.draw();
	glPopMatrix();
	
	// Right Leg
	glPushMatrix();
	glTranslatef(0.0, 0.0, hip_width);
	glRotatef(90, 0.0, 1.0, 0.0);
	right_leg.draw();
	glPopMatrix();
	glPopMatrix();
	
	gluDeleteQuadric(obj);
	glPopMatrix();
}

void Torso::constrain() {
	// TODO: constrains
	
	head.constrain();

	right_arm.constrain();
	left_arm.constrain();
	
	right_leg.constrain();
	left_leg.constrain();
}

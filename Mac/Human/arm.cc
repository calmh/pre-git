/*
 *  arm.cpp
 *  Human
 *
 *  $Id: //personal/projekt/OSX/Human/arm.cc#3 $
 *  $DateTime: 2005/08/07 08:27:11 $
 *  $Author: jb $
 *
 */

#include <math.h>
#ifdef OS_DARWIN
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

#include "arm.h"

/*
** Modellerar en arm.
** Har parametrar för:
** - Överarms medeltjocklek och längd
** - Underarms medeltjocklek och längd
** - Tre vinklar vid axel, en vid armbåge
*/

Arm::Arm(side_t side) : hand(side)
{
	upper_l = 0.25;
	upper_w = 0.10;
	lower_l = 0.25;
	lower_w = 0.07;
	shoulder_a0 = 10;
	shoulder_a1 = 25;
	shoulder_a2 = -60;
	elbow_a = 45;
	this->side = side;
}

void Arm::draw() {
	glPushMatrix();
	GLUquadricObj* obj = gluNewQuadric();

	// Rotate around shoulder
	glRotatef(shoulder_a0, -1.0, 0.0, 0.0);
	glRotatef(side * shoulder_a1, 0.0, -1.0, 0.0);
	glRotatef(side * shoulder_a2, 0.0, 0.0, 1.0);
	
	// Draw upper arm
	gluCylinder(obj, upper_w/2, upper_w/2, upper_l, 10, 10);
	glTranslatef(0.0, 0.0, upper_l);
	
	// Rotate elbow
	glRotatef(elbow_a,  -1.0, 0.0, 0.0);
	
	// Draw lower arm
	gluCylinder(obj, lower_w/2, lower_w/2, lower_l, 10, 10);
	glTranslatef(0.0, 0.0, lower_l);
	
	hand.draw();
	
	gluDeleteQuadric(obj);
	glPopMatrix();
}

void Arm::constrain() {
	shoulder_a0 = fmax(shoulder_a0, -70); // behind shoulder
	shoulder_a0 = fmin(shoulder_a0, 180); // straight up
	shoulder_a1 = fmax(shoulder_a1, -60); // in front of chest
	shoulder_a1 = fmin(shoulder_a1, 90); // straight out
	shoulder_a2 = fmax(shoulder_a2, -45);
	shoulder_a2 = fmin(shoulder_a2, 90);
	
	elbow_a = fmax(elbow_a, 0); // cant bend outwards
	elbow_a = fmin(elbow_a, 170); // cant bend past biceps

	hand.constrain();
}

/*
Point Arm::calculate_position(double angles[]) {
	Triple p;
	p.x = upper_l * cos(angles[1]) * cos(angles[0]);
	p.y = upper_l * cos(angles[1]) * sin(angles[0]);
	p.z = upper_l * sin(angles[1]);

	p.x = lower_l * cos(angles[1]) * cos(angles[0]);
	p.y = lower_l * cos(angles[1]) * sin(angles[0]);
	p.z = lower_l * sin(angles[1]);	
}
*/

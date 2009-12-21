/*
 *  link.cpp
 *  3Dnet
 *
 *  Created by Jakob Borg on 2005-10-28.
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
#include "link.h"
#include <iostream>
#include "statsreader.h"
using namespace std;

Link::Link() {
}

/*
 * Create a Link between two points (x1, y1), (x2, y2) with a target to query for usage status and a "kind".
 * The "kind" is actually an integer that describes the curve of the link. Positive values cause an upwards
 * curve that could indicate a wireless link, while negative values cause a negative curve that might
 * indicate a sea cable. A default kind of 0 indicates no curve.
 */
Link::Link(double x1, double y1, double x2, double y2, int capacity, string target, int kind = 0) {
	this->x1 = x1;
	this->y1 = y1;
	this->x2 = x2;
	this->y2 = y2;
	this->capacity = capacity;
	this->target = target;
	this->kind = kind;

	double* usage = StatsReader::instance()->usage(target);
	uin = usage[0];
	uout = usage[1];
}

/*
 * Draw the link. "Timer" is a monotonically increasing integer that is used for timing animations etc.
 */
void Link::draw(int timer) {
	if (rand() % 5000 == 0) { // At random times, recheck usage.
		double* usage = StatsReader::instance()->usage(target);
		uin = usage[0];
		uout = usage[1];
	}
	double relusage = fabs(max(uin, uout) / capacity); // Relative usage [0, inf[
	double relusage_in = fabs(uin / capacity);
	double relusage_out = fabs(uout / capacity);

	glPushMatrix();
	
	float dx = x1 - x2;
	float dy = y1 - y2;
	float mx = x1 - dx / 2.0;
	float my = y1 - dy / 2.0;
	
	float angle = atan(dy / dx) * 180.0 / M_PI;
	float len = sqrt(dx * dx + dy * dy);
	float rad = log10((double) capacity) * 0.007; // "Thickness" of link as a function of capacity
	float textoffset_in = (timer * 0.035) * sqrt(uin / capacity); // Texture offset as a function of timer and usage, to cause "flowing data"-effect.
	float textoffset_out = (timer * 0.035) * sqrt(uout / capacity);
	if (dx < 0) { // change coordinate directions if necessary
		textoffset_in = -textoffset_in;
		textoffset_out = -textoffset_out;
	}

	glTranslatef(my, 0.1f, mx); // above the floow
	if (relusage > 0.75) { // Usage > 75%, time to indicate a warning
		if (relusage > 0.95) // Above 95%, the color is flashing red
			glColor3f(1.0 - 0.02 * (timer % 25), 0.0, 0.0);
		else // ... otherwise yellow, flashing at a slower rate
			glColor3f(1.0 - 0.005 * (timer % 50), 1.0 - 0.005 * (timer % 50), 0.0);

		// Create an exclamation point.
		glPushMatrix();
		glTranslatef(0.0, 0.2 + kind * 0.2, 0.0);
		GLUquadricObj* obj = gluNewQuadric();
		gluSphere(obj, 0.016, 20, 20);
		glTranslatef(0.0, 0.1, 0.0);
		glScalef(1.0, 4.0, 1.0);
		gluSphere(obj, 0.02, 20, 20);
		glPopMatrix();
	}
	glRotatef(angle, 0.0f, 1.0f, 0.0f);
	glTranslatef(0.0f, 0.0f, -len/2.0f);
	glBindTexture(GL_TEXTURE_2D, 1);

	glBegin(GL_QUADS);
	if (kind == 0) {
		if (relusage < 0.001) // Less than 0.1% usage is nothing, indicate link unused
			glColor4f(0.5f, 0.5f, 1.0f, 0.4f);
		else // ... otherwise color by usage
			glColor4f(relusage_in, 1.0 - sqrt(relusage_in) / 2.0, 0.5, 1.0f);
		glNormal3f( 0.0f, 0.0f, 0.5f);                            
		glTexCoord2f(0.0f, 0.0 - textoffset_in); glVertex3f(-rad, 0.0, 0.0);
		glTexCoord2f(1.0f, 0.0 -textoffset_in); glVertex3f( -0.003, 0.0, 0.0);
		glTexCoord2f(1.0f, len - textoffset_in); glVertex3f(-0.003, 0.0, len);
		glTexCoord2f(0.0f, len - textoffset_in); glVertex3f(-rad, 0.0, len);
	
		if (relusage < 0.001)
			glColor4f(0.5f, 0.5f, 1.0f, 0.4f);
		else
			glColor4f(relusage_out, 1.0 - sqrt(relusage_out) / 2.0, 0.5, 1.0f);
		glNormal3f( 0.0f, 0.0f, 0.5f);                            
		glTexCoord2f(0.0f, 0.0 + textoffset_out); glVertex3f(0.003, 0.0, 0.0);
		glTexCoord2f(1.0f, 0.0 + textoffset_out); glVertex3f( rad, 0.0, 0.0);
		glTexCoord2f(1.0f, len + textoffset_out); glVertex3f( rad, 0.0, len);
		glTexCoord2f(0.0f, len + textoffset_out); glVertex3f(0.003, 0.0, len);
	} else {
		const int segments = 15 * abs(kind);
		for (int i = 0; i < segments; i++) {
			// Use a simple quadratic function for the curve.
			double l1 = len/segments * i;
			double l2 = len/segments * (i + 1);
			double h1 = (-((l1 - len/2.0) * (l1 - len/2.0)) + (len/2.0 * len/2.0)) * 0.2 * kind;
			double h2 = (-((l2 - len/2.0) * (l2 - len/2.0)) + (len/2.0 * len/2.0)) * 0.2 * kind;
			
			if (relusage < 0.001)
				glColor4f(0.5f, 0.5f, 1.0f, 0.4f);
			else
				glColor4f(relusage_in, 1.0 - sqrt(relusage_in) / 2.0, 0.5, 1.0f);
			glNormal3f( 0.0f, 0.0f, 0.5f);                            
			glTexCoord2f(0.0f, l1 - textoffset_in); glVertex3f(-rad, h1, l1);
			glTexCoord2f(1.0f, l1 - textoffset_in); glVertex3f(-rad/10.0, h1, l1);
			glTexCoord2f(1.0f, l2 - textoffset_in); glVertex3f(-rad/10.0, h2, l2);
			glTexCoord2f(0.0f, l2 - textoffset_in); glVertex3f(-rad, h2, l2);
			
			if (relusage < 0.001)
				glColor4f(0.5f, 0.5f, 1.0f, 0.4f);
			else
				glColor4f(relusage_out, 1.0 - sqrt(relusage_out) / 2.0, 0.5, 1.0f);
			glNormal3f( 0.0f, 0.0f, 0.5f);                            
			glTexCoord2f(0.0f, l1 + textoffset_out); glVertex3f(rad/10.0, h1, l1);
			glTexCoord2f(1.0f, l1 + textoffset_out); glVertex3f( rad, h1, l1);
			glTexCoord2f(1.0f, l2 + textoffset_out); glVertex3f( rad, h2, l2);
			glTexCoord2f(0.0f, l2 + textoffset_out); glVertex3f(rad/10.0, h2, l2);
		}
	}
	glEnd();
	glBindTexture(GL_TEXTURE_2D, 0);
	
	glPopMatrix();
}

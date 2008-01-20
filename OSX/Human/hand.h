/*
 *  hand.h
 *  Human
 *
 *  $Id: //personal/projekt/OSX/Human/hand.h#6 $
 *  $DateTime: 2005/08/07 08:27:11 $
 *  $Author: jb $
 *
 */

#ifndef HAND_H
#define HAND_H

#include "drawable.h"
#include "constrained.h"
#include "common.h"

class Hand : Drawable, Constrained {
public:
	double wrist_a0; // angle upward at wrist
	double wrist_a1; // rotation outward
	
	double length; // from wrist to fingertips
	double width; // thumb to pinky
	double thickness; // some kind of average
	
	side_t side;
	
	Hand(side_t);
	void draw();
	void constrain();
};

#endif

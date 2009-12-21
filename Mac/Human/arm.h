/*
 *  arm.h
 *  Human
 *
 *  $Id: //personal/projekt/OSX/Human/arm.h#6 $
 *  $DateTime: 2005/08/07 08:27:11 $
 *  $Author: jb $
 *
 */

#ifndef ARM_H
#define ARM_H

#include "drawable.h"
#include "constrained.h"
#include "common.h"
#include "hand.h"

class Arm : Drawable, Constrained {
public:
	double upper_l; // length of upper arm
	double upper_w; // width of upper arm
	double lower_l; // length of lower arm
	double lower_w; // width of lower arm
	
	double shoulder_a0; // angle forward at shoulder
	double shoulder_a1; // angle outward at shoulder
	double shoulder_a2; // twist outward at shoulder
	
	double elbow_a; // angle at elbow
	
	side_t side;
	Hand hand;
	
	Arm(side_t side);
	void draw();
	void constrain();
};

#endif

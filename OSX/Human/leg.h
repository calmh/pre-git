/*
 *  leg.h
 *  Human
 *
 *  $Id: //personal/projekt/OSX/Human/leg.h#6 $
 *  $DateTime: 2005/08/07 08:27:11 $
 *  $Author: jb $
 *
 */

#ifndef LEG_H
#define LEG_H

#include "drawable.h"
#include "constrained.h"
#include "common.h"
#include "foot.h"

class Leg : Drawable, Constrained {
public:
	double upper_l; // length of upper leg
	double upper_w; // width
	double lower_l; // length of lower leg
	double lower_w; // width
	
	double hip_a0; // angle forward at hip
	double hip_a1; // angle outward at hip
	double hip_a2; // twist outward at hip
	
	double knee_a; // angle at knee
	
	Foot foot;
	
	side_t side;
	
	Leg(side_t side);
	void draw();
	void constrain();
};

#endif

/*
 *  torso.h
 *  Human
 *
 *  $Id: //personal/projekt/OSX/Human/torso.h#6 $
 *  $DateTime: 2005/08/07 08:27:11 $
 *  $Author: jb $
 *
 */

#ifndef TORSO_H
#define TORSO_H

#include "drawable.h"
#include "constrained.h"

#include "head.h"
#include "arm.h"
#include "leg.h"

class Torso : Drawable, Constrained {
protected:
	double shoulder_width; // distance between shoulder joints
	double hip_width; // distance between hip joints
	double height; // distance from hip bone to collar bone
	
	Head head;

	Arm left_arm;
	Arm right_arm;
	
	Leg left_leg;
	Leg right_leg;

public:
	Torso();
	void draw();
	void constrain();
};

#endif

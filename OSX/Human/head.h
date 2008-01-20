/*
 *  head.h
 *  Human
 *
 *  $Id: //personal/projekt/OSX/Human/head.h#6 $
 *  $DateTime: 2005/08/07 08:27:11 $
 *  $Author: jb $
 *
 */

#ifndef HEAD_H
#define HEAD_H

#include "drawable.h"
#include "constrained.h"

class Head : Drawable, Constrained {
public:
	double neck_a0; // angle forward
	double neck_a1; // angle right
	double neck_a2; // twist right
	
	double neck_height; // collar bone to cheek
	double neck_width; // obvious
	
	double head_height; // cheek to top of head
	double head_width; // ear to ear
	double head_depth; // nose to back of head
	
	Head();
	void draw();
	void constrain();
};

#endif

/*
 *  positionable.cpp
 *  Human
 *
 *  $Id: //personal/projekt/OSX/Human/positionable.cc#3 $
 *  $DateTime: 2005/08/07 08:27:11 $
 *  $Author: jb $
 *
 */

#include <math.h>

#include "positionable.h"

Positionable::~Positionable() {
}

double Positionable::calculate_error(double angles[], Point target) {
	Point current = calculate_position(angles);
	double dx = target.x - current.x;
	double dy = target.y - current.y;
	double dz = target.z - current.z;
	return sqrt(dx * dx + dy * dy + dz * dz);
}

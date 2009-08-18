/*
 *  positionable.h
 *  Human
 *
 *  $Id: //personal/projekt/OSX/Human/positionable.h#3 $
 *  $DateTime: 2005/08/07 08:27:11 $
 *  $Author: jb $
 *
 */

#ifndef POSITIONABLE_H
#define POSITIONABLE_H

class Point {
public:
	double x, y, z;
};

class Positionable {
public:
	virtual Point calculate_position(double angles[]) = 0;
	double calculate_error(double angles[], Point target);
	virtual ~Positionable();
};

#endif

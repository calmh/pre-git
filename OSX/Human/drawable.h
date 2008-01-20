/*
 *  drawable.h
 *  Human
 *
 *  $Id: //personal/projekt/OSX/Human/drawable.h#6 $
 *  $DateTime: 2005/08/07 08:27:11 $
 *  $Author: jb $
 *
 */

#ifndef DRAWABLE_H
#define DRAWABLE_H

class Drawable {
public:
	virtual void draw() = 0;
	virtual ~Drawable();
};

#endif

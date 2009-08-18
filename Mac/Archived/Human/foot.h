/*
 *  foot.h
 *  Human
 *
 *  $Id: //personal/projekt/OSX/Human/foot.h#6 $
 *  $DateTime: 2005/08/07 08:27:11 $
 *  $Author: jb $
 *
 */

#ifndef FOOT_H
#define FOOT_H

#include "drawable.h"
#include "constrained.h"
#include "common.h"

class Foot : Drawable, Constrained {
public:
    double ancle_a0; // angle upward at wrist
    double ancle_a1; // rotation outward
    
    double length; // from ancle to tip of toes
    double width; // ...width
    double thickness; // some kind of average
    
    side_t side;
    
    Foot(side_t);
    void draw();
    void constrain();
};

#endif

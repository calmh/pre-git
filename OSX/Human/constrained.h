/*
 *  constrained.h
 *  Human
 *
 *  $Id: //personal/projekt/OSX/Human/constrained.h#6 $
 *  $DateTime: 2005/08/07 08:27:11 $
 *  $Author: jb $
 *
 */

#ifndef CONSTRAINED_H
#define CONSTRAINED_H

/*
** Hanterar begränsning av leder till deras fysiskt möjliga vinklar.
*/

class Constrained {
public:
	virtual void constrain() = 0;
	virtual ~Constrained();
};

#endif

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
** Hanterar begr�nsning av leder till deras fysiskt m�jliga vinklar.
*/

class Constrained {
public:
	virtual void constrain() = 0;
	virtual ~Constrained();
};

#endif

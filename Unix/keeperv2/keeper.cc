/** (c) 2000 Jakob Borg
 **
 ** This file has common utility functions
 **
 ** This program is free software; you can redistribute it and/or modify
 ** it under the terms of the GNU General Public License as published by
 ** the Free Software Foundation; either version 2 of the License, or
 ** (at your option) any later version.
 **
 ** This program is distributed in the hope that it will be useful,
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ** GNU General Public License for more details.
 **
 ** You should have received a copy of the GNU General Public License
 ** along with this program; if not, write to the Free Software
 ** Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 **
 ** $Id: keeper.cc,v 1.1.1.1 2003/03/01 12:55:11 jb Exp $
 **/

#include <cstdio>
#include <string>

#include "keeper.h"

string i2str(int v)
{
	char str[20];
	sprintf(str, "%d", v);
	return string(str);
}

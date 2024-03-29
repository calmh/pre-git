
/* this file is a part of amp software, (C) tomislav uzelac 1996,1997
 */

/* dump.c  binary/hex dump from buffer

 * Created by: tomislav uzelac  May 1996
 * Last modified by: tomislav May 31 1997
 */
#include <unistd.h>
#include <string.h>

#include "audio.h"
#include "getbits.h"

#define DUMP
#include "dump.h"

/* no hex dump, sorry
 */
void dump(int *length)
{				/* in fact int length[4] */
	int i, j;
	int _data, space = 0;
	printf(" *********** binary dump\n");
	_data = data;
	for (i = 0; i < 4; i++) {
		for (j = 0; j < space; j++)
			printf(" ");
		for (j = 0; j < length[i]; j++) {
			printf("%1d", (buffer[_data / 8] >> (7 - (_data & 7))) & 1);
			space++;
			_data++;
			_data &= 8 * BUFFER_SIZE - 1;
			if (!(_data & 7)) {
				printf(" ");
				space++;
				if (space > 70) {
					printf("\n");
					space = 0;
				}
			}
		}
		printf("~\n");
	}
}

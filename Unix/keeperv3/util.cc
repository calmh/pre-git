#include "util.h"
#include <strstream>
#include <cstdio>

string to_str(int v)
{
	char tmp[14];
	sprintf(tmp, "%d", v);
	return string(tmp);
}

int parse_int(string v)
{
        istrstream tmp1(v.c_str());
        int tmp2;
        tmp1 >> tmp2;
        return tmp2;
}

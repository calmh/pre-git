#!/usr/bin/python

import mmap, sys

def map_file(name):
	fd = file(name, "r")
	fd.seek(0, 2)
	flen = fd.tell()
	fd.seek(0, 0)
	fn = fd.fileno()
	map = mmap.mmap(fn, flen, prot=mmap.PROT_READ)
	return map

def find_jpegs(map, pattern):
	header = chr(255) + chr(216) + chr(255) + chr(225)
	i, o1, o2 = 0, 0, 0
	while 1:
		o2 = map.find(header, o2 + 4)
		print o2
		if o1 != 0:
			i += 1
			map.seek(o1)
			rf = file(pattern%i, "w")
			rf.write(map.read(o2 - o1))
			rf.close()
		o1 = o2

if __name__ == "__main__":
	map = map_file(sys.argv[1])
	find_jpegs(map, "tmp/recover-%d.jpg")


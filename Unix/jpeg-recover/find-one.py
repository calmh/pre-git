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

def find_jpegs(map, offset):
	SOI = chr(0xFF) + chr(0xD8)
	EOI = chr(0xFF) + chr(0xD9)
	SOS = chr(0xFF) + chr(0XDA)
	offset = map.find(SOI, offset) + 2
	print "%d: SOI"%(offset - 2)
	map.seek(offset)
	sos = 0
	image = SOI
	while 1:
		if sos:
			b0 = map.read_byte()
			image += b0
			offset += 1
			if b0 == chr(0xff):
				b1 = map.read_byte()
				image += b1
				offset += 1
				if b1 == chr(0):
					continue
				marker = b0 + b1
			else:
				continue
		else:
			marker = map.read(2)
			image += marker
			offset += 2

		print "%02X%02X"%(ord(marker[0]), ord(marker[1]))
		if marker == EOI:
			print " - done"
			return (offset, image)
		if marker == SOS:
			sos = 1
		if marker[0] != chr(0xff):
			print " - invalid jfif marker"
			return (offset, None)
		lenb = map.read(2)
		image += lenb
		offset += 2
		len = ord(lenb[0])* 256 + ord(lenb[1])
		image += map.read(len - 2)
		offset += len - 2

if __name__ == "__main__":
	map = map_file(sys.argv[1])
	offset = 0
	image = None
	while image == None:
		(offset, image) = find_jpegs(map, offset)
	foo = file("test.jpg","w")
	foo.write(image)
	foo.close()


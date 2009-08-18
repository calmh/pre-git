//
//  CanonRAW.m
//  XDownloader
//
//  Created by Jakob Borg on 2005-07-08.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "CanonRAW.h"
#import "Nym.Foundation/NymLogger.h"

@interface CanonRAW (Private)
+ (int) findBytes: (unsigned char*) sequence 
	 ofLength: (int) seqLen
       amongBytes: (unsigned char*) bytes
       withLength: (int) length
	andOffset: (int) offset;
+ (unsigned char*) readMarker: (unsigned char*) bytes;
+ (int) readLength: (unsigned char*) bytes;
@end

@implementation CanonRAW (Private)
+ (int) findBytes: (unsigned char*) sequence
	 ofLength: (int) seqLen
       amongBytes: (unsigned char*) bytes
       withLength: (int) length
	andOffset: (int) offset
{
	NFLog(@"findBytes");
	int i;
	for (i = offset; i < length - seqLen; i++) {
		int j;
		for (j = 0; j < seqLen; j++)
			if (sequence[j] != bytes[i + j])
				break;
		
		if (j == seqLen)
			return i;
	}
	
	return -1;
}

+ (unsigned char*) readMarker: (unsigned char*) bytes
{
	NFLog(@"readMarker");
	unsigned char* marker = malloc(2);
	NFAssert(marker);
	marker[0] = bytes[0];
	marker[1] = bytes[1];
	return marker;
}

+ (int) readLength: (unsigned char*) bytes
{
	NFLog(@"readLength");
	int l0 = bytes[0];
	int l1 = bytes[1];
	return l0 * 256 + l1;
}
@end

@implementation CanonRAW
+ (NSData*) extractJpegFromRaw: (NSString*) filename
{
	NFLog(@"extractJpegFromRaw");
	NFAssert(filename);
	
	const unsigned char SOI[2] = { 0xff, 0xD8 };
	const unsigned char EOI[2] = { 0xff, 0xD9 };
	const unsigned char SOS[2] = { 0xff, 0xDA };
	
	NFLog(@"- Processing %@", filename);
	NSData* rawFile = [NSData dataWithContentsOfFile: filename];
	NFAssert(rawFile);
	
	int offset = 0;
	
	while (true) {
		NSMutableArray* segments = [[NSMutableArray alloc] init];
		
		// Find SOI
		offset = [CanonRAW findBytes: (unsigned char*) SOI ofLength: 2 amongBytes: (unsigned char*) [rawFile bytes] withLength: [rawFile length] andOffset: offset];
		[segments addObject: [NSData dataWithBytes: SOI length: 2]];
		NFLog(@"- SOI found at %d", offset);
		offset += 2;
		if (offset == -1) // Not found
			return nil;
		
		int scanning = false;
		while (true) {
			if (scanning) {
				NFLog(@"- Scanning...");
				int offset1 = offset;
				while (offset1 < [rawFile length]) {
					if (((unsigned char*) [rawFile bytes])[offset1] == 0xff)
						if (((unsigned char*) [rawFile bytes])[offset1 + 1] != 0x00)
							break;
					offset1++;
				}
				int scanLen = offset1 - offset;
				unsigned char* data = malloc(scanLen);
				[rawFile getBytes:data range:NSMakeRange(offset, scanLen)];
				[segments addObject: [NSData dataWithBytes:data length:scanLen]];
				offset += scanLen;			
				NFLog(@" - Scanned for %d bytes", scanLen);
				scanning = 0;
			}
			
			unsigned char* marker = [CanonRAW readMarker: (unsigned char*) [rawFile bytes] + offset];
			if (marker[0] != 0xff) { // Not valid JFIF
				[segments release];
				break;
			}
			[segments addObject: [NSData dataWithBytes: marker length: 2]];
			offset += 2;
			NFLog(@" - Found marker %02X%02X", marker[0], marker[1]);
			
			if (marker[1] == EOI[1]) {
				NFLog(@" - Got EOI");
				NSMutableData* md = [[NSMutableData alloc] init];
				NSEnumerator* e = [segments objectEnumerator];
				NSData* d;
				while (d = [e nextObject])
					[md appendData: d];
				[segments release];
				return md;
			}
			
			int len = [CanonRAW readLength: (unsigned char*) [rawFile bytes] + offset];
			unsigned char* lenb = malloc(2);
			lenb[0] = len / 256;
			lenb[1] = len % 256;
			[segments addObject: [NSData dataWithBytes: lenb length: 2]];
			offset += 2;
			
			unsigned char* data = malloc(len - 2);
			[rawFile getBytes:data range:NSMakeRange(offset, len - 2)];
			[segments addObject: [NSData dataWithBytes:data length:len - 2]];
			offset += len - 2;	
			NFLog(@" - Read %d bytes segment", len);
			
			if (marker[1] == SOS[1]) {
				scanning = 1;
			}
		}
	}
	
	return nil;
}

@end

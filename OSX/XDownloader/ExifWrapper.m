//
//  ExifWrapper.m
//  XDownloader
//
//  Created by Jakob Borg on 2005-05-30.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "ExifWrapper.h"
#import "Nym.Foundation/NymLogger.h"

static NSString* exiftags;

@implementation ExifWrapper
-(id) initWithFilename: (NSString*) filename {
	[super init];
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NFLog(@"initWithFilename");
	NFAssert(filename);
	
	// Prepare the dictionary in which we store the EXIF data.
	exifData = [[NSMutableDictionary alloc] init];
	NFAssert(exifData);

	if (exiftags == nil) {
		// Find the location of the bundled exiftags binary.
		NFLog(@"Searching for exiftags");
		CFURLRef rel_url = CFBundleCopyAuxiliaryExecutableURL(CFBundleGetMainBundle(), CFSTR("exiftags"));
		NFAssert(rel_url);
		CFURLRef abs_url = CFURLCopyAbsoluteURL(rel_url);
		NFAssert(abs_url);
		exiftags = (NSString*) CFURLCopyFileSystemPath(abs_url, kCFURLPOSIXPathStyle);
		NFAssert(exiftags);
		CFRelease(abs_url);
		CFRelease(rel_url);
	}
	
	// Create and start exiftags.
	NSTask *theTask = [[NSTask alloc] init];
	NFAssert(theTask);
	NSPipe *taskPipe = [[NSPipe alloc] init];
	NFAssert(taskPipe);
	[theTask setStandardError:taskPipe];
	[theTask setStandardOutput:taskPipe];
	[theTask setLaunchPath:exiftags];
	[theTask setArguments:[ NSArray arrayWithObject:filename ]];
	[theTask launch];
	[theTask waitUntilExit];
		
	// Read all output from exiftags, the release the resources.
	NSMutableString* res = [[NSMutableString alloc] init];	
	NFAssert(res);
	NSData *inData;
	NSFileHandle* readHandle = [taskPipe fileHandleForReading];
	NFAssert(readHandle);
	while ((inData = [readHandle availableData]) && [inData length]) {
	NFAssert(res);
		NFAssert(inData);
		[res appendString: [[NSString alloc] initWithBytes: [inData bytes] length: [inData length] encoding: NSISOLatin1StringEncoding]];
	}
	
	[taskPipe release];
	taskPipe = nil;
	[theTask release];
	theTask = nil;

	// Split the result into line and enumerate them.
	NSArray* lines = [res componentsSeparatedByString: @"\n"];
	NFAssert(lines);
	NSEnumerator* enu = [lines objectEnumerator];
	NFAssert(enu);
	NSString* line;
	while (line = [enu nextObject]) {
		// Split the line into the key and data parts, separated by ": ". This makes certain assumptions about exiftags output that seem to be true at the moment at least...
		NSArray* fields = [line componentsSeparatedByString: @": "];
		NFAssert(fields);
		if ([fields count] < 2)
			continue;

		// Take the first field as key, and remove any spaces from it.
		NSMutableString* mkey = [NSMutableString stringWithString: [fields objectAtIndex: 0]];
		NFAssert(mkey);
		[mkey replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, [mkey length])];
		NSString* key = [NSString stringWithString: mkey];
		NFAssert(key);

		// The second field is the data.
		NSString* data = [fields objectAtIndex: 1];
		NFAssert(data);

		// Set the data.
		NFAssert(exifData);
		[exifData setObject:data forKey:key];
		
		// If we found the date, split it into extra fields
		if ([key compare: @"ImageCreated"] == NSOrderedSame) {
			[exifData setObject:[data substringWithRange:NSMakeRange(0,4)] forKey:@"Year"];
			[exifData setObject:[data substringWithRange:NSMakeRange(5,2)] forKey:@"Month"];
			[exifData setObject:[data substringWithRange:NSMakeRange(8,2)] forKey:@"Day"];
			[exifData setObject:[data substringWithRange:NSMakeRange(11,2)] forKey:@"Hour"];
			[exifData setObject:[data substringWithRange:NSMakeRange(14,2)] forKey:@"Minute"];
			[exifData setObject:[data substringWithRange:NSMakeRange(17,2)] forKey:@"Second"];
		}
	}

	[pool release];
	return self;
}

-(void) dealloc {
	NFLog(@"dealloc");
	[exifData release];
	exifData = nil;
	[super dealloc];
}

-(NSDictionary*) exifFields {
	NFLog(@"exifFields");
	NSDictionary* dic = [exifData copy];
	NFAssert(dic);
	[dic autorelease];
	return dic;
}
@end

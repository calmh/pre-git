//
//  testExifWrapper.m
//  XDownloader
//
//  Created by Jakob Borg on 2005-08-11.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "testExifWrapper.h"
#import "ExifWrapper.h"

@implementation testExifWrapper

- (void) testInitWithFilename
{
	ExifWrapper* wrap;
	STAssertNoThrow(wrap = [[ExifWrapper alloc] initWithFilename:@"test.crw"], @"Caught exception");
}

@end

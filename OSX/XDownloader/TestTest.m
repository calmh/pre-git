//
//  TestTest.m
//  XDownloader
//
//  Created by Jakob Borg on 2005-08-10.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "TestTest.h"

@implementation TestTest

- (void) testSucceeds {
	STAssertEquals(12, 12, @"Foo");
}

- (void) testFails {
	STAssertEquals(12, 13, @"Foo");
}

@end

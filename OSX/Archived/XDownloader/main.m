//
//  main.m
//  XDownloader
//
//  Created by Jakob Borg on 2005-05-25.
//  Copyright __MyCompanyName__ 2005. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Nym.Foundation/NymLogger.h"

int main(int argc, char *argv[])
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	[[NymLogger sharedLogger] openLogFile: @"XDownloader.log"];
	
	NFLog(@"Version: %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]);
	NFLog(@"Build: %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]);
	[pool release];

	@try {
		return NSApplicationMain(argc,  (const char **) argv);
	} @catch (NSException* exception) {
		NFLog(@"main: Caught %@: %@", [exception name], [exception reason]);
		NSEnumerator* e = [[exception userInfo] keyEnumerator];
		NSString* key;
		while (key = [e nextObject]) {
			NFLog(@"main: %@: %@", key, [[exception userInfo] objectForKey: key]);
		}
	}
	
	return 0;
}

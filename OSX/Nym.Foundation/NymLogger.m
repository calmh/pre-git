//
//  DebugLogger.m
//  Nym.Logging
//
//  Created by Jakob Borg on 2005-06-19.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NymLogger.h"

static char* NFDebugLevels[] = { "CRITICAL", "INFO", "DEBUG", "ASSERT" };

@implementation NymLogger

+ (NymLogger*) sharedLogger {
	static NymLogger* instance = nil;
	if (instance == nil)
		instance = [[NymLogger alloc] init];
	return instance;
}

- (id) init {
	[super init];
	[self setDebugLevel: NFDEFAULTLEVEL];
	buffer = [[NSMutableData alloc] init];
	return self;
}

- (void) dealloc {
	[buffer dealloc];
	[super dealloc];
}

- (void) openLogFile: (NSString*) fileName {
	if (descriptor)
		fclose(descriptor);
	descriptor = fopen([[NSString stringWithFormat: @"/tmp/%@", fileName] cString], "w");
	if (!descriptor)
		descriptor = fopen([[[NSString stringWithFormat: @"~/%@", fileName] stringByExpandingTildeInPath] cString], "w");	
	[self logLine: [NSString stringWithFormat: @"Log file '%@' opened.", fileName] atLevel: debugLevel];
	NSNumber* num = [[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"debugLevel"];
	if (num)
		[self setDebugLevel: [num intValue]];
}

- (void) setDebugLevel: (int) level {
	[self logLine: [NSString stringWithFormat: @"Changing debugLevel from %s to %s", NFDebugLevels[debugLevel], NFDebugLevels[level]] atLevel: debugLevel];
	debugLevel = level;
}

- (int) debugLevel {
	return debugLevel;
}

- (void) logLine: (NSString*) line atLevel: (int) level {
	if (level <= debugLevel) {
		NSString* tl = [NSString stringWithFormat: @"%s %@\n", NFDebugLevels[level], line];
		[buffer appendData: [NSData dataWithBytes:[tl lossyCString] length:[tl cStringLength]]];
		if (descriptor) {
			fwrite([tl lossyCString], [tl cStringLength], 1, descriptor);
			fflush(descriptor);
		}
		NSLog(tl);
	}
}

- (void) assert: (bool) condition atPosition: (NSString*) pos withAssertStr: (NSString*) assertStr andMessage: (NSString*) message {
	[self logLine: [NSString stringWithFormat: @"%@: Asserting '%@'", pos, assertStr] atLevel: NFASSERT];
	if (!condition) {
		if (message)
			[self logLine: [NSString stringWithFormat: @"%@: Assertion failed: %@", pos, message] atLevel: NFCRITICAL];
		else
			[self logLine: [NSString stringWithFormat: @"%@: Assertion failed!", pos] atLevel: NFCRITICAL];

		NSNumber* num = [[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"autoReportBug"];
		if (num && [num intValue])
			[self reportError];
		exit(-1);
	}
}

- (void) reportError {
	NFLog(@"Attempting automatic bug reporting");
	NSURL *cgiUrl = [NSURL URLWithString:@"http://nym.se/xdownloader/reportbug.php"];
	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:cgiUrl];
	
	//setting the headers:
	[postRequest setHTTPMethod:@"POST"];
	[postRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
 	NSString* str = [NSString stringWithCString:[buffer bytes] length:[buffer length]];
	NSString* escaped = (NSString*) CFURLCreateStringByAddingPercentEscapes(0, (CFStringRef) str,  0, 0, kCFStringEncodingUTF8);
	NSString* body = [NSString stringWithFormat: @"buffer=%@", escaped];
	NSMutableData *postBody = [NSData dataWithBytes:[body cString] length: [body cStringLength]];
	[postRequest setHTTPBody: postBody];

	NSURLResponse* foo = [NSURLResponse alloc];
	NSError* bar = [NSError alloc];
	[NSURLConnection sendSynchronousRequest:postRequest returningResponse:&foo error:&bar];
	sleep(1);
}

@end

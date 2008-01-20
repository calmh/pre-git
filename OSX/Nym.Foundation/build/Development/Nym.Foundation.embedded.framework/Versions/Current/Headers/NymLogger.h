//
//  DebugLogger.h
//  Nym.Logging
//
//  Created by Jakob Borg on 2005-06-19.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


#define NFCRITICAL 0
#define NFINFO	1
#define NFDEBUG	2
#define NFASSERT 3
#define NFDEFAULTLEVEL NFDEBUG

#define NFLocation [NSString stringWithFormat: @"%@:%d", [[[NSString stringWithCString: __FILE__] pathComponents] lastObject], __LINE__]
#define NFLocationArgs(args...) [NSString stringWithFormat: @"%@:%d %@", [[[NSString stringWithCString: __FILE__] pathComponents] lastObject], __LINE__, [NSString stringWithFormat: args]]
#define NFLog(args...) [[NymLogger sharedLogger] logLine:  NFLocationArgs(args) atLevel: NFINFO];
#define NFAssertMsg(condition, args...) [[NymLogger sharedLogger] assert: (condition) atPosition: NFLocation withAssertStr: @#condition andMessage: [NSString stringWithFormat: args]];
#define NFAssert(condition) [[NymLogger sharedLogger] assert: (condition) atPosition: NFLocation withAssertStr: @#condition andMessage: nil];

@interface NymLogger : NSObject {
@private
	int debugLevel;	
	FILE* descriptor;
	NSMutableData* buffer;
}

+ (NymLogger*) sharedLogger;
- (id) init;
- (void) openLogFile: (NSString*) fileName;
- (void) setDebugLevel: (int) level;
- (int) debugLevel;
- (void) logLine: (NSString*) line atLevel: (int) level;
- (void) assert: (bool) condition atPosition: (NSString*) post withAssertStr: (NSString*) assertStr andMessage: (NSString*) message;
- (void) reportError;
@end

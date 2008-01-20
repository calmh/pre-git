//
//  XDVariables.h
//  XDownloader
//
//  Created by Jakob Borg on 2005-06-25.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface XDVariables : NSObject {
@private
	NSMutableDictionary* variables;
}

- (XDVariables*) init;
- (void) dealloc;
- (NSDictionary*) variablesDictionary;

@end

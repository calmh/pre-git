//
//  LuaHandling.h
//  Almond
//
//  Created by Jakob Borg on 9/4/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"

@interface LuaHandling : NSObject {

}

- (void) loadPlugin:(NSString*)path;

@end

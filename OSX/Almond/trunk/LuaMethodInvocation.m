//
//  ADMethodInvocation.m
//  Almond
//
//  Created by Jakob Borg on 6/23/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "LuaMethodInvocation.h"
#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"

@implementation LuaMethodInvocation

- (BOOL) executeForFilename:(NSString*)filename {
        int result = 0;
        lua_State *L = lua_open();
        luaL_openlibs(L);
        int stat = luaL_dofile(L, [[[self method] path] cStringUsingEncoding:NSASCIIStringEncoding]);
        if (stat != 0) {
                const char *err = lua_tostring(L, -1);                
                lua_pop(L, 1);
                [NSAlert alertWithMessageText:[NSString stringWithCString:err encoding:NSUTF8StringEncoding] defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:nil];
                
        } else {
                lua_getfield(L, LUA_GLOBALSINDEX, [[[self method] name] cStringUsingEncoding:NSUTF8StringEncoding]);
                lua_pushstring(L, [filename cStringUsingEncoding:NSUTF8StringEncoding]);
                int nparams = 1;
                // TODO: Verify we have all parameters we need
                for (NSManagedObject *paramVal in [[self parameterValues] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey: @"order" ascending:YES] autorelease]]]) {
                        lua_pushstring(L, [[paramVal value] cStringUsingEncoding:NSUTF8StringEncoding]);
                        nparams++;
                }
                lua_pcall(L, nparams, 1, 0);
                result = lua_tointeger(L, -1);
        }
        lua_close(L);
        return result != 0;
}

@end

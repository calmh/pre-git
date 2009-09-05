//
//  LuaHandling.m
//  Almond
//
//  Created by Jakob Borg on 9/4/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "LuaHandling.h"

@interface LuaHandling ()

- (NSString*)getString:(int)number inTable:(lua_State *)l;
- (NSDictionary*)getTableOnTopOfStack:(lua_State*)L;

@end

@implementation LuaHandling

@synthesize managedObjectContext;

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)newManagedObjectContext {
        if (self = [super init]) {
                self.managedObjectContext = newManagedObjectContext;
        }
        return self;
}

- (void)dealloc {
        self.managedObjectContext = nil;
        [super dealloc];
}

- (void) loadPlugin:(NSString*)path {
        NSDictionary *pluginData;
        
        lua_State *l = lua_open();
        luaL_openlibs(l);
        int stat = luaL_dofile(l, [path cStringUsingEncoding:NSASCIIStringEncoding]);
        if (stat != 0) {
                const char *err = lua_tostring(l, -1);                
                lua_pop(l, 1);
                [NSAlert alertWithMessageText:[NSString stringWithCString:err encoding:NSUTF8StringEncoding] defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:nil];
                
        } else {
                lua_getglobal(l, "plugin");
                pluginData = [self getTableOnTopOfStack:l];
        }
        lua_close(l);
        
        /*
         // Find and delete any old data for this plugin
         NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
         [request setEntity:[NSEntityDescription entityForName:@"Plugin" inManagedObjectContext:[self managedObjectContext]]];
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"path LIKE %@", path];
         [request setPredicate:predicate];
         NSError *error = nil;
         NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];
         for (NSManagedObject *obj in array)
         [[self managedObjectContext] deleteObject:obj];
         */
        
        // Create a new plugin instance
        NSManagedObject* plugin = [NSEntityDescription insertNewObjectForEntityForName:@"Library" inManagedObjectContext:[self managedObjectContext]];
        [plugin setPath:path];
        [plugin setDateScanned:[NSDate date]];
        
        // Create all methods in the plugin
        for (NSString* methodName in [[pluginData valueForKey:@"methods"] allKeys]) {
                NSDictionary* methodData = [[pluginData valueForKey:@"methods"] valueForKey:methodName];
                NSManagedObject* method = [NSEntityDescription insertNewObjectForEntityForName:@"Method" inManagedObjectContext:[self managedObjectContext]];
                [plugin addMethodsObject:method];
                [method setId:methodName];
                [method setDescr:[methodData valueForKey:@"description"]];
                [method setTask:[methodData valueForKey:@"type"]];
                
                // Create all parameters for each method
                for (NSString* parameterOrder in [[methodData valueForKey:@"arguments"] allKeys]) {
                        NSDictionary* parameterData = [[methodData valueForKey:@"arguments"] valueForKey:parameterOrder];
                        NSManagedObject* parameter = [NSEntityDescription insertNewObjectForEntityForName:@"Parameter" inManagedObjectContext:[self managedObjectContext]];
                        [method addParametersObject:parameter];
                        [parameter setOrder:[NSNumber numberWithInt:[parameterOrder intValue]]];
                        [parameter setDescr:[parameterData valueForKey:@"description"]];
                        [parameter setUnit:[parameterData valueForKey:@"type"]];
                        //[parameter setDefault:[parameterData valueForKey:@"default"]];
                        //[parameter setMin:[parameterData valueForKey:@"min"]];
                        //[parameter setMax:[parameterData valueForKey:@"max"]];
                }
        }
}

- (NSString*)getString:(int)number inTable:(lua_State *)l {
        int istab = lua_istable(l, -1);
        if (!istab)
                return nil;
        
        lua_pushinteger(l, number);
        lua_gettable(l, -2);
        if (lua_isstring(l, -1)) {
                const char* str = lua_tostring(l, -1);
                NSString* nsstr = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
                lua_pop(l, 1);
                return nsstr;
        } else {
                lua_pop(l, 1);
                return nil;                
        }
}

- (NSDictionary*)getTableOnTopOfStack:(lua_State*)L {
        NSMutableDictionary *res = [[[NSMutableDictionary alloc] init] autorelease];
        
        /* table is in the stack at index 't' */
        lua_pushnil(L);  /* first key */
        while (lua_next(L, -2) != 0) {
                id key = nil, value = nil;
                
                if (lua_isnumber(L, -2)) {
                        key = [NSString stringWithFormat:@"%f", lua_tonumber(L, -2)];
                } else if (lua_isstring(L, -2)) {
                        key = [NSString stringWithCString:lua_tostring(L, -2) encoding:NSUTF8StringEncoding];
                }
                
                if (lua_isnumber(L, -1)) {
                        //value = [NSNumber numberWithDouble:lua_tonumber(L, -1)];
                        key = [NSString stringWithFormat:@"%f", lua_tonumber(L, -1)];
                } else if (lua_isstring(L, -1)) {
                        value = [NSString stringWithCString:lua_tostring(L, -1) encoding:NSUTF8StringEncoding];
                } else if (lua_istable(L, -1)) {
                        value = [self getTableOnTopOfStack:L];
                }
                
                if (value != nil && key != nil)
                        [res setObject:value forKey:key];
                
                lua_pop(L, 1);
        }
        
        return res;
}

@end

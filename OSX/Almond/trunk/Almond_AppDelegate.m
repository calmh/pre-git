//
//  Almond_AppDelegate.m
//  Almond
//
//  Created by Jakob Borg on 6/21/09.
//  Copyright Jakob Borg 2009 . All rights reserved.
//

#import "Almond_AppDelegate.h"
#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"
#import "ADMethodInvocation.h"
#import "IconImageTransformer.h"

@implementation Almond_AppDelegate

@synthesize window, folderCollection;

+ (void)initialize {
        // Register our transformers
        [NSValueTransformer setValueTransformer:[[[IconImageTransformer alloc] init] autorelease] forName:@"IconImageTransformer"];
        [NSValueTransformer setValueTransformer:[[[NumChildrenTransformer alloc] init] autorelease] forName:@"NumChildrenTransformer"];
        [NSValueTransformer setValueTransformer:[[[DirectorySizeTransformer alloc] init] autorelease] forName:@"DirectorySizeTransformer"];
}

- (void)applicationDidFinishLaunching:(NSNotification*)notification {
}

/**
 Returns the support directory for the application, used to store the Core Data
 store file.  This code uses a directory named "Almond" for
 the content, either in the NSApplicationSupportDirectory location or (if the
 former cannot be found), the system's temporary directory.
 */

- (NSString *)applicationSupportDirectory {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
        return [basePath stringByAppendingPathComponent:@"Almond"];
}


/**
 Creates, retains, and returns the managed object model for the application 
 by merging all of the models found in the application bundle.
 */

- (NSManagedObjectModel *)managedObjectModel {
        
        if (managedObjectModel) return managedObjectModel;
	
        managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
        return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.  This 
 implementation will create and return a coordinator, having added the 
 store for the application to it.  (The directory for the store is created, 
 if necessary.)
 */

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
        
        if (persistentStoreCoordinator) return persistentStoreCoordinator;
        
        NSManagedObjectModel *mom = [self managedObjectModel];
        if (!mom) {
                NSAssert(NO, @"Managed object model is nil");
                NSLog(@"%@:%s No model to generate a store from", [self class], _cmd);
                return nil;
        }
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *applicationSupportDirectory = [self applicationSupportDirectory];
        NSError *error = nil;
        
        if ( ![fileManager fileExistsAtPath:applicationSupportDirectory isDirectory:NULL] ) {
		if (![fileManager createDirectoryAtPath:applicationSupportDirectory withIntermediateDirectories:NO attributes:nil error:&error]) {
                        NSAssert(NO, ([NSString stringWithFormat:@"Failed to create App Support directory %@ : %@", applicationSupportDirectory,error]));
                        NSLog(@"Error creating application support directory at %@ : %@",applicationSupportDirectory,error);
                        return nil;
		}
        }
        
        NSURL *url = [NSURL fileURLWithPath: [applicationSupportDirectory stringByAppendingPathComponent: @"storedata"]];
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: mom];
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType 
                                                      configuration:nil 
                                                                URL:url 
                                                            options:nil 
                                                              error:&error]){
                [[NSApplication sharedApplication] presentError:error];
                [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
                return nil;
        }    
        
        return persistentStoreCoordinator;
}

/**
 Returns the managed object context for the application (which is already
 bound to the persistent store coordinator for the application.) 
 */

- (NSManagedObjectContext *) managedObjectContext {
        
        if (managedObjectContext) return managedObjectContext;
        
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (!coordinator) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
                [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
                NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
                [[NSApplication sharedApplication] presentError:error];
                return nil;
        }
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
        
        return managedObjectContext;
}

/**
 Returns the NSUndoManager for the application.  In this case, the manager
 returned is that of the managed object context for the application.
 */

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
        return [[self managedObjectContext] undoManager];
}


/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.  Any encountered errors
 are presented to the user.
 */

- (IBAction) saveAction:(id)sender {
        
        NSError *error = nil;
        
        if (![[self managedObjectContext] commitEditing]) {
                NSLog(@"%@:%s unable to commit editing before saving", [self class], _cmd);
        }
        
        if (![[self managedObjectContext] save:&error]) {
                [[NSApplication sharedApplication] presentError:error];
        }
}


/**
 Implementation of the applicationShouldTerminate: method, used here to
 handle the saving of changes in the application managed object context
 before the application terminates.
 */

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
        
        if (!managedObjectContext) return NSTerminateNow;
        
        if (![managedObjectContext commitEditing]) {
                NSLog(@"%@:%s unable to commit editing to terminate", [self class], _cmd);
                return NSTerminateCancel;
        }
        
        if (![managedObjectContext hasChanges]) return NSTerminateNow;
        
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
                
                // This error handling simply presents error information in a panel with an 
                // "Ok" button, which does not include any attempt at error recovery (meaning, 
                // attempting to fix the error.)  As a result, this implementation will 
                // present the information to the user and then follow up with a panel asking 
                // if the user wishes to "Quit Anyway", without saving the changes.
                
                // Typically, this process should be altered to include application-specific 
                // recovery steps.  
                
                BOOL result = [sender presentError:error];
                if (result) return NSTerminateCancel;
                
                NSString *question = NSLocalizedString(@"Could not save changes while quitting.  Quit anyway?", @"Quit without saves error question message");
                NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
                NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
                NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
                NSAlert *alert = [[NSAlert alloc] init];
                [alert setMessageText:question];
                [alert setInformativeText:info];
                [alert addButtonWithTitle:quitButton];
                [alert addButtonWithTitle:cancelButton];
                
                NSInteger answer = [alert runModal];
                [alert release];
                alert = nil;
                
                if (answer == NSAlertAlternateReturn) return NSTerminateCancel;
                
        }
        
        return NSTerminateNow;
}


/**
 Implementation of dealloc, to release the retained variables.
 */

- (void)dealloc {
        
        [window release];
        [managedObjectContext release];
        [persistentStoreCoordinator release];
        [managedObjectModel release];
	
        [super dealloc];
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
                [nsstr autorelease];
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
        
        // Find and delete any old data for this plugin
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        [request setEntity:[NSEntityDescription entityForName:@"Plugin" inManagedObjectContext:[self managedObjectContext]]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"path LIKE %@", path];
        [request setPredicate:predicate];
        NSError *error = nil;
        NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];
        for (NSManagedObject *obj in array)
                [[self managedObjectContext] deleteObject:obj];
        
        // Create a new plugin instance
        NSManagedObject* plugin = [NSEntityDescription insertNewObjectForEntityForName:@"Plugin" inManagedObjectContext:[self managedObjectContext]];
        [plugin setPath:path];
        [plugin setDescr:[pluginData valueForKey:@"description"]];
        [plugin setCopyright:[pluginData valueForKey:@"copyright"]];
        [plugin setLastUpdated:[NSDate date]];
        
        // Create all methods in the plugin
        for (NSString* methodName in [[pluginData valueForKey:@"methods"] allKeys]) {
                NSDictionary* methodData = [[pluginData valueForKey:@"methods"] valueForKey:methodName];
                NSManagedObject* method = [NSEntityDescription insertNewObjectForEntityForName:@"Method" inManagedObjectContext:[self managedObjectContext]];
                [plugin addMethodsObject:method];
                [method setName:methodName];
                [method setDescr:[methodData valueForKey:@"description"]];
                [method setTypename:[methodData valueForKey:@"type"]];
                
                // Create all parameters for each method
                for (NSString* parameterOrder in [[methodData valueForKey:@"arguments"] allKeys]) {
                        NSDictionary* parameterData = [[methodData valueForKey:@"arguments"] valueForKey:parameterOrder];
                        NSManagedObject* parameter = [NSEntityDescription insertNewObjectForEntityForName:@"Parameter" inManagedObjectContext:[self managedObjectContext]];
                        [method addParametersObject:parameter];
                        [parameter setOrder:[NSNumber numberWithInt:[parameterOrder intValue]]];
                        [parameter setDescr:[parameterData valueForKey:@"description"]];
                        [parameter setTypename:[parameterData valueForKey:@"type"]];
                        [parameter setDefault:[parameterData valueForKey:@"default"]];
                        [parameter setMin:[parameterData valueForKey:@"min"]];
                        [parameter setMax:[parameterData valueForKey:@"max"]];
                }
        }
}

- (IBAction)buttonClicked:(id)sender {
        [self loadPlugin:[[NSBundle mainBundle] pathForResource:@"Default" ofType:@"almond"]];
        
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        [request setEntity:[NSEntityDescription entityForName:@"Method" inManagedObjectContext:[self managedObjectContext]]];
        //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"path LIKE %@", path];
        //[request setPredicate:predicate];
        NSError *error = nil;
        NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];
        for (NSManagedObject *method in array) {
                ADMethodInvocation* mi = [NSEntityDescription insertNewObjectForEntityForName:@"MethodInvocation" inManagedObjectContext:[self managedObjectContext]];
                [mi setMethod:method];
                for (NSManagedObject *parm in [method parameters])
                {
                        NSManagedObject* pv = [NSEntityDescription insertNewObjectForEntityForName:@"ParameterValue" inManagedObjectContext:[self managedObjectContext]];
                        [pv setOrder:[parm order]];
                        [pv setValue:[parm default]];
                        [pv setTypename:[parm typename]];
                        [mi addParameterValuesObject:pv];
                }
        }
}

- (IBAction)browseForPath:(id)sender {
        NSOpenPanel *dialog = [[NSOpenPanel alloc] init];
        [dialog setCanChooseFiles:NO];
        [dialog setCanChooseDirectories:YES];
        [dialog setResolvesAliases:YES];
        [dialog setCanCreateDirectories:YES];
        [dialog setAllowsMultipleSelection:NO];
        [dialog runModal];
        
        NSManagedObject *folder = [NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext:[self managedObjectContext]];
        [folder setPath:[[dialog filenames] objectAtIndex:0]];
}

@end

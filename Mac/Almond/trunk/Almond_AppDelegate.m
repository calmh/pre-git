//
//  Almond_AppDelegate.m
//  Almond
//
//  Created by Jakob Borg on 9/1/09.
//  Copyright Jakob Borg 2009 . All rights reserved.
//

#import "Almond_AppDelegate.h"
#import "LuaHandling.h"

@interface Almond_AppDelegate ()

@end


@implementation Almond_AppDelegate

@synthesize window;
@synthesize mainView;
@synthesize folderViewController;
@synthesize ruleViewController;
@synthesize methodViewController;
@synthesize rightDrawer;
@synthesize leftDrawer;

+ (void)initialize {
        // Register our transformers
        [NSValueTransformer setValueTransformer:[[[IconImageTransformer alloc] init] autorelease] forName:@"IconImageTransformer"];
        [NSValueTransformer setValueTransformer:[[[NumChildrenTransformer alloc] init] autorelease] forName:@"NumChildrenTransformer"];
        [NSValueTransformer setValueTransformer:[[[DirectorySizeTransformer alloc] init] autorelease] forName:@"DirectorySizeTransformer"];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
/*        [[self.folderViewController view] setFrame:NSMakeRect(0.0f, 22.0f, 300.0f, 450.0f)];
        [[self.ruleViewController view] setFrame:NSMakeRect(300.0f, 22.0f, 300.0f, 450.0f)];
        [[self.methodViewController view] setFrame:NSMakeRect(600.0f, 22.0f, 300.0f, 450.0f)];*/
        [self.mainView addSubview:[self.folderViewController view]];
        [self.mainView addSubview:[self.ruleViewController view]];
        [self.mainView addSubview:[self.methodViewController view]];
        /*float width = [[self.window contentView] frame].size.width;
        [self.folderViewController slideViewToX:0.0f];
        [self.ruleViewController slideViewToX:width];
         [self.methodViewController slideViewToX:width*2.0f];*/
        /*[self.rightDrawer open];
        [self.rightDrawer setContentView:self.folderViewController.rightDrawerView];*/
        [self changeToFolderView:nil];
#ifdef REINITIALIZE_LIBRARY
        LuaHandling *lua = [[[LuaHandling alloc] initWithManagedObjectContext:self.managedObjectContext] autorelease];
        [lua loadPlugin:[[NSBundle mainBundle] pathForResource:@"StandardLibrary" ofType:@"lua"]];
#endif
}

- (IBAction)changeToRuleView:(id)sender {
        [self.ruleViewController setRepresentedObject:[[self.folderViewController.folderArrayController selectedObjects] objectAtIndex:0]];
        [self.folderViewController fadeOut];
        [self.ruleViewController fadeIn];
        [self.methodViewController fadeOut];
        //[self.folderViewController slideViewToX:-300.0f];
        //[self.ruleViewController slideViewToX:0.0f];
        //[self.methodViewController slideViewToX:300.0f];
        if (self.ruleViewController.rightDrawerView != nil) {
                [self.rightDrawer setContentView:self.ruleViewController.rightDrawerView];
                [self.rightDrawer open];
        } else {
                [self.rightDrawer close];
        }
        if (self.ruleViewController.leftDrawerView != nil) {
                [self.leftDrawer setContentView:self.ruleViewController.leftDrawerView];
                [self.leftDrawer open];
        } else {
                [self.leftDrawer close];
        }
}

- (IBAction)changeToFolderView:(id)sender {
        [self.folderViewController fadeIn];
        [self.ruleViewController fadeOut];
        [self.methodViewController fadeOut];
        //[self.folderViewController slideViewToX:0.0f];
        //[self.ruleViewController slideViewToX:300.0f];
        //[self.methodViewController slideViewToX:600.0f];
        if (self.folderViewController.rightDrawerView != nil) {
                [self.rightDrawer setContentView:self.folderViewController.rightDrawerView];
                [self.rightDrawer open];
        } else {
                [self.rightDrawer close];
        }
        if (self.folderViewController.leftDrawerView != nil) {
                [self.leftDrawer setContentView:self.folderViewController.leftDrawerView];
                [self.leftDrawer open];
        } else {
                [self.leftDrawer close];
        }
}

- (IBAction)changeToMethodView:(id)sender {
        [self.methodViewController setRepresentedObject:[[self.ruleViewController.ruleArrayController selectedObjects] objectAtIndex:0]];
        [self.folderViewController fadeOut];
        [self.ruleViewController fadeOut];
        [self.methodViewController fadeIn];
        //[self.folderViewController slideViewToX:-600.0f];
        //[self.ruleViewController slideViewToX:-300.0f];
        //[self.methodViewController slideViewToX:0.0f];
        if (self.methodViewController.rightDrawerView != nil) {
                [self.rightDrawer setContentView:self.methodViewController.rightDrawerView];
                [self.rightDrawer open];
        } else {
                [self.rightDrawer close];
        }
        if (self.methodViewController.leftDrawerView != nil) {
                [self.leftDrawer setContentView:self.methodViewController.leftDrawerView];
                [self.leftDrawer open];
        } else {
                [self.leftDrawer close];
        }
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


- (BOOL)drawerShouldClose:(NSDrawer *)sender {
        return NO;
}

@end

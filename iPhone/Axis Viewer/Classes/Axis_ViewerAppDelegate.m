//
//  Axis_ViewerAppDelegate.m
//  Axis Viewer
//
//  Created by Jakob Borg on 3/9/09.
//  Copyright Jakob Borg 2009. All rights reserved.
//

#import "Axis_ViewerAppDelegate.h"
#import "AVRootViewController.h"

@implementation Axis_ViewerAppDelegate

@synthesize window, navigationController, cameras;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// Load the camera list
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString* filename = [NSString stringWithFormat:@"%@/cameras.plist", documentsDirectory];
        NSLog(@"[Axis_ViewerAppDelegate.applicationDidFinishLaunching] Loading cameras");
        self.cameras = [[[NSMutableArray alloc] initWithContentsOfFile:filename] autorelease];	
        
        // A default list of cameras in case this is the first run
	if (self.cameras == nil) {
                NSLog(@"[Axis_ViewerAppDelegate.applicationDidFinishLaunchin] No cameras, using default set");
                self.cameras = [self arrayOfDefaultCameras];
	}
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window setAutoresizingMask: (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)]; 
	[window setAutoresizesSubviews:YES];
	[window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application {
        // Save the camera list before quitting.
        NSLog(@"[Axis_ViewerAppDelegate.applicationWillTerminate] Saving cameras");
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString* filename = [NSString stringWithFormat:@"%@/cameras.plist", documentsDirectory];
	[self.cameras writeToFile:filename atomically:NO];
}

- (NSMutableArray*) arrayOfDefaultCameras {
        NSMutableArray *defaultCameras = [[[NSMutableArray alloc] init] autorelease];
        NSMutableDictionary *cam;
        cam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
               @"81.88.9.88", @"address",
               @"Jakobs kontor på Ideon", @"description",
               @"root", @"username",
               @"jakob", @"password",
               nil];
        [defaultCameras addObject:cam];
        cam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
               @"mcdcam-dimm.as.utexas.edu", @"address",
               @"McDonald Observatory Domes", @"description",
               nil];
        [defaultCameras addObject:cam];
        cam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
               @"campuscentercam.its.wesleyan.edu", @"address",
               @"Wesleyan Campus Center", @"description",
               nil];
        [defaultCameras addObject:cam];
        cam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
               @"ravensview.unbc.ca", @"address",
               @"UNBC Agora Courtyard", @"description",
               nil];                
        [defaultCameras addObject:cam];
        cam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
               @"216.62.222.101", @"address",
               @"Rutherford Small Dog Daycare", @"description",
               nil];
        [defaultCameras addObject:cam];
        cam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
               @"eastentrance.tps.ucsb.edu", @"address",
               @"East Entrance View of 217", @"description",
               nil];
        [defaultCameras addObject:cam];
        cam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
               @"62.153.175.52", @"address",
               @"Fleesensee Golf & Country Club", @"description",
               nil];
        [defaultCameras addObject:cam];
        return defaultCameras;
}

- (void)dealloc {
	[navigationController release];
	[window release];
	[cameras release];
	[super dealloc];
}

@end

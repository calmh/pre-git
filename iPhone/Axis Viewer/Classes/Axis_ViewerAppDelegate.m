//
//  Axis_ViewerAppDelegate.m
//  Axis Viewer
//
//  Created by Jakob Borg on 3/9/09.
//  Copyright Jakob Borg 2009. All rights reserved.
//

#import "Axis_ViewerAppDelegate.h"
#import "RootViewController.h"

@implementation Axis_ViewerAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize cameras;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// Load the camera list
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString* filename = [NSString stringWithFormat:@"%@/cameras.plist", documentsDirectory];
	cameras = [[NSMutableArray alloc] initWithContentsOfFile:filename];	
	if (cameras == nil) {
		cameras = [[NSMutableArray alloc] init];
		NSMutableDictionary *cam;
		cam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"216.62.222.101", @"address",
                       @"Rutherford Small Dog Daycare", @"description",
                       nil];
		[cameras addObject:cam];
		cam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"mcdcam-dimm.as.utexas.edu", @"address",
                       @"McDonald Observatory Domes", @"description",
                       nil];
		[cameras addObject:cam];
		cam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       @"eastentrance.tps.ucsb.edu", @"address",
                       @"East Entrance View of 217", @"description",
                       nil];
		[cameras addObject:cam];
	}
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window setAutoresizingMask: (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)]; 
	[window setAutoresizesSubviews:YES];
	[window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application {
        // Save the camera list before quitting.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString* filename = [NSString stringWithFormat:@"%@/cameras.plist", documentsDirectory];
	[cameras writeToFile:filename atomically:NO];
}

- (void)dealloc {
	[navigationController release];
	[window release];
	[cameras release];
	[super dealloc];
}

@end

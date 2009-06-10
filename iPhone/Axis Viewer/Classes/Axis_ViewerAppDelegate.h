//
//  Axis_ViewerAppDelegate.h
//  Axis Viewer
//
//  Created by Jakob Borg on 3/9/09.
//  Copyright Jakob Borg 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Axis_ViewerAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	UINavigationController *navigationController;
	NSMutableArray *cameras;
}

- (NSMutableArray*) arrayOfDefaultCameras;

@property (retain) IBOutlet UIWindow *window;
@property (retain) IBOutlet UINavigationController *navigationController;
@property (retain) NSMutableArray* cameras;

@end


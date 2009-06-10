//
//  RootViewController.h
//  Axis Viewer
//
//  Created by Jakob Borg on 3/9/09.
//  Copyright Jakob Borg 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Axis_ViewerAppDelegate.h"
#import "AVCameraDisplayViewController.h"
#import "AVCameraEditViewController.h"
#import "AVRootViewCell.h"

@interface AVRootViewController : UITableViewController <UIAccelerometerDelegate> {
	Axis_ViewerAppDelegate *appDelegate;
        NSMutableArray *camerasToUpdate;
        UIAcceleration *lastAcceleration;
        int shakeCount;
}

@property (retain) UIAcceleration *lastAcceleration;

- (void)addWasPressed: (id)sender;
- (BOOL)accelerationIsShakingLast:(UIAcceleration *)last current:(UIAcceleration *)current threshold:(double)threshold;

@end

//
//  RootViewController.h
//  Axis Viewer
//
//  Created by Jakob Borg on 3/9/09.
//  Copyright Jakob Borg 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Axis_ViewerAppDelegate.h"

@interface RootViewController : UITableViewController <UIAccelerometerDelegate> {
	Axis_ViewerAppDelegate *appDelegate;
        NSMutableArray *camerasToUpdate;
        UIAcceleration *lastAcceleration;
        int shakeCount;
}

@property (nonatomic, retain) UIAcceleration *lastAcceleration;

- (void)addPressed: (id)sender;
- (BOOL)AccelerationIsShakingLast:(UIAcceleration *)last current:(UIAcceleration *)current threshold:(double)threshold;

@end

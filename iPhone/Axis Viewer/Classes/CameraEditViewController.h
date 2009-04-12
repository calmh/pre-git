//
//  CameraEditViewController.h
//  Axis Viewer
//
//  Created by Jakob Borg on 4/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraEditViewController : UITableViewController {
	NSMutableDictionary* camera;
	NSMutableDictionary* descriptions;
	NSArray* keys;
}

@property(nonatomic, retain) NSMutableDictionary* camera;

- (void)cancelClicked:(id) sender;
- (void)saveClicked:(id) sender;

@end

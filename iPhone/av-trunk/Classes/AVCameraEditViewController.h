//
//  CameraEditViewController.h
//  Axis Viewer
//
//  Created by Jakob Borg on 4/11/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVAxisCamera.h"
#import "AVEditingCell.h"

@interface AVCameraEditViewController : UITableViewController <UITextFieldDelegate> {
	NSMutableDictionary* camera;
	NSDictionary* descriptions;
	NSArray* keys;
	BOOL keyboardIsShowing;
}

@property (retain) NSMutableDictionary* camera;
@property (retain) NSDictionary* descriptions;
@property (retain) NSArray* keys;
@property BOOL keyboardIsShowing;
@end

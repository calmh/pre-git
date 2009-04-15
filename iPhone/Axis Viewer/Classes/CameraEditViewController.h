//
//  CameraEditViewController.h
//  Axis Viewer
//
//  Created by Jakob Borg on 4/11/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraEditViewController : UITableViewController <UITextFieldDelegate> {
	NSMutableDictionary* camera;
	NSMutableDictionary* descriptions;
	NSArray* keys;
}

@property(nonatomic, retain) NSMutableDictionary* camera;

@end

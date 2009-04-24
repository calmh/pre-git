//
//  RootViewController.h
//  Axis Viewer
//
//  Created by Jakob Borg on 3/9/09.
//  Copyright Jakob Borg 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Axis_ViewerAppDelegate.h"

@interface RootViewController : UITableViewController {
	Axis_ViewerAppDelegate *appDelegate;
        NSMutableArray *camerasToUpdate;
}

-(void)addPressed: (id)sender;

@end

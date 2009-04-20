//
//  RootViewCell.h
//  Axis Viewer
//
//  Created by Jakob Borg on 4/19/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootViewCell : UITableViewCell {
	UIImageView *imageView;
	UILabel *labelView;	
}

@property(nonatomic, retain) IBOutlet UIImageView *imageView;
@property(nonatomic, retain) IBOutlet UILabel *labelView;

@end

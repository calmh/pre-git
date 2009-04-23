//
//  RootViewCell.m
//  Axis Viewer
//
//  Created by Jakob Borg on 4/19/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "RootViewCell.h"


@implementation RootViewCell

@synthesize labelView, imageView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end

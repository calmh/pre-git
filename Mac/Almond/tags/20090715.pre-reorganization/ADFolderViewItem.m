//
//  ADFolderViewItem.m
//  Almond
//
//  Created by Jakob Borg on 7/15/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "ADFolderViewItem.h"
#import "ADFolderView.h"

@implementation ADFolderViewItem
-(void)setSelected:(BOOL)flag {
        [super setSelected:flag];
        [(ADFolderView*) [self view] setSelected:flag];
        [[self view] setNeedsDisplay:YES];
}

@end

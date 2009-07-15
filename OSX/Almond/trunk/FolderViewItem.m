//
//  ADFolderViewItem.m
//  Almond
//
//  Created by Jakob Borg on 7/15/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "FolderViewItem.h"
#import "FolderView.h"

@implementation FolderViewItem
-(void)setSelected:(BOOL)flag {
        [super setSelected:flag];
        [(FolderView*) [self view] setSelected:flag];
        [[self view] setNeedsDisplay:YES];
}

@end

//
//  ADFolderViewItem.m
//  Almond
//
//  Created by Jakob Borg on 7/15/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "SelectableViewItem.h"
#import "SelectableDetailView.h"

@implementation SelectableViewItem

-(void)setSelected:(BOOL)flag {
        [super setSelected:flag];
        [(SelectableDetailView*) [self view] setSelected:flag];
        [[self view] setNeedsDisplay:YES];
}

-(IBAction)openClicked:(id)sender {
        [[NSWorkspace sharedWorkspace] openFile:[[self representedObject] path]];
}

@end

//
//  WidgetTableController.m
//  Almond
//
//  Created by Jakob Borg on 8/29/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "WidgetTableController.h"


@implementation WidgetTableController

- (void) setContent:(id)newContent {
        [super setContent:newContent];
        // Configure table view to suit us
        [self.content setDelegate:self];
        //[self.content setDataSource:self];
}

- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
        NSLog(@"foo");
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
        return 50.0f;
}
@end

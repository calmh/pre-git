//
//  JBTableView.m
//  Almond
//
//  Created by Jakob Borg on 8/8/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "JBTableView.h"

@implementation JBTableView

@synthesize datasource;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
        float y = 0.0f;
        int numRows = [datasource numberOfRowsInTableView:self];
        for (int i = 0; i < numRows; i++) {
                NSView *view = [datasource tableView:self viewForRow:i];
                NSRect childRect = rect;
                childRect.origin.y += y;
                [view drawRect:childRect];
                y += [datasource tableView:self heightForRow:i] + MARGIN;
        }
}

// Private

- (float)totalHeight {
        float totalHeight = 0;
        int numRows = [datasource numberOfRowsInTableView:self];
        if (numRows > 1)
                totalHeight += (numRows - 1) * MARGIN;
        for (int i = 0; i < numRows; i++)
                totalHeight += [datasource tableView:self heightForRow:i];
        return totalHeight;
}

@end

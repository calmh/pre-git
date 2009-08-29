//
//  JBTableView.m
//  Almond
//
//  Created by Jakob Borg on 8/19/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "TableView.h"

@implementation TableView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
            int i;
            for (i = 0; i < 20; i++) {
                    FormView *label = [[[FormView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0.0f, 0.0f, 200.0f, 80.0f))] autorelease];
                            //[label setTitleWithMnemonic:[NSString stringWithFormat:@"Label #%d",i]];
                    [self addSubview:label];
            }
    }
    return self;
}

- (BOOL)isFlipped {
        return YES;
}

- (void)viewWillDraw {
        float margin = 5.0f;
        float y = margin;
        NSRect myFrame = [self frame];
        for (NSView *view in [self subviews]) {
                NSRect rect = [view frame];
                rect.origin.y = y;
                rect.origin.x = margin;
                rect.size.width = myFrame.size.width - margin * 2.0f;
                [view setFrame:rect];
                y += rect.size.height + margin;
        }
        myFrame.size.height = y;
        [self setFrame:myFrame];
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
}

@end

//
//  FormView.m
//  Almond
//
//  Created by Jakob Borg on 8/28/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "FormView.h"

@implementation FormView

@synthesize form;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
            self.form = [[[NSForm alloc] initWithFrame:frame] autorelease];
            [self addSubview:self.form];
            [self.form addEntry:@"Entry one"];
            [self.form addEntry:@"Entry two"];
            [[self.form cellAtIndex:0] setTitle:@"Some text"];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
}

@end

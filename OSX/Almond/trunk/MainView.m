//
//  ADMainView.m
//  Almond
//
//  Created by Jakob Borg on 7/8/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "MainView.h"


@implementation MainView

- (void)drawRect:(NSRect)rect {
        // Draw background
        [[NSColor colorWithCalibratedWhite:0.9 alpha:1.0] drawSwatchInRect:[self bounds]];

        [[NSColor blackColor] setStroke];
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path setLineWidth:2.0];
        NSPoint a = self.bounds.origin;
        NSPoint b = a;
        b.x += self.bounds.size.width;
        [path moveToPoint:a];
        [path lineToPoint:b];
        a.y += self.bounds.size.height;
        b.y += self.bounds.size.height;
        [path moveToPoint:a];
        [path lineToPoint:b];
        [path stroke];
}

@end

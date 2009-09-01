//
//  ADMainView.m
//  Almond
//
//  Created by Jakob Borg on 7/8/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "MainView.h"

@implementation MainView

- (void)setFrameSize:(NSSize)newSize {
        [super setFrameSize:newSize];/*
        for (NSView *view in [self subviews]) {
                NSSize child = newSize;
                child.height -= 40;
                [view setFrameSize:child];
        }*/
        [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect {
        float bottomMargin = 0;
        NSPoint bl = self.bounds.origin;
        bl.y += bottomMargin + 0.5;
        NSPoint br = bl;
        br.x += self.bounds.size.width;
        NSPoint tl = bl;
        NSPoint tr = br;
        tl.y += self.bounds.size.height - bottomMargin - 1;
        tr.y += self.bounds.size.height - bottomMargin - 1;

        NSRect drect = NSMakeRect(bl.x, bl.y, self.bounds.size.width, self.bounds.size.height - bottomMargin);
        [[NSColor colorWithCalibratedWhite:0.9 alpha:1.0] drawSwatchInRect:drect];

        NSBezierPath *path;

        [[NSColor blackColor] setStroke];
        path = [NSBezierPath bezierPath];
        [path setLineWidth:1.0];
        [path moveToPoint:bl];
        [path lineToPoint:br];
        [path moveToPoint:tl];
        [path lineToPoint:tr];
        [path stroke];
        
        path = [NSBezierPath bezierPath];
        [[NSColor grayColor] setStroke];
        [path setLineWidth:1.0];
        bl.y -= 1;
        br.y -= 1;
        [path moveToPoint:bl];
        [path lineToPoint:br];
        [path stroke];

/*        path = [NSBezierPath bezierPath];
        [[NSColor darkGrayColor] setStroke];
        [path setLineWidth:1.0];
        tl.y += 1;
        tr.y += 1;
        [path moveToPoint:tl];
        [path lineToPoint:tr];
        [path stroke];
 */
}

@end

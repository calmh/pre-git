//
//  ADFolderView.m
//  Almond
//
//  Created by Jakob Borg on 7/8/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "ADFolderView.h"


@implementation ADFolderView

- (void)drawRect:(NSRect)rect {
        double margin = 2.0;
        NSPoint bl = self.bounds.origin; bl.x += margin; bl.y += margin;
        NSPoint br = bl; br.x += self.bounds.size.width - margin * 2;
        NSPoint tl = bl; tl.y += self.bounds.size.height - margin * 2;
        NSPoint tr = tl; tr.x += self.bounds.size.width - margin * 2;
        
        [[NSColor grayColor] setStroke];
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path setLineWidth:1.0];
        [path setLineJoinStyle:NSRoundLineJoinStyle];
        [path moveToPoint:bl];
        [path lineToPoint:br];
        [path lineToPoint:tr];
        [path lineToPoint:tl];
        [path lineToPoint:bl];
        [path stroke];
}

@end

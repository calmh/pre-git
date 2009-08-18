//
//  ADFolderView.m
//  Almond
//
//  Created by Jakob Borg on 7/8/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "ADFolderView.h"

@implementation ADFolderView

@synthesize iconView, selected;

- (void)dealloc {
        self.iconView = nil;
        [super dealloc];
}

- (void)drawRect:(NSRect)rect {
        [[NSColor colorWithDeviceWhite:0.95 alpha:1.0] setFill];
        NSGradient *background = [[NSGradient alloc] initWithColorsAndLocations:
                                  [NSColor colorWithDeviceWhite:1.0 alpha:1.0], 0.0,
                                  [NSColor colorWithDeviceWhite:0.97 alpha:1.0], 0.2,
                                  [NSColor colorWithDeviceWhite:0.95 alpha:1.0], 0.7,
                                  [NSColor colorWithDeviceWhite:0.92 alpha:1.0], 1.0,
                                  nil];

        
        NSBezierPath *border = [NSBezierPath new];
        double margin = 5.5;
        NSShadow *shadow = [NSShadow new];
        if (selected) {
                [[NSColor colorWithDeviceRed:0.0 green:0.5 blue:1.0 alpha:1.0] setStroke];
                [border setLineWidth:3.0];
                margin = 6.5;
                [shadow setShadowBlurRadius:4.0];
                [shadow setShadowOffset:NSMakeSize(3.0, -3.0)];
        } else {
                [[NSColor colorWithDeviceWhite:0.3 alpha:1.0] setStroke];
                [border setLineWidth:1.0];
                [shadow setShadowBlurRadius:3.0];
                [shadow setShadowOffset:NSMakeSize(2.0, -2.0)];
        }
        [shadow set];
        NSPoint bl = self.bounds.origin; bl.x += margin; bl.y += margin;
        NSPoint br = bl; br.x += self.bounds.size.width - margin * 2;
        NSPoint tl = bl; tl.y += self.bounds.size.height - margin * 2;
        NSPoint tr = tl; tr.x += self.bounds.size.width - margin * 2;
        
        [border setLineJoinStyle:NSRoundLineJoinStyle];
        [border moveToPoint:bl];
        [border lineToPoint:br];
        [border lineToPoint:tr];
        [border lineToPoint:tl];
        [border lineToPoint:bl];
        [border stroke];
        [background drawInBezierPath:border angle:-90];
        //[border fill];
        [border release];

        [shadow release];
}

@end

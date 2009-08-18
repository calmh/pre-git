//
//  ADFolderView.m
//  Almond
//
//  Created by Jakob Borg on 7/8/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "SelectableDetailView.h"

@implementation SelectableDetailView

@synthesize selected;

- (void)dealloc {
        [super dealloc];
}

- (void)drawRect:(NSRect)rect {
        [[NSColor colorWithDeviceWhite:0.95 alpha:1.0] setFill];
        NSGradient *background = nil;

        
        double margin = 0;
        NSBezierPath *border = [NSBezierPath new];
        NSShadow *shadow = [NSShadow new];
        
        if (selected) {
                margin = 6;
                [border setLineWidth:3.0];
                [shadow setShadowBlurRadius:4.0];
                [shadow setShadowOffset:NSMakeSize(3.0, -3.0)];

                [[NSColor colorWithDeviceRed:0.0 green:0.5 blue:1.0 alpha:1.0] setStroke];
                background  = [[NSGradient alloc] initWithColorsAndLocations:
                               [NSColor colorWithDeviceWhite:1.0 alpha:1.0], 0.0,
                               [NSColor colorWithDeviceWhite:0.97 alpha:1.0], 0.1,
                               [NSColor colorWithDeviceWhite:0.95 alpha:1.0], 0.8,
                               [NSColor colorWithDeviceWhite:0.92 alpha:1.0], 1.0,
                               nil];
        } else {
                margin = 5;
                [border setLineWidth:1.0];
                [shadow setShadowBlurRadius:3.0];
                [shadow setShadowOffset:NSMakeSize(2.0, -2.0)];

                [[NSColor colorWithDeviceWhite:0.3 alpha:1.0] setStroke];
                background  = [[NSGradient alloc] initWithColorsAndLocations:
                               [NSColor colorWithDeviceWhite:0.95 alpha:1.0], 0.0,
                               [NSColor colorWithDeviceWhite:0.92 alpha:1.0], 0.1,
                               [NSColor colorWithDeviceWhite:0.90 alpha:1.0], 0.8,
                               [NSColor colorWithDeviceWhite:0.87 alpha:1.0], 1.0,
                               nil];
        }
        
        NSRect bounds = [self centerScanRect:self.bounds];
        NSPoint bl = bounds.origin; bl.x += margin; bl.y += margin;
        NSPoint br = bl; br.x += bounds.size.width - margin * 2;
        NSPoint tl = bl; tl.y += bounds.size.height - margin * 2;
        NSPoint tr = tl; tr.x += bounds.size.width - margin * 2;
        
        [shadow set];
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

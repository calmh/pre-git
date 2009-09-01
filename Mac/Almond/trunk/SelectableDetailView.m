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
        if (selected) {
                [[NSColor selectedControlColor] setFill];
                NSRectFill(rect);
        }
        
        float margin = 8.0f;
        
        NSBezierPath *border = [NSBezierPath new];
        [border setLineWidth:1.0];
        [[NSColor colorWithDeviceWhite:0.3 alpha:1.0] setStroke];
        
        NSShadow *shadow = [NSShadow new];
        [shadow setShadowBlurRadius:3.0];
        [shadow setShadowOffset:NSMakeSize(2.0, -2.0)];
        
        NSGradient *background = nil;
        if (selected) {
                background  = [[NSGradient alloc] initWithColorsAndLocations:
                               [NSColor colorWithDeviceWhite:0.97 alpha:1.0], 0.0,
                               [NSColor colorWithDeviceWhite:0.94 alpha:1.0], 0.1,
                               [NSColor colorWithDeviceWhite:0.92 alpha:1.0], 0.8,
                               [NSColor colorWithDeviceWhite:0.89 alpha:1.0], 1.0,
                               nil];
        } else {
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
        
 
        [border setLineJoinStyle:NSRoundLineJoinStyle];
        [border moveToPoint:bl];
        [border lineToPoint:br];
        [border lineToPoint:tr];
        [border lineToPoint:tl];
        [border lineToPoint:bl];
 
        [shadow set];
        [border stroke];
        [background drawInBezierPath:border angle:-90];
        [shadow release];
        [border release];
}

@end

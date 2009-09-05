//
//  DraggableDetailView.m
//  Almond
//
//  Created by Jakob Borg on 9/4/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "DraggableDetailView.h"


@implementation DraggableDetailView

@synthesize representedObject;
@synthesize delegate;

- (void)dealloc {
        [super dealloc];
}

- (void)drawRect:(NSRect)rect {
        float margin = 8.0f;
        
        [NSGraphicsContext saveGraphicsState];

        NSString *type = [representedObject valueForKeyPath:@"task"];
        if ([type isEqualToString:@"action"])
                [[NSColor yellowColor] setFill];
        else if ([type isEqualToString:@"test"])
                [[NSColor blueColor] setFill];
        else
                [[NSColor whiteColor] setFill];
        
        NSGradient *background = nil;
        background  = [[NSGradient alloc] initWithColorsAndLocations:
                       [NSColor colorWithDeviceWhite:1.00 alpha:0.9], 0.0,
                       [NSColor colorWithDeviceWhite:0.95 alpha:0.9], 0.1,
                       [NSColor colorWithDeviceWhite:0.93 alpha:0.9], 0.8,
                       [NSColor colorWithDeviceWhite:0.89 alpha:0.9], 1.0,
                       nil];
        
        NSRect bounds = [self centerScanRect:self.bounds];
        NSPoint bl = bounds.origin; bl.x += margin; bl.y += margin;
        NSPoint br = bl; br.x += bounds.size.width - margin * 2;
        NSPoint tl = bl; tl.y += bounds.size.height - margin * 2;
        NSPoint tr = tl; tr.x += bounds.size.width - margin * 2;
        NSRect brect = NSMakeRect(bl.x, bl.y, tr.x - bl.x, tr.y - bl.y);
        
        CGFloat lineDash[2];
        lineDash[0] = 15.0;
        lineDash[1] = 9.0;
        
        [[NSColor colorWithDeviceWhite:0.7 alpha:1.0] setStroke];
        NSBezierPath *border = [NSBezierPath new];
        [border setLineWidth:6.0];
        [border setLineDash:lineDash count:2 phase:0.0];
        [border setLineJoinStyle:NSRoundLineJoinStyle];
        [border appendBezierPathWithRoundedRect:brect xRadius:5.0f yRadius:5.0f];

        [border stroke];
        [border fill];
        [background drawInBezierPath:border angle:-90];
        [border release];
        [background release];
        
        [NSGraphicsContext restoreGraphicsState];
}

-(void)mouseDown:(NSEvent *)theEvent {
        [super mouseDown:theEvent];
        if([theEvent clickCount] == 2) {
                if([delegate respondsToSelector:@selector(itemWasDoubleClicked:)]) {
                        [delegate itemWasDoubleClicked:self.representedObject];
                }
        }
}

@end

//
//  FormCell.m
//  Almond
//
//  Created by Jakob Borg on 8/29/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "FormCell.h"

@implementation FormCell

/*
 - copyWithZone:(NSZone *)zone {
	FormCell *cell = (FormCell *)[super copyWithZone:zone];
        return cell;
}
*/

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	//[self setTextColor:[NSColor blackColor]];
	
	NSObject* data = [self objectValue];
	
        //TODO: Selection with gradient and selection color in white with shadow
        // check out http://www.cocoadev.com/index.pl?NSTableView
	NSColor* primaryColor   = [self isHighlighted] ? [NSColor alternateSelectedControlTextColor] : [NSColor textColor];
	NSString* primaryText   = [data valueForKeyPath:@"primaryText"];
        
	NSDictionary* primaryTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: primaryColor, NSForegroundColorAttributeName,
                                               [NSFont systemFontOfSize:13], NSFontAttributeName, nil];	
	[primaryText drawAtPoint:NSMakePoint(cellFrame.origin.x+cellFrame.size.height+10, cellFrame.origin.y) withAttributes:primaryTextAttributes];
	
	NSColor* secondaryColor = [self isHighlighted] ? [NSColor alternateSelectedControlTextColor] : [NSColor disabledControlTextColor];
	NSString* secondaryText = [data valueForKeyPath:@"secondaryText"];
	NSDictionary* secondaryTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: secondaryColor, NSForegroundColorAttributeName,
                                                 [NSFont systemFontOfSize:10], NSFontAttributeName, nil];	
	[secondaryText drawAtPoint:NSMakePoint(cellFrame.origin.x+cellFrame.size.height+10, cellFrame.origin.y+cellFrame.size.height/2) 
                    withAttributes:secondaryTextAttributes];
	
	
        /*
         [[NSGraphicsContext currentContext] saveGraphicsState];
         float yOffset = cellFrame.origin.y;
         if ([controlView isFlipped]) {
         NSAffineTransform* xform = [NSAffineTransform transform];
         [xform translateXBy:0.0 yBy: cellFrame.size.height];
         [xform scaleXBy:1.0 yBy:-1.0];
         [xform concat];		
         yOffset = 0-cellFrame.origin.y;
         }	
         NSImage* icon = [[self dataDelegate] iconForCell:self data: data];	
         
         NSImageInterpolation interpolation = [[NSGraphicsContext currentContext] imageInterpolation];
         [[NSGraphicsContext currentContext] setImageInterpolation: NSImageInterpolationHigh];	
         
         [icon drawInRect:NSMakeRect(cellFrame.origin.x+5,yOffset+3,cellFrame.size.height-6, cellFrame.size.height-6)
         fromRect:NSMakeRect(0,0,[icon size].width, [icon size].height)
         operation:NSCompositeSourceOver
         fraction:1.0];
         
         [[NSGraphicsContext currentContext] setImageInterpolation: interpolation];
         
         [[NSGraphicsContext currentContext] restoreGraphicsState];	
         */
}

- (float) height {
        return 50.0f;
}

@end

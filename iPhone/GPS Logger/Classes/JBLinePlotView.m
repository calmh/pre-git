//
//  JBLinePlotView.m
//  GPS Logger
//
//  Created by Jakob Borg on 4/28/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "JBLinePlotView.h"


@implementation JBLinePlotView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
        if (self = [super initWithFrame:frame]) {
                // Initialization code
        }
        return self;
}

- (void)drawRect:(CGRect)rect
{
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetGrayFillColor(ctx, 0.85, 1.0);
        CGContextFillRect(ctx, rect);

        CGContextBeginPath(ctx);
        CGContextSetLineWidth(ctx, 2.0);
        CGContextSetRGBStrokeColor(ctx, 0.2, 0.2, 0.2, 1.0);
        CGContextAddRect(ctx, rect);
        CGContextStrokePath(ctx);

        CGContextBeginPath(ctx);
        CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0);
        CGContextSetLineWidth(ctx, 0.5);
        // Vertical axis
        CGContextMoveToPoint(ctx, (double) MARGIN, rect.size.height - (double) MARGIN);
        CGContextAddLineToPoint(ctx, (double) MARGIN, (double) MARGIN);
        // Horizontal axis
        CGContextMoveToPoint(ctx, (double) MARGIN, rect.size.height - (double) MARGIN);
        CGContextAddLineToPoint(ctx, rect.size.width - (double) MARGIN, rect.size.height - (double) MARGIN);
        CGContextStrokePath(ctx);

        if (!delegate)
                return;
        
        CGContextBeginPath(ctx);
        CGContextSetLineWidth(ctx, 1.0);
        CGContextSetShadow(ctx, CGSizeMake(1.5, -1.5), 2.0);
        CGContextSetRGBStrokeColor(ctx, 1.0, 0.0, 0.0, 1.0);
        for (int subplotNumber = 0; subplotNumber < [delegate plotViewNumberOfSubplots]; subplotNumber++) {
                int numPoints = [delegate plotViewNumberOfPointsInSubplot:subplotNumber];
                if (numPoints < 2)
                        continue;
                
                double xStep = (rect.size.width - 2*MARGIN) / (double) (numPoints - 1);
                double yMax = [delegate plotViewMaxYValueInSubplot:subplotNumber];
                double yMin = [delegate plotViewMinYValueInSubplot:subplotNumber];
                double yFactor = (rect.size.height - 2*MARGIN) / (yMax - yMin);
                for (int pointNumber = 0; pointNumber < numPoints; pointNumber++) {
                        double x = pointNumber * xStep + MARGIN;
                        double y = rect.size.height - (([delegate plotViewValueForPoint:pointNumber inSubplot:subplotNumber] - yMin) * yFactor + MARGIN);
                        if (pointNumber == 0)
                                CGContextMoveToPoint(ctx, x, y);
                        else
                                CGContextAddLineToPoint(ctx, x, y);
                }
        }
        CGContextStrokePath(ctx);
} 

- (void)dealloc {
        [super dealloc];
}


@end

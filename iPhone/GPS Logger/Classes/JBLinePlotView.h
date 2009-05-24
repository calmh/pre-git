//
//  JBLinePlotView.h
//  GPS Logger
//
//  Created by Jakob Borg on 4/28/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MARGIN 8 // pixels

@protocol JBLinePlotViewDelegate

- (int)plotViewNumberOfSubplots;
- (int)plotViewNumberOfPointsInSubplot:(int)subPlot;
- (double) plotViewMaxYValueInSubplot:(int)subPlot;
- (double) plotViewMinYValueInSubplot:(int)subPlot;
- (double) plotViewValueForPoint:(int)point inSubplot:(int)subPlot;

@end

@interface JBLinePlotView : UIView {
        id <JBLinePlotViewDelegate> delegate;
}

@property (retain) id <JBLinePlotViewDelegate> delegate;

@end


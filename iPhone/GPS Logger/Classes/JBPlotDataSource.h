//
//  JBPlotDataSource.h
//  GPS Logger
//
//  Created by Jakob Borg on 4/29/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JBLinePlotView.h"

@interface JBPlotDataSource : NSObject <JBLinePlotViewDelegate> {
        NSMutableArray *dataPoints;
}

- (void)addValue:(double)value;

@end

//
//  JBPlotDataSource.m
//  GPS Logger
//
//  Created by Jakob Borg on 4/29/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "JBPlotDataSource.h"

@implementation JBPlotDataSource

- (id) init
{
        self = [super init];
        if (self != nil) {
                dataPoints = [[NSMutableArray alloc] init];
        }
        return self;
}

- (void) dealloc
{
        [dataPoints release];
        [super dealloc];
}

- (void)addValue:(double)value {
        [dataPoints addObject:[NSNumber numberWithDouble:value]];
}

#pragma mark JBLinePlotViewDelegate methods

- (int)plotViewNumberOfSubplots {
        return 1;
}

- (int)plotViewNumberOfPointsInSubplot:(int)subplot {
        return [dataPoints count];
}

- (double)plotViewMaxYValueInSubplot:(int)subplot {
        if ([dataPoints count] == 0)
                return 1.0;
        
        double max = [[dataPoints objectAtIndex:0] doubleValue];
        for (NSNumber* value in dataPoints) {
                double dvalue = [value doubleValue];
                max = max > dvalue ? max : dvalue;
        }
                
        return max;
}

- (double)plotViewMinYValueInSubplot:(int)subplot {
        if ([dataPoints count] == 0)
                return 0.0;
        
        double min = [[dataPoints objectAtIndex:0] doubleValue];
        for (NSNumber* value in dataPoints) {
                double dvalue = [value doubleValue];
                min = min < dvalue ? min : dvalue;
        }
        
        return min;
}

- (double)plotViewValueForPoint:(int)point inSubplot:(int)subplot {
        if (subplot == 0) {
                NSNumber *data = [dataPoints objectAtIndex:point];
                double dv = [data doubleValue];
                return dv;
        } else
                return 0.0;
}

#pragma mark -

@end

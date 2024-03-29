//
//  JBLocationMath.m
//  Glint
//
//  Created by Jakob Borg on 7/26/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "JBLocationMath.h"

@interface JBLocationMath ()
- (void)updateCurrentSpeed:(float)newSpeed;
@end

@implementation JBLocationMath

@synthesize currentSpeed, currentCourse, totalDistance, lastKnownPosition;

- (id)init {
        if (self = [super init]) {
                currentSpeed = 0.0f;
                currentCourse = 0.0f;
                totalDistance = 0.0f;
                lastKnownPosition = nil;
                firstMeasurement = nil;
                locations = [[NSMutableArray alloc] init];
        }
        return self;
}

- (void)dealloc {
        [locations release];
        [super dealloc];
}

- (void)updateLocation:(CLLocation*)location {
        if (!location)
                return;
        
        if (!firstMeasurement)
                firstMeasurement = [location.timestamp retain];
        
        if (lastKnownPosition && [location.timestamp timeIntervalSinceDate:lastKnownPosition.timestamp] > 0.0f) {
                float dist = [lastKnownPosition getDistanceFrom:location];
                totalDistance += dist;
                [self updateCurrentSpeed:dist / [location.timestamp timeIntervalSinceDate:lastKnownPosition.timestamp]];
                currentCourse = [self bearingFromLocation:lastKnownPosition toLocation:location];
        }

        self.lastKnownPosition = location;
        [locations addObject:location];
}

- (float)speedFromLocation:(CLLocation*)locA toLocation:(CLLocation*)locB {
        float td = [locA.timestamp timeIntervalSinceDate:locB.timestamp];
        if (td < 0.0)
                td = -td;
        if (td == 0.0)
                return 0.0;
        float dist = [locA getDistanceFrom:locB];
        return dist / td;
}

- (float)bearingFromLocation:(CLLocation*)locA toLocation:(CLLocation*)locB {
        float y1 = locA.coordinate.latitude / 180.0 * M_PI;
        float x1 = locA.coordinate.longitude / 180.0 * M_PI;
        float y2 = locB.coordinate.latitude / 180.0 * M_PI;
        float x2 = locB.coordinate.longitude / 180.0 * M_PI;
        float y = cos(x1) * sin(x2) - sin(x1) * cos(x2) * cos(y2-y1);
        float x = sin(y2-y1) * cos(x2);
        float t = atan2(y, x);
        float bearing = t / M_PI * 180.0 + 360.0;
        if (bearing >= 360.0)
                bearing -= 360.0;
        return bearing;
}

- (float)distanceAtPointInTime:(float)targetTime {
        return [self distanceAtPointInTime:targetTime inLocations:locations];
}

- (float)distanceAtPointInTime:(float)targetTime inLocations:(NSArray*)locationList {
        if (isnan(targetTime) || targetTime < 0.0)
                return NAN;
        
        CLLocation *pointOne = nil, *pointTwo = nil;
        float distance = 0.0;
        float time = 0.0;
        
        for (CLLocation *point in locationList) {
                if (pointOne) {
                        time += [point.timestamp timeIntervalSinceDate:pointOne.timestamp];
                        distance += [pointOne getDistanceFrom:point];
                }
                if (time <= targetTime)
                        pointOne = point;
                else {
                        pointTwo = point;
                        break;
                }
        }
        
        float remainingTime = targetTime - time;
        float timeBetweenP1andP2 = [pointTwo.timestamp timeIntervalSinceDate:pointOne.timestamp];
        float factor = remainingTime / timeBetweenP1andP2;
        float targetDistance = distance + factor * [pointTwo getDistanceFrom:pointOne];
        return targetDistance;
}

- (float)timeAtLocationByDistance:(float)targetDistance {
        return [self timeAtLocationByDistance:targetDistance inLocations:locations];
}

- (float)timeAtLocationByDistance:(float)targetDistance inLocations:(NSArray*)locationList {
        if (isnan(targetDistance) || targetDistance < 0.0)
                return NAN;
        
        CLLocation *pointOne = nil, *pointTwo = nil;
        float time = 0.0;
        float distance = 0.0;
        
        for (CLLocation *point in locationList) {
                if (pointOne) {
                        time += [point.timestamp timeIntervalSinceDate:pointOne.timestamp];
                        distance += [pointOne getDistanceFrom:point];
                }
                if (distance <= targetDistance)
                        pointOne = point;
                else {
                        pointTwo = point;
                        break;
                }
        }
        
        float remainingDistance = targetDistance - distance;
        float factor = remainingDistance / [pointTwo getDistanceFrom:pointOne];
        float targetTime = time + factor * [pointTwo.timestamp timeIntervalSinceDate:pointOne.timestamp];
        return targetTime;
}

- (float)totalDistanceOverArray:(NSArray*)locationList {
        float distance = 0.0;
        CLLocation *last = nil;
        for (CLLocation *loc in locationList) {
                if (last)
                        distance += [loc getDistanceFrom:last];
                last = loc;
        }
        return distance;
}

- (NSArray*)startAndFinishTimesInArray:(NSArray*)locationList {
        NSDate *start = ((CLLocation*) [locationList objectAtIndex:0]).timestamp;
        NSDate *finish = ((CLLocation*) [locationList objectAtIndex:[locationList count]-1]).timestamp;
        return [NSArray arrayWithObjects:start, finish, nil];
}

// Estimated total distance, based on known totalDistance, currentSpeed, and interval since last measurement.
- (float)estimatedTotalDistanceAtTime:(NSDate*)when {
        float estimate = currentSpeed * [when timeIntervalSinceDate:lastKnownPosition.timestamp];
        return totalDistance + estimate;
}

- (float)estimatedTotalDistance {
        return [self estimatedTotalDistanceAtTime:[NSDate date]];
}

- (float)averageSpeed {
        if (!lastKnownPosition)
                return 0.0;
        return totalDistance / [lastKnownPosition.timestamp timeIntervalSinceDate:firstMeasurement];
}

/*
 * Private methods
 */

- (void)updateCurrentSpeed:(float)newSpeed {
        float weightFactor = 0.65f;
        currentSpeed = (weightFactor * newSpeed + currentSpeed) / (1 + weightFactor);
}

@end

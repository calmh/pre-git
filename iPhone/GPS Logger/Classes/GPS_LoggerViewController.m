//
//  GPS_LoggerViewController.m
//  GPS Logger
//
//  Created by Jakob Borg on 4/25/09.
//  Copyright Jakob Borg 2009. All rights reserved.
//

#import "GPS_LoggerViewController.h"

@implementation GPS_LoggerViewController

@synthesize locationManager, speedOverTime, altitudeOverTime, statusIndicator, positionLabel, elapsedTimeLabel, currentSpeedLabel, currentTimePerKmLabel, totalDistanceLabel, totalDistanceUnitLabel, statusLabel, averageSpeedLabel, slopeLabel, accuracyLabel, lastPosition, unitSetSelector;

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


- (void)beginGPX {
        NSString* start = @"<?xml version=\"1.0\" encoding=\"ASCII\" standalone=\"yes\"?>\n<gpx\n  version=\"1.1\"\n  creator=\"TrailRunner http://www.TrailRunnerx.com\"\n  xmlns=\"http://www.topografix.com/GPX/1/1\"\n  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n  xsi:schemaLocation=\"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd\">\n  <trk>\n    <trkseg>\n";
        [start writeToFile:filename atomically:NO encoding:NSASCIIStringEncoding error:nil];
}

- (void)endGPX {
        NSString* end = @"    </trkseg>\n  </trk>\n</gpx>\n";
        NSFileHandle *aFileHandle;
        aFileHandle = [NSFileHandle fileHandleForWritingAtPath:filename];
        [aFileHandle truncateFileAtOffset:[aFileHandle seekToEndOfFile]];
        [aFileHandle writeData:[end dataUsingEncoding:NSASCIIStringEncoding]];
        [aFileHandle closeFile];
}

- (void)pointInGPX:(CLLocation*)loc {
        NSString* ts = [loc.timestamp descriptionWithCalendarFormat:@"%Y-%m-%dT%H:%M:%SZ" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
        
        NSString* data = [NSString stringWithFormat:@"      <trkpt lat=\"%f\" lon=\"%f\">\n        <ele>%f</ele>\n        <time>%@</time>\n      </trkpt>\n",
                          loc.coordinate.latitude, loc.coordinate.longitude, loc.altitude, ts];
        
        NSFileHandle *aFileHandle;
        aFileHandle = [NSFileHandle fileHandleForWritingAtPath:filename];
        [aFileHandle truncateFileAtOffset:[aFileHandle seekToEndOfFile]];
        [aFileHandle writeData:[data dataUsingEncoding:NSASCIIStringEncoding]];
        [aFileHandle closeFile];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
        [super viewDidLoad];
        
        badSound = [[JBSoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Basso" ofType:@"aiff"]];
        goodSound = [[JBSoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Purr" ofType:@"aiff"]];
        stateGood = NO;
        directMeasurements = 0;
        averagedMeasurements = 0;
        
        NSDictionary *metric = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @"%.01f km/h", @"speedFormat",
                                @"%.02f km", @"distFormat",
                                [NSNumber numberWithFloat:1.0], @"distFactor",
                                [NSNumber numberWithFloat:1.0], @"speedFactor",
                                nil
                                ];
        NSDictionary *nautical = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  @"%.01f kn", @"speedFormat",
                                  @"%.02f M", @"distFormat",
                                  [NSNumber numberWithFloat:1.0/1.852], @"distFactor",
                                  [NSNumber numberWithFloat:1.0/1.852], @"speedFactor",
                                  nil
                                  ];
        unitSets = [NSArray arrayWithObjects:metric, nautical, nil];
        [unitSets retain];
        unitSetIndex = 0;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	filename = [NSString stringWithFormat:@"%@/track-%@.gpx", documentsDirectory, [[NSDate date] description]];
        [filename retain];
        
        locations = [[NSMutableArray alloc] init];
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.distanceFilter = FILTER_DISTANCE;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
        distance = 0;
        
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        [[UIApplication sharedApplication] setProximitySensingEnabled:YES];
        
        [self beginGPX];
        
        NSTimer* displayUpdater = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updateDisplay:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:displayUpdater forMode:NSDefaultRunLoopMode];
}

- (void) viewWillDisappear:(BOOL)animated
{
        [self endGPX];
        
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        [[UIApplication sharedApplication] setProximitySensingEnabled:NO];
        
        [self.locationManager stopUpdatingLocation];
        self.locationManager.delegate = nil;
        
        [super viewWillDisappear:animated];
}

- (double) distanceBetweenLocation:(CLLocation*)loc1 andLocation:(CLLocation*)loc2 {
        if (!loc1 || !loc2)
                return 0.0;
        
        double a1 = loc1.coordinate.latitude / 180.0 * M_PI;
        double b1 = loc1.coordinate.longitude / 180.0 * M_PI;
        double a2 = loc2.coordinate.latitude / 180.0 * M_PI;
        double b2 = loc2.coordinate.longitude / 180.0 * M_PI;
        return fabs(acos(cos(a1)*cos(b1)*cos(a2)*cos(b2) + cos(a1)*sin(b1)*cos(a2)*sin(b2) + sin(a1)*sin(a2)) * 6378);
        
}

- (double) averageSlopeOverLast:(int)averagePoints {
        double dslope = 0;
        
        if ([locations count] < averagePoints)
                return 0.0;
        
        int start = 0;
        int end = [locations count] - 1;
        if (end - start > averagePoints)
                start = end - averagePoints;
        
        CLLocation *last = nil;
        for (int i = start; i <= end; i++) {
                CLLocation *loc = [locations objectAtIndex:i];
                if (last) {
                        double dist = [self distanceBetweenLocation:last andLocation:loc] * 1000.0;
                        double delta = loc.altitude - last.altitude;
                        dslope += delta / dist;
                }
                last = loc;
        }
        return dslope / averagePoints;
}

- (double) averageSpeedOverLast:(int)averagePoints {
        double dspeed = 0;
        
        if ([locations count] < averagePoints)
                return 0.0;
        
        int start = 0;
        int end = [locations count] - 1;
        if (end - start > averagePoints)
                start = end - averagePoints;
        
        CLLocation *last = nil;
        for (int i = start; i <= end; i++) {
                CLLocation *loc = [locations objectAtIndex:i];
                if (last) {
                        double td = [loc.timestamp timeIntervalSinceDate:last.timestamp] / 3600.0;
                        NSLog([NSString stringWithFormat:@"time diff %f", td]);
                        if (td < 0.0) // Not bloody reasonable
                                continue;
                        double sp = [self distanceBetweenLocation:last andLocation:loc];
                        NSLog([NSString stringWithFormat:@"pre div %f", sp]);
                        sp /= td;
                        NSLog([NSString stringWithFormat:@"aft div %f", sp]);
                        dspeed += sp;
                }
                last = loc;
        }
        
        return dspeed / averagePoints;
}

- (double) averageSpeed {
        int averagePoints = [locations count];
        if (averagePoints > 20)
                averagePoints = 20;
        return [self averageSpeedOverLast:averagePoints];
}


- (NSString*) formatTimestamp:(double)seconds {
        int isec = (int) seconds;
        int hour = (int) (isec / 3600);
        int min = (int) ((isec % 3600) / 60);
        int sec = (int) (isec % 60);
        return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, min, sec];
}

- (NSString*) formatDMS:(double)latLong {
        
        int deg = (int) latLong;
        int min = (int) ((latLong - deg) * 60);
        double sec = (double) ((latLong - deg - min / 60.0) * 3600.0);
        return [NSString stringWithFormat:@"%02d˚ %02d' %02.02f\"", deg, min, sec];
}

- (NSString*) formatLat:(double)lat {
        NSString* sign = lat >= 0 ? @"N" : @"S";
        lat = fabs(lat);
        return [NSString stringWithFormat:@"%@ %@", [self formatDMS:lat], sign]; 
}

- (NSString*) formatLon:(double)lon {
        NSString* sign = lon >= 0 ? @"E" : @"W";
        lon = fabs(lon);
        return [NSString stringWithFormat:@"%@ %@", [self formatDMS:lon], sign]; 
}

- (CLLocation*) averageLocationFromArray:(NSArray*)arrayOfLocations {
        double lat = 0, lon = 0, alt = 0;
        for (CLLocation *loc in arrayOfLocations) {
                lat += loc.coordinate.latitude;
                lon += loc.coordinate.longitude;
                alt += loc.altitude;
        }
        
        int numLocations = [arrayOfLocations count];
        CLLocationCoordinate2D coord;
        coord.latitude = lat / numLocations;
        coord.longitude = lon / numLocations;
        CLLocation *averageLocation = [[[CLLocation alloc] initWithCoordinate:coord altitude:alt/numLocations horizontalAccuracy:0 verticalAccuracy:0 timestamp:[NSDate date]] autorelease];
        return averageLocation;
}

// Called when the location is updated
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
        static NSMutableArray *lastLocations = nil;
        static double minPrec = MINIMUM_PRECISION;
        static double filterDistance = FILTER_DISTANCE;
        
        // Update the state (good = we have enough precision).
        stateGood = (newLocation.horizontalAccuracy <= minPrec);
        
        // If we don't have the required accuracy, end things here.
        if (newLocation.horizontalAccuracy < 0 || newLocation.horizontalAccuracy > minPrec)
                return;
        
        // Set the start time if we haven't
        if (!startTime)
                startTime = [[NSDate date] retain];
        
        // Initialize a new array for position averaging, if we need to
        if (!lastLocations)
                lastLocations = [[NSMutableArray alloc] init]; 
        
        // Save a "direct measurement"
        [lastLocations addObject:newLocation];
        directMeasurements++;
        
        // If we have enough points for an averaged measurement, ...
        if ([lastLocations count] == MULTIPLIER) {
                // Get the average position from the array, and release the array
                newLocation = [self averageLocationFromArray:lastLocations];
                [lastLocations release];
                lastLocations = nil;
                
                averagedMeasurements++;
                
                // distanceBetweenLocation:andLocation will return 0.0 for any nil argument
                distance += [self distanceBetweenLocation:self.lastPosition andLocation:newLocation];
                self.lastPosition = newLocation;
                
                // Save the averaged reading
                [locations addObject:newLocation];
                
                [self pointInGPX:newLocation];
                
                // We want roughly MULTIPLIER position updates every 15 s.
                double curSpeed = [self averageSpeedOverLast:3];
                double newFilterDistance = curSpeed / 3.6 * 15 / MULTIPLIER;
                // But not more than every FILTER_DISTANCE/10 m
                if (newFilterDistance < FILTER_DISTANCE / 10.0)
                        newFilterDistance = FILTER_DISTANCE / 10.0;
                // or less than every FILTER_DISTANCE*10 m
                else if (newFilterDistance > FILTER_DISTANCE * 10.0)
                        newFilterDistance = FILTER_DISTANCE * 10.0;
                // If the desired filter distance is off by more than 15%, correct it
                if (manager.distanceFilter / newFilterDistance < 0.85 || manager.distanceFilter / newFilterDistance > 1.15) {
                        [manager setDistanceFilter:newFilterDistance];
                        filterDistance = newFilterDistance;
                        minPrec = filterDistance * MULTIPLIER * 2.0;
                }
        }
}

- (void)updateDisplay:(NSTimer*)timer
{
        static BOOL prevStateGood = NO;
        
        if (stateGood != prevStateGood) {
                if (stateGood) {
                        [goodSound play];
                        statusIndicator.image = [UIImage imageNamed:@"green-sphere.png"];
                } else {
                        [badSound play];
                        statusIndicator.image = [UIImage imageNamed:@"red-sphere.png"];
                }
                prevStateGood = stateGood;
        }
        
        CLLocation* newLocation = [locations lastObject];
        positionLabel.text = [NSString stringWithFormat:@"%@\n%@\n%.0f m", [self formatLat: newLocation.coordinate.latitude], [self formatLon: newLocation.coordinate.longitude], newLocation.altitude];
        accuracyLabel.text = [NSString stringWithFormat:@"%.0f m", newLocation.horizontalAccuracy];
        
        if (startTime != nil)
                elapsedTimeLabel.text =  [self formatTimestamp:[[NSDate date] timeIntervalSinceDate:startTime]];
        
        NSDictionary* units = [unitSets objectAtIndex:[unitSetSelector selectedSegmentIndex]];
        double distFactor = [[units objectForKey:@"distFactor"] floatValue];
        double speedFactor = [[units objectForKey:@"speedFactor"] floatValue];
        NSString* distFormat = [units objectForKey:@"distFormat"];
        NSString* speedFormat = [units objectForKey:@"speedFormat"];
        
        // Calculate our current speed and slope
        double curSpeed = [self averageSpeedOverLast:3];
        double curSlope = [self averageSlopeOverLast:3];
        
        totalDistanceLabel.text = [NSString stringWithFormat:distFormat, distance*distFactor];
        currentSpeedLabel.text = [NSString stringWithFormat:speedFormat, curSpeed*speedFactor];
        averageSpeedLabel.text = [NSString stringWithFormat:speedFormat, [self averageSpeed]*speedFactor];
        if (curSpeed > 0.0)
                currentTimePerKmLabel.text = [self formatTimestamp:10 * 3600.0 / curSpeed];
        slopeLabel.text = [NSString stringWithFormat:@"%.01f %%", curSlope * 100];
        statusLabel.text = [NSString stringWithFormat:@"%d dir, %d avg", directMeasurements, averagedMeasurements];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
        // Release anything that's not essential, such as cached data
}


- (void)dealloc {
        [super dealloc];
}

@end

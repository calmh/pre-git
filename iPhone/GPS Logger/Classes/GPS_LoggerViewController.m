//
//  GPS_LoggerViewController.m
//  GPS Logger
//
//  Created by Jakob Borg on 4/25/09.
//  Copyright Jakob Borg 2009. All rights reserved.
//

#import "GPS_LoggerViewController.h"

@implementation GPS_LoggerViewController

@synthesize locationManager, speedOverTime, altitudeOverTime, statusIndicator, positionLabel, elapsedTimeLabel, currentSpeedLabel, currentTimePerKmLabel, totalDistanceLabel, totalDistanceUnitLabel, statusLabel, averageSpeedLabel, slopeLabel, accuracyLabel, lastPosition;

 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
         if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
                badSound = [[JBSoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Basso" ofType:@"aiff"]];
                 goodSound = [[JBSoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Purr" ofType:@"aiff"]];
                 stateGood = NO;
                 directMeasurements = 0;
                 averagedMeasurements = 0;
         }
         return self;
 }

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
        
        averageSpeedDS = [[[JBPlotDataSource alloc] init] autorelease];
        self.speedOverTime.delegate = averageSpeedDS;
        
        averageAltitudeDS = [[[JBPlotDataSource alloc] init] autorelease];
        self.altitudeOverTime.delegate = averageAltitudeDS;
        
        [self beginGPX];
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
        int segments = 0;
        
        int start = 0;
        int end = [locations count] - 1;
        if (end - start > averagePoints)
                start = end - averagePoints;
        
        CLLocation *last = nil;
        for (int i = start; i <= end; i++) {
                CLLocation *loc = [locations objectAtIndex:i];
                if (last) {
                        double dist = [self distanceBetweenLocation:last andLocation:loc];
                        double delta = loc.altitude - last.altitude;
                        dslope += delta / dist;
                        segments++;
                }
                last = loc;
        }
        return dslope / segments;
}

- (double) averageSpeedOverLast:(int)averagePoints {
        double dspeed = 0;
        int segments = 0;
        
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
                        segments++;
                }
                last = loc;
        }
        return dspeed / segments;
}

- (double) averageSpeed {
        return [self averageSpeedOverLast:[locations count]];
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

        if (newLocation.horizontalAccuracy > MINIMUM_PRECISION) {
                // Precision is too bad to do anything useful.
                statusIndicator.image = [UIImage imageNamed:@"red-sphere.png"];
                if (stateGood) {
                        [badSound play];
                        stateGood = NO;
                }
        }
        else {
                if (newLocation.horizontalAccuracy > FILTER_DISTANCE * MULTIPLIER)
                        statusIndicator.image = [UIImage imageNamed:@"yellow-sphere.png"];
                else
                        statusIndicator.image = [UIImage imageNamed:@"green-sphere.png"];
                
                if (!stateGood) {
                        [goodSound play];
                        stateGood = YES;
                }
        }
        
        positionLabel.text = [NSString stringWithFormat:@"%@\n%@\n%.0f m", [self formatLat: newLocation.coordinate.latitude], [self formatLon: newLocation.coordinate.longitude], newLocation.altitude];
        accuracyLabel.text = [NSString stringWithFormat:@"%.0f", newLocation.horizontalAccuracy];
        
        // If we don't have the required accuracy, end things here.
        if (newLocation.horizontalAccuracy < 0 || newLocation.horizontalAccuracy > MINIMUM_PRECISION)
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
        
        // Update the elapsed time
        elapsedTimeLabel.text =  [self formatTimestamp:[[NSDate date] timeIntervalSinceDate:startTime]];
        
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
                
                // Calculate our curren speed and slope
                double curSpeed = [self averageSpeedOverLast:3];
                double curSlope = [self averageSlopeOverLast:3];
                
                // Save the averaged reading
                [locations addObject:newLocation];
                
                // Save our current speed to the datastore for the speed grah and redraw
                [averageSpeedDS addValue:curSpeed];
                [speedOverTime setNeedsDisplay];
                
                // Save our current altitude for that graph and redraw
                [averageAltitudeDS addValue:newLocation.altitude];
                [altitudeOverTime setNeedsDisplay];
                
                // Update the total distance travelled, in units of meters or kilometers, depending...
                if (distance >= 1000) {
                        totalDistanceLabel.text = [NSString stringWithFormat:@"%.02f", distance];
                        totalDistanceUnitLabel.text = @"km (tot)";
                } else {
                        totalDistanceLabel.text = [NSString stringWithFormat:@"%.0f", distance];
                        totalDistanceUnitLabel.text = @"m (tot)";
                }
                // Update the other readings on the display
                currentSpeedLabel.text = [NSString stringWithFormat:@"%.01f", curSpeed];
                averageSpeedLabel.text = [NSString stringWithFormat:@"%.01f", [self averageSpeed]];
                currentTimePerKmLabel.text = [self formatTimestamp:10 * 3600.0 / curSpeed];
                slopeLabel.text = [NSString stringWithFormat:@"%.01f%%", curSlope * 100];
                
                [self pointInGPX:newLocation];
        }

        // Update the status with the current number of saved readings.
        statusLabel.text = [NSString stringWithFormat:@"%d direct, %d averaged", directMeasurements, averagedMeasurements];
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

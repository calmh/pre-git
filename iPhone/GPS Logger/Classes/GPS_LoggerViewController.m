//
//  GPS_LoggerViewController.m
//  GPS Logger
//
//  Created by Jakob Borg on 4/25/09.
//  Copyright Jakob Borg 2009. All rights reserved.
//

#import "GPS_LoggerViewController.h"

@implementation GPS_LoggerViewController

@synthesize locationManager;
@synthesize latitude, longitude, horizontalAcc, totalDistance, speed, measurements, elapsedTime, timePer10km;

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


- (void)beginGPX {
        NSString* start = @"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n<gpx\nversion=\"1.1\"\ncreator=\"TrailRunner http://www.TrailRunnerx.com\"\nxmlns=\"http://www.topografix.com/GPX/1/1\"\nxmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\nxsi:schemaLocation=\"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd\">\n<trk>\n<trkseg>\n";
        [start writeToFile:filename atomically:NO encoding:NSASCIIStringEncoding error:nil];
}

- (void)endGPX {
        NSString* end = @"</trkseg>\n</trk>\n</gpx>\n";
        NSFileHandle *aFileHandle;
        aFileHandle = [NSFileHandle fileHandleForWritingAtPath:filename];
        [aFileHandle truncateFileAtOffset:[aFileHandle seekToEndOfFile]];
        [aFileHandle writeData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        [aFileHandle closeFile];
}

- (void)pointInGPX:(CLLocation*)loc {
        NSString* ts = [loc.timestamp descriptionWithCalendarFormat:@"%Y-%m-%dT%H:%M:%SZ" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
        
        NSString* data = [NSString stringWithFormat:@"<trkpt lat=\"%f\" lon=\"%f\">\n<time>%@</time>\n</trkpt>\n",
                          loc.coordinate.latitude, loc.coordinate.longitude, ts];

        NSFileHandle *aFileHandle;
        aFileHandle = [NSFileHandle fileHandleForWritingAtPath:filename];
        [aFileHandle truncateFileAtOffset:[aFileHandle seekToEndOfFile]];
        [aFileHandle writeData:[data dataUsingEncoding:NSUTF8StringEncoding]];
        [aFileHandle closeFile];
}
        
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
        [super viewDidLoad];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	filename = [NSString stringWithFormat:@"%@/track-%@.gpx", documentsDirectory, [[NSDate date] description]];
        [filename retain];
        
        lastTen = [[NSMutableArray alloc] init];
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.distanceFilter = FILTER_DISTANCE;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
        distance = 0;
        
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        [[UIApplication sharedApplication] setProximitySensingEnabled:YES];
        
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
        double a1 = loc1.coordinate.latitude / 180.0 * M_PI;
        double b1 = loc1.coordinate.longitude / 180.0 * M_PI;
        double a2 = loc2.coordinate.latitude / 180.0 * M_PI;
        double b2 = loc2.coordinate.longitude / 180.0 * M_PI;
        return fabs(acos(cos(a1)*cos(b1)*cos(a2)*cos(b2) + cos(a1)*sin(b1)*cos(a2)*sin(b2) + sin(a1)*sin(a2)) * 6378);
        
}

- (double) averageSpeed {
        double dspeed = 0;
        int segments = 0;
        CLLocation *last = nil;
        for (CLLocation *loc in lastTen) {
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
        return [NSString stringWithFormat:@"%02d˚ %02d' %.02f\"", deg, min, sec];
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

// Called when the location is updated
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
        static int count = 0;
        static CLLocation *last = nil;
        
        horizontalAcc.text = [NSString stringWithFormat:@"%f m", newLocation.horizontalAccuracy];
        latitude.text = [self formatLat: newLocation.coordinate.latitude];
        longitude.text = [self formatLon: newLocation.coordinate.longitude];
        
        if (newLocation.horizontalAccuracy < 0 || newLocation.horizontalAccuracy > MINIMUM_PRECISION) {
                horizontalAcc.textColor = [UIColor redColor];
                latitude.textColor = [UIColor redColor];
                longitude.textColor = [UIColor redColor];
                measurements.textColor = [UIColor grayColor];
                totalDistance.textColor = [UIColor grayColor];
                speed.textColor = [UIColor grayColor];
                timePer10km.textColor = [UIColor grayColor];
                return;
        } else {
                if (!startTime)
                        startTime = [[NSDate date] retain];
                
                horizontalAcc.textColor = [UIColor greenColor];
                latitude.textColor = [UIColor whiteColor];
                longitude.textColor = [UIColor whiteColor];
                measurements.textColor = [UIColor whiteColor];
                totalDistance.textColor = [UIColor whiteColor];
                speed.textColor = [UIColor whiteColor];
                timePer10km.textColor = [UIColor whiteColor];
                
                ++count;
                
                if (last) {
                        distance += [self distanceBetweenLocation:last andLocation:newLocation];
                        totalDistance.text = [NSString stringWithFormat:@"%.02f km", distance];
                }
                
                measurements.text = [NSString stringWithFormat:@"%d", count];
                elapsedTime.text =  [self formatTimestamp:[[NSDate date] timeIntervalSinceDate:startTime]];
                
                [lastTen addObject:newLocation];
                if ([lastTen count] > 10)
                        [lastTen removeObjectAtIndex:0];
                
                double avgspeed = [self averageSpeed];
                speed.text = [NSString stringWithFormat:@"%.1f km/h", avgspeed];
                timePer10km.text = [self formatTimestamp:10.0 / avgspeed * 3600.0];
                
                if (last)
                        [last release];
                last = newLocation;
                [last retain];

                [self pointInGPX:newLocation];
        }
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

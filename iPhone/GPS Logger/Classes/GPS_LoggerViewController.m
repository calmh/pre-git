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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
        [super viewDidLoad];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	filename = [NSString stringWithFormat:@"%@/track-%@.kml", documentsDirectory, [[NSDate date] description]];
        [filename retain];
        [@"<?xml version='1.0' encoding='UTF-8'?>\n<kml xmlns='http://www.opengis.net/kml/2.2'>\n<Document>\n<name>default.kml</name>\n<open>1</open>\n<Style id='linestyle'><LineStyle><color>af0000ff</color><width>4</width></LineStyle></Style>\n<Placemark>\n<name>extruded</name>\n<styleUrl>#linestyle</styleUrl>\n<LineString>\n<extrude>0</extrude>\n<tessellate>1</tessellate>\n<altitudeMode>clampToGround</altitudeMode>\n<coordinates>\n" writeToFile:filename atomically:NO encoding:NSASCIIStringEncoding error:nil];
        
        lastTen = [[NSMutableArray alloc] init];
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.distanceFilter = FILTER_DISTANCE;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
        distance = 0;
        
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        
        [self.locationManager stopUpdatingLocation];
        self.locationManager.delegate = nil;
        
        NSFileHandle *aFileHandle;
        aFileHandle = [NSFileHandle fileHandleForWritingAtPath:filename];
        [aFileHandle truncateFileAtOffset:[aFileHandle seekToEndOfFile]];
        [aFileHandle writeData:[@"</coordinates>\n</LineString>\n</Placemark>\n</Document>\n</kml>" dataUsingEncoding:NSASCIIStringEncoding]];
        [aFileHandle closeFile];
        
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
                
                NSMutableString *record = [[NSMutableString alloc] init];
                [record appendFormat:@"%f,", newLocation.coordinate.longitude];
                [record appendFormat:@"%f\n", newLocation.coordinate.latitude];
                
                NSFileHandle *aFileHandle;
                aFileHandle = [NSFileHandle fileHandleForWritingAtPath:filename];
                [aFileHandle truncateFileAtOffset:[aFileHandle seekToEndOfFile]];
                [aFileHandle writeData:[record dataUsingEncoding:NSASCIIStringEncoding]];
                [aFileHandle closeFile];
                [record release];
                
                if (last)
                        [last release];
                last = newLocation;
                [last retain];
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

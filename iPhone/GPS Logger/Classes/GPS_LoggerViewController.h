//
//  GPS_LoggerViewController.h
//  GPS Logger
//
//  Created by Jakob Borg on 4/25/09.
//  Copyright Jakob Borg 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GPS_LoggerViewController : UIViewController <CLLocationManagerDelegate> {
        CLLocationManager *locationManager;
        UILabel *latitude;
        UILabel *longitude;
        UILabel *horizontalAcc;
        UILabel *totalDistance;
        UILabel *speed;
        UILabel *measurements;
        UILabel *elapsedTime;
        UILabel *timePer10km;
        NSMutableArray *lastTen;
        NSString *filename;
        NSDate *startTime;
        double distance;
}

@property (nonatomic, retain) IBOutlet UILabel *latitude;
@property (nonatomic, retain) IBOutlet UILabel *longitude;
@property (nonatomic, retain) IBOutlet UILabel *horizontalAcc;
@property (nonatomic, retain) IBOutlet UILabel *totalDistance;
@property (nonatomic, retain) IBOutlet UILabel *speed;
@property (nonatomic, retain) IBOutlet UILabel *measurements;
@property (nonatomic, retain) IBOutlet UILabel *elapsedTime;
@property (nonatomic, retain) IBOutlet UILabel *timePer10km;
@property (nonatomic, retain) CLLocationManager *locationManager;

@end


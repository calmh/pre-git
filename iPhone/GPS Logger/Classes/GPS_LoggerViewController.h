//
//  GPS_LoggerViewController.h
//  GPS Logger
//
//  Created by Jakob Borg on 4/25/09.
//  Copyright Jakob Borg 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JBLinePlotView.h"
#import "JBPlotDataSource.h"
#import "JBSoundEffect.h"

@interface GPS_LoggerViewController : UIViewController <CLLocationManagerDelegate> {
        CLLocationManager *locationManager;
        CLLocation* lastPosition;
        
        NSMutableArray *locations;
        NSString *filename;
        NSDate *startTime;
        double distance;
        JBLinePlotView *speedOverTime;
        JBLinePlotView *altitudeOverTime;
        JBPlotDataSource *averageSpeedDS;
        JBPlotDataSource *averageAltitudeDS;
        JBSoundEffect *goodSound;
        JBSoundEffect *badSound;
        bool stateGood;
        int directMeasurements;
        int averagedMeasurements;
        
        UIImageView *statusIndicator;
        UILabel *positionLabel;
        UILabel *elapsedTimeLabel;
        UILabel *currentSpeedLabel;
        UILabel *averageSpeedLabel;
        UILabel *currentTimePerKmLabel;
        UILabel *totalDistanceLabel;
        UILabel *totalDistanceUnitLabel;
        UILabel *statusLabel;
        UILabel *slopeLabel;
        UILabel *accuracyLabel;
}

@property (retain) CLLocationManager *locationManager;
@property (retain) IBOutlet JBLinePlotView *speedOverTime;
@property (retain) IBOutlet JBLinePlotView *altitudeOverTime;
@property (retain) IBOutlet UIImageView *statusIndicator;
@property (retain) IBOutlet UILabel *positionLabel;
@property (retain) IBOutlet UILabel *elapsedTimeLabel;
@property (retain) IBOutlet UILabel *currentSpeedLabel;
@property (retain) IBOutlet UILabel *averageSpeedLabel;
@property (retain) IBOutlet UILabel *currentTimePerKmLabel;
@property (retain) IBOutlet UILabel *totalDistanceLabel;
@property (retain) IBOutlet UILabel *totalDistanceUnitLabel;
@property (retain) IBOutlet UILabel *statusLabel;
@property (retain) IBOutlet UILabel *slopeLabel;
@property (retain) IBOutlet UILabel *accuracyLabel;
@property (retain) IBOutlet CLLocation* lastPosition;

@end


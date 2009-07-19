//
//  GlintViewController.h
//  Glint
//
//  Created by Jakob Borg on 6/26/09.
//  Copyright Jakob Borg 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JBSoundEffect.h"
#import "GlintCompassView.h"
#import "GlintGPXWriter.h"
#import "GlintAppDelegate.h"

typedef enum enumGlintDataSource {
        kGlintDataSourceMovement,
        kGlintDataSourceTimer
} GlintDataSource;

@interface GlintViewController : UIViewController  <CLLocationManagerDelegate> {
        CLLocationManager *locationManager;
        NSArray *unitSets;
        GlintGPXWriter *gpxWriter;
        NSDate *firstMeasurementDate;
        NSDate *lastMeasurementDate;
        CLLocation *previousMeasurement;
        GlintDataSource currentDataSource;
        double totalDistance;
        JBSoundEffect *goodSound;
        JBSoundEffect *badSound;
        double currentCourse;
        double currentSpeed;
        BOOL gpsEnabled;
        NSArray *lockedToolbarItems;
        NSArray *recordingToolbarItems;
        NSArray *pausedToolbarItems;
        NSTimer *lockTimer;

        UILabel *positionLabel;
        UILabel *elapsedTimeLabel;
        UILabel *currentSpeedLabel;
        UILabel *averageSpeedLabel;
        UILabel *currentTimePerDistanceLabel;
        UILabel *totalDistanceLabel;
        UILabel *statusLabel;
        UILabel *bearingLabel;
        UILabel *accuracyLabel;
        UILabel *recordingIndicator;
        UILabel *signalIndicator;
        
        UILabel *elapsedTimeDescrLabel;
        UILabel *totalDistanceDescrLabel;
        UILabel *currentTimePerDistanceDescrLabel;
        UILabel *currentSpeedDescrLabel;
        UILabel *averageSpeedDescrLabel;

        UIToolbar *toolbar;
        GlintCompassView *compass;
}

@property (nonatomic, retain) IBOutlet UILabel *positionLabel;
@property (nonatomic, retain) IBOutlet UILabel *elapsedTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *currentSpeedLabel;
@property (nonatomic, retain) IBOutlet UILabel *averageSpeedLabel;
@property (nonatomic, retain) IBOutlet UILabel *currentTimePerDistanceLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalDistanceLabel;
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UILabel *bearingLabel;
@property (nonatomic, retain) IBOutlet UILabel *accuracyLabel;
@property (nonatomic, retain) IBOutlet UILabel *recordingIndicator;
@property (nonatomic, retain) IBOutlet UILabel *signalIndicator;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet GlintCompassView *compass;

@property (nonatomic, retain) IBOutlet UILabel *elapsedTimeDescrLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalDistanceDescrLabel;
@property (nonatomic, retain) IBOutlet UILabel *currentTimePerDistanceDescrLabel;
@property (nonatomic, retain) IBOutlet UILabel *currentSpeedDescrLabel;
@property (nonatomic, retain) IBOutlet UILabel *averageSpeedDescrLabel;

- (IBAction)startStopRecording:(id)sender;
- (IBAction)unlock:(id)sender;

@end

//
//  GPS_LoggerAppDelegate.h
//  GPS Logger
//
//  Created by Jakob Borg on 4/25/09.
//  Copyright Jakob Borg 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPS_LoggerViewController;

@interface GPS_LoggerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GPS_LoggerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GPS_LoggerViewController *viewController;

@end


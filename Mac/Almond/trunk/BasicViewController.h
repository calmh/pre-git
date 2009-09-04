//
//  BasicViewController.h
//  Almond
//
//  Created by Jakob Borg on 9/4/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Almond_AppDelegate;

@interface BasicViewController : NSViewController {
        Almond_AppDelegate *appDelegate;
        NSView *rightDrawerView;
        NSView *leftDrawerView;        
}

@property (retain, nonatomic) IBOutlet Almond_AppDelegate *appDelegate;
@property (retain, nonatomic) IBOutlet NSView *rightDrawerView;
@property (retain, nonatomic) IBOutlet NSView *leftDrawerView;

- (NSManagedObjectContext*)managedObjectContext;
- (void)slideViewToX:(float)xCoordinate;
- (void)fadeOut;
- (void)fadeIn;

@end

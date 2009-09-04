//
//  BasicViewController.m
//  Almond
//
//  Created by Jakob Borg on 9/4/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "BasicViewController.h"


@implementation BasicViewController

@synthesize appDelegate;
@synthesize rightDrawerView;
@synthesize leftDrawerView;

- (NSManagedObjectContext*)managedObjectContext {
        return [self.appDelegate managedObjectContext];
}

- (void)slideViewToX:(float)xCoordinate {
        NSRect rect = [[self view] frame];
        rect.origin.x = xCoordinate;
        [[[self view] animator] setFrame:rect];
}

- (void)fadeOut {
        [[self view] setAlphaValue:1.0f];
        [[[self view] animator] setAlphaValue:0.0f];
        //[[[[self view] animator] layer] setZPosition:-100.0f];
        [[self view] setHidden:YES];
}

- (void)fadeIn {
        [[self view] setAlphaValue:0.0f];
        [[[self view] animator] setAlphaValue:1.0f];
        //[[[[self view] animator] layer] setZPosition:100.0f];
        [[self view] setHidden:NO];
}

@end

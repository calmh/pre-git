//
//  MethodViewController.h
//  Almond
//
//  Created by Jakob Borg on 9/4/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicViewController.h"

@interface MethodViewController : BasicViewController {
        NSArrayController *testArrayController;
        NSArrayController *actionArrayController;
}

@property (retain, nonatomic) IBOutlet NSArrayController *testArrayController;
@property (retain, nonatomic) IBOutlet NSArrayController *actionArrayController;

- (void)itemWasDoubleClicked:(id)object;

@end

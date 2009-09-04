//
//  RuleViewController.h
//  Almond
//
//  Created by Jakob Borg on 9/4/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>
#import "BasicViewController.h"

@interface RuleViewController : BasicViewController {
        NSArrayController *ruleArrayController;
}

@property (retain, nonatomic) IBOutlet NSArrayController *ruleArrayController;

- (IBAction)addNewRule:(id)sender;

@end

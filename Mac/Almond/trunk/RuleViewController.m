//
//  RuleViewController.m
//  Almond
//
//  Created by Jakob Borg on 9/4/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "RuleViewController.h"


@implementation RuleViewController

@synthesize ruleArrayController;

- (void)setRepresentedObject:(id)representedObject {
        [super setRepresentedObject:representedObject];
        [self.ruleArrayController setFetchPredicate:[NSPredicate predicateWithFormat:@"folder == %@", representedObject]];
}

- (IBAction)addNewRule:(id)sender {
         NSManagedObject *rule = [NSEntityDescription insertNewObjectForEntityForName:@"Rule" inManagedObjectContext:[self managedObjectContext]];
         NSManagedObject *folder = [self representedObject];
         [folder addRulesObject:rule];
}

@end

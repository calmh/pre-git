//
//  MethodViewController.m
//  Almond
//
//  Created by Jakob Borg on 9/4/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "MethodViewController.h"


@implementation MethodViewController

@synthesize testArrayController;
@synthesize actionArrayController;

- (void)itemWasDoubleClicked:(id)object {
        // Create a new method invocation for the sent object
                NSManagedObject* invocation = nil;
        NSString *task = [object valueForKeyPath:@"task"];
        if ([task isEqualToString:@"action"])
                invocation = [NSEntityDescription insertNewObjectForEntityForName:@"Action" inManagedObjectContext:[self managedObjectContext]];
        else if ([task isEqualToString:@"test"])
                invocation = [NSEntityDescription insertNewObjectForEntityForName:@"Test" inManagedObjectContext:[self managedObjectContext]];
        [invocation setValue:object forKeyPath:@"method"];
        [invocation setValue:[self representedObject] forKeyPath:@"rule"];
}

@end

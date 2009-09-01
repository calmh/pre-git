//
//  Folder.m
//  Almond
//
//  Created by Jakob Borg on 8/29/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "Folder.h"

@implementation Folder

@synthesize folderName;

- (NSArray*)rules {
        return [NSArray arrayWithObjects:@"Rule one", @"Rule two", nil];
}

@end

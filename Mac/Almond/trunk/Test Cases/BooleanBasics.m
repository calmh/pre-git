//
//  BooleanBasics.m
//  Almond
//
//  Created by Jakob Borg on 8/19/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "BooleanBasics.h"

@implementation BooleanBasics

- (id)initWithValue:(BOOL)newValue {
        if (self = [super init]) {
                value = newValue;
        }
        return self;
}

- (BOOL)evaluate {
        return value;
}

@end

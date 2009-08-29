//
//  Model.m
//  Almond
//
//  Created by Jakob Borg on 8/19/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "Model.h"

@implementation Model

- (id)init {
        if (self = [super init]) {
                manager = [[NSClassFromString(@"LibraryManager") alloc] init];
                NSArray *modules = [manager modules];
                for (id module in modules) {
                        NSLog(@"Module: %@", module);
                        NSArray* tests = [manager methodsInModule:module];
                        for (id test in tests) {
                                NSLog(@"Method: %@", test);
                                NSLog(@"Method description: %@", [manager descriptionForMethod:test inModule:module]);
                                 int nump = [[manager numberOfParametersForMethod:test inModule:module] intValue];
                                NSLog(@"Number of method parameters: %d", nump);
                        }
                }
        }
        return self;
}

@end

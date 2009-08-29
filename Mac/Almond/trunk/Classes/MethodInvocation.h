//
//  MethodInvocation.h
//  Almond
//
//  Created by Jakob Borg on 8/19/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Evaluable.h"
#import "Method.h"

@interface MethodInvocation : Evaluable {
        Method *method;
        NSArray *parameterValues;
}

@property (retain, nonatomic) Method *method;
@property (retain, nonatomic) NSArray *parameterValues;

@end

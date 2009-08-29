//
//  Expression.m
//  Almond
//
//  Created by Jakob Borg on 8/19/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "Expression.h"

@implementation Expression

@synthesize expressionA, expressionB;
@synthesize operator;
@synthesize invert;

- (BOOL) evaluate {
        if (expressionA == nil)
                return NO;
        
        BOOL result = [expressionA evaluate];
        
        if (expressionB != nil) {
                if (operator == AND) {
                        result &= [expressionB evaluate];
                } else if (operator == OR && !result) {
                        result |= [expressionB evaluate];
                }
        }
        
        if (invert)
                return !result;
        else
                return result;
}

@end

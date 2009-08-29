//
//  Expression.h
//  Almond
//
//  Created by Jakob Borg on 8/19/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Evaluable.h"

typedef enum { AND, OR } BooleanOperator;

@interface Expression : Evaluable {
        Evaluable *expressionA, *expressionB;
        BooleanOperator operator;
        BOOL invert;
}

@property (retain, nonatomic) Evaluable *expressionA, *expressionB;
@property BooleanOperator operator;
@property BOOL invert;

@end

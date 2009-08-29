//
//  ExpressionTests.m
//  Almond
//
//  Created by Jakob Borg on 8/19/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "ExpressionTests.h"

@implementation ExpressionTests

- (void)testBooleanBasics {
        BooleanBasics *btrue = [[BooleanBasics alloc] initWithValue:YES];
        BooleanBasics *bfalse = [[BooleanBasics alloc] initWithValue:NO];
        STAssertTrue([btrue evaluate], @"Should evaluate to true.");
        STAssertFalse([bfalse evaluate], @"Should evaluate to false.");
        
        Expression *exp = [[Expression alloc] init];
        exp.expressionA = btrue;
        exp.expressionB = btrue;

        exp.operator = OR;
        exp.invert = NO;
        STAssertTrue([exp evaluate], @"true | true == true");

        exp.operator = OR;
        exp.invert = YES;
        STAssertFalse([exp evaluate], @"!(true | true) == false");
        
        exp.operator = AND;
        exp.invert = NO;
        STAssertTrue([exp evaluate], @"true & true == true");

        exp.operator = AND;
        exp.invert = YES;
        STAssertFalse([exp evaluate], @"!(true & true) == false");

        exp.expressionA = bfalse;
        exp.expressionB = btrue;
        
        exp.operator = OR;
        exp.invert = NO;
        STAssertTrue([exp evaluate], @"false | true == true");
        
        exp.operator = OR;
        exp.invert = YES;
        STAssertFalse([exp evaluate], @"!(false | true) == false");
        
        exp.operator = AND;
        exp.invert = NO;
        STAssertFalse([exp evaluate], @"false & true == false");
        
        exp.operator = AND;
        exp.invert = YES;
        STAssertTrue([exp evaluate], @"!(false & true) == true");

        exp.expressionA = btrue;
        exp.expressionB = bfalse;
        
        exp.operator = OR;
        exp.invert = NO;
        STAssertTrue([exp evaluate], @"true | false == true");
        
        exp.operator = OR;
        exp.invert = YES;
        STAssertFalse([exp evaluate], @"!(true | false) == false");
        
        exp.operator = AND;
        exp.invert = NO;
        STAssertFalse([exp evaluate], @"true & false == false");
        
        exp.operator = AND;
        exp.invert = YES;
        STAssertTrue([exp evaluate], @"!(true & false) == true");
}

@end

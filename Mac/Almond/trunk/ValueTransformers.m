//
//  ADIconTransformer.m
//  Almond
//
//  Created by Jakob Borg on 7/15/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "ValueTransformers.h"


@implementation IconImageTransformer

+ (Class)transformedValueClass
{
        return [NSString self];
}

+ (BOOL)allowsReverseTransformation
{
        return NO;
}

- (id)transformedValue:(id)beforeObject
{
        if (beforeObject == nil) return nil;
        NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:beforeObject];
        [icon setSize:NSMakeSize(64, 64)];
        return icon;
}

@end

@implementation NumChildrenTransformer

+ (Class)transformedValueClass
{
        return [NSString self];
}

+ (BOOL)allowsReverseTransformation
{
        return NO;
}

- (id)transformedValue:(id)beforeObject
{
        if (beforeObject == nil) return nil;
        int count = [[[NSFileManager defaultManager]  directoryContentsAtPath:beforeObject] count];
        return [NSString stringWithFormat:@"%d", count];
}
@end

@implementation DirectorySizeTransformer

+ (Class)transformedValueClass
{
        return [NSString self];
}

+ (BOOL)allowsReverseTransformation
{
        return NO;
}

- (id)transformedValue:(id)beforeObject
{
        if (beforeObject == nil) return nil;
        int count = [[[NSFileManager defaultManager]  directoryContentsAtPath:beforeObject] count];
        return [NSString stringWithFormat:@"%d", count];
}
@end

@implementation TrueIfEmpty

+ (Class)transformedValueClass
{
        return [NSString self];
}

+ (BOOL)allowsReverseTransformation
{
        return NO;
}

- (id)transformedValue:(id)beforeObject
{
        if (beforeObject == nil) return [NSNumber numberWithInt:1];
        if ([beforeObject respondsToSelector:@selector(count)])
                if ([beforeObject count] > 0)
                        return [NSNumber numberWithInt:0];
        else
                return [NSNumber numberWithInt:1];
}
@end

@implementation FalseIfEmpty

+ (Class)transformedValueClass
{
        return [NSString self];
}

+ (BOOL)allowsReverseTransformation
{
        return NO;
}

- (id)transformedValue:(id)beforeObject
{
        if (beforeObject == nil) return [NSNumber numberWithInt:0];
        if ([beforeObject respondsToSelector:@selector(count)])
                if ([beforeObject count] > 0)
                        return [NSNumber numberWithInt:1];
                else
                        return [NSNumber numberWithInt:0];
}
@end

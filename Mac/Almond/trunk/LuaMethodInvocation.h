//
//  ADMethodInvocation.h
//  Almond
//
//  Created by Jakob Borg on 6/23/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LuaMethodInvocation : NSManagedObject {
}

- (BOOL) executeForFilename:(NSString*)filename;

@end

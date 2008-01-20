//
//  NameMapper.h
//  XDownloader
//
//  Created by Jakob Borg on 2005-05-26.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NameMapper : NSObject {
@private
	NSMutableDictionary* mapping;
	NSMutableArray* sourceNames;
}

-(void) addSourceName: (NSString*) sourceName;
-(NSDictionary*) getMappings;
-(NSString*) remapName: (NSString*) source;
-(NSString*) getExample: (NSString*) aTemplate;
-(NSString*) postProcessName: (NSString*) source;
@end

//
//  CameraData.h
//  Axis Viewer
//
//  Created by Jakob Borg on 3/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface CameraData : NSObject {
	NSString *description;
	NSString *address;
	NSString *username;
	NSString *password;
}

@property(copy, readwrite) NSString *description;
@property(copy, readwrite) NSString *address;
@property(copy, readwrite) NSString *username;
@property(copy, readwrite) NSString *password;


@end

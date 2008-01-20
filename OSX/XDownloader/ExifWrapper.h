//
//  ExifWrapper.h
//  XDownloader
//
//  Created by Jakob Borg on 2005-05-30.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ExifWrapper : NSObject {
	@private
	NSMutableDictionary* exifData;
}

-(id) initWithFilename: (NSString*) filename;
-(NSDictionary*) exifFields;
@end

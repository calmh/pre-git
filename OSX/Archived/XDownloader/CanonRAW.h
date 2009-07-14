//
//  CanonRAW.h
//  XDownloader
//
//  Created by Jakob Borg on 2005-07-08.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CanonRAW : NSObject {
}
+ (NSData*) extractJpegFromRaw: (NSString*) filename;
@end

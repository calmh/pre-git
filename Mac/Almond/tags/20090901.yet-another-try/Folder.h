//
//  Folder.h
//  Almond
//
//  Created by Jakob Borg on 8/29/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Folder : NSObject {

}

@property (retain, nonatomic) NSString *folderName;
@property (readonly) NSArray *rules;

@end

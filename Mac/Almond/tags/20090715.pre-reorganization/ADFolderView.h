//
//  ADFolderView.h
//  Almond
//
//  Created by Jakob Borg on 7/8/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ADIconTransformer.h"

@interface ADFolderView : NSView {
        NSImageView *iconView;
        BOOL selected;
}

@property (retain, nonatomic) IBOutlet NSImageView *iconView;
@property (assign, nonatomic) BOOL selected;

@end

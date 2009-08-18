//
//  ADFolderView.h
//  Almond
//
//  Created by Jakob Borg on 7/8/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SelectableDetailView : NSView {
        BOOL selected;
}

@property (assign, nonatomic) BOOL selected;

@end

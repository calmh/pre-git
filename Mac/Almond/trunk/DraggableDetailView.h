//
//  DraggableDetailView.h
//  Almond
//
//  Created by Jakob Borg on 9/4/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DraggableDetailView : NSView {
        id representedObject;
        id delegate;
}

@property (retain, nonatomic) id representedObject;
@property (retain, nonatomic) id delegate;

@end

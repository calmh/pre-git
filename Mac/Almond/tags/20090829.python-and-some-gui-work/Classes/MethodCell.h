//
//  MethodCell.h
//  Almond
//
//  Created by Jakob Borg on 8/20/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MethodCell : NSTextFieldCell {
	id delegate;
	NSString* iconKeyPath;
	NSString* primaryTextKeyPath;
	NSString* secondaryTextKeyPath;
}

- (void) setDataDelegate: (id) aDelegate;

- (void) setIconKeyPath: (NSString*) path;
- (void) setPrimaryTextKeyPath: (NSString*) path;
- (void) setSecondaryTextKeyPath: (NSString*) path;

@end

@interface NSObject(MethodCellDelegate)

- (NSImage*) iconForCell:(MethodCell*)cell data: (NSObject*) data;
- (NSString*) primaryTextForCell: (MethodCell*) cell data: (NSObject*) data;
- (NSString*) secondaryTextForCell: (MethodCell*) cell data: (NSObject*) data;

// optional: give the delegate a chance to set a different data object
// This is especially useful for those cases where you do not want that NSCell creates copies of your data objects (e.g. Core Data objects).
// In this case you bind a value to the NSTableColumn that enables you to retrieve the correct data object. You retrieve the objects
// in the method dataElementForCell
- (NSObject*) dataElementForCell: (MethodCell*) cell;

// optional
- (BOOL) disabledForCell: (MethodCell*) cell data: (NSObject*) data;

@end
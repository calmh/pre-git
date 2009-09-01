//
//  DataStore.m
//  Almond
//
//  Created by Jakob Borg on 8/30/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore

- (void)dealloc {
        [folders dealloc];
        [super dealloc];
}

- (id)init {
        if (self = [super init]) {
                Folder *f1, *f2, *f3;
                f1 = [[[Folder alloc] init] autorelease];
                f1.folderName = @"Folder A";
                f2 = [[[Folder alloc] init] autorelease];
                f2.folderName = @"Folder B";
                f3 = [[[Folder alloc] init] autorelease];
                f3.folderName = @"Folder C";
                folders = [[NSArray arrayWithObjects:f1, f2, f3, nil] retain];
        }  
        return self;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
        if (item == nil)  {
                // Root
                return [folders objectAtIndex:index];
        } else if ([item isKindOfClass:[Folder class]]) {
                return [((Folder*)item).rules objectAtIndex:index];
        } else {
                return nil;
        }

}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
        if (item == nil)  {
                // Root
                return [folders count];
        } else if ([item isKindOfClass:[Folder class]]) {
                return [((Folder*)item).rules count];
        } else {
                return 0;
        }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
        if (item == nil || [item isKindOfClass:[Folder class]])
                return YES;
        else 
                return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
        if ([item isKindOfClass:[Folder class]])
                return ((Folder*)item).folderName;
        else if ([item isKindOfClass:[NSString class]])
                return [NSString stringWithFormat:@"NSString: %@", item];
        else
                return @"Unknown object";

}

@end

//
//  ADFolderCollection.m
//  Almond
//
//  Created by Jakob Borg on 7/8/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "SelectableCollectionView.h"

@implementation SelectableCollectionView

- (void)awakeFromNib {
        self.itemHeight = 88;
}

- (float)itemHeight {
        return [self maxItemSize].height;
}

- (void)setItemHeight:(float)height {
        NSSize size;
        size.width = 0;
        size.height = height;
        [self setMaxItemSize:size];        
}

- (NSCollectionViewItem *)newItemForRepresentedObject:(id)object {
        
        // Get a copy of the item prototype, set represented object
        NSCollectionViewItem *newItem = [[self itemPrototype] copy];
        [newItem setRepresentedObject:object];
        
        // Get the new item's view so you can mess with it
        NSView *itemView = [newItem view];
        if ([itemView respondsToSelector:@selector(setRepresentedObject:)])
                [itemView setRepresentedObject:object];
        
        return newItem;
}

@end

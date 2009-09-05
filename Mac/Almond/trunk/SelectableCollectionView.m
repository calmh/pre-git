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
        [self setMinItemSize:size];        
}

- (NSCollectionViewItem *)newItemForRepresentedObject:(id)object {
        NSCollectionViewItem *newItem = [[self itemPrototype] copy];
        [newItem setRepresentedObject:object];
        
        NSView *itemView = [newItem view];
        if ([itemView respondsToSelector:@selector(setRepresentedObject:)])
                [itemView setRepresentedObject:object];
        if ([itemView respondsToSelector:@selector(setDelegate:)]) {
                id myDelegate = [self delegate];
                [itemView setDelegate:myDelegate];
        }
        
        return newItem;
}

@end

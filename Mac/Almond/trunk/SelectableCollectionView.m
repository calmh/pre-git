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
        self.itemHeight = 75;
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

@end
        
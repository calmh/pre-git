//
//  ADFolderCollection.m
//  Almond
//
//  Created by Jakob Borg on 7/8/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "RuleCollectionView.h"

@implementation RuleCollectionView

- (void)awakeFromNib {
        NSSize size;
        size.width = 0;
        size.height = 100;
        [self setMaxItemSize:size];
}

@end
        
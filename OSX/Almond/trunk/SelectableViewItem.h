//
//  ADFolderViewItem.h
//  Almond
//
//  Created by Jakob Borg on 7/15/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SelectableViewItem : NSCollectionViewItem {

}

-(void)setSelected:(BOOL)flag;
-(IBAction)openClicked:(id)sender;

@end

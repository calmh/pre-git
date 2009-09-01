//
//  WidgetTableController.h
//  Almond
//
//  Created by Jakob Borg on 8/29/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FormCell.h"

@interface WidgetTableController : NSObjectController <NSTableViewDelegate> {
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row;

@end

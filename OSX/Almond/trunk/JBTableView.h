//
//  JBTableView.h
//  Almond
//
//  Created by Jakob Borg on 8/8/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define MARGIN 5.0f

@class JBTableView;

@interface JBTableViewDatasource
- (int)numberOfRowsInTableView:(JBTableView*)tableView;
- (NSView*)tableView:(JBTableView*)tableView viewForRow:(int)row;
- (float)tableView:(JBTableView*)tableView heightForRow:(int)row;
@end

@interface JBTableView : NSView {
        JBTableViewDatasource *datasource;
}

@property (retain, nonatomic) JBTableViewDatasource *datasource;

@end

//
//  FolderViewController.h
//  Almond
//
//  Created by Jakob Borg on 9/4/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicViewController.h"

@interface FolderViewController : BasicViewController {
        NSArrayController *folderArrayController;
}

@property (retain, nonatomic) IBOutlet NSArrayController *folderArrayController;

- (IBAction)browseForFolder:(id)sender;

@end

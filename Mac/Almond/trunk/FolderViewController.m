//
//  FolderViewController.m
//  Almond
//
//  Created by Jakob Borg on 9/4/09.
//  Copyright 2009 Jakob Borg. All rights reserved.
//

#import "FolderViewController.h"


@implementation FolderViewController

@synthesize folderArrayController;

- (IBAction)browseForFolder:(id)sender {
        NSOpenPanel *dialog = [[NSOpenPanel alloc] init];
        [dialog setCanChooseFiles:NO];
        [dialog setCanChooseDirectories:YES];
        [dialog setResolvesAliases:YES];
        [dialog setCanCreateDirectories:YES];
        [dialog setAllowsMultipleSelection:NO];
        [dialog beginSheetModalForWindow:[self.appDelegate window] completionHandler:^ (NSInteger result) {
                if (result == NSFileHandlingPanelOKButton) {
                        NSManagedObject *folder = [NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext:[self managedObjectContext]];
                        [folder setPath:[[[dialog URLs] objectAtIndex:0] path]];        
                }
        }];
}

@end

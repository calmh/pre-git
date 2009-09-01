//
//  Almond_AppDelegate.h
//  Almond
//
//  Created by Jakob Borg on 9/1/09.
//  Copyright Jakob Borg 2009 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ValueTransformers.h"

@interface Almond_AppDelegate : NSObject 
{
    NSWindow *window;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) IBOutlet NSWindow *window;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

@property (retain, nonatomic) IBOutlet NSView *mainView;
@property (retain, nonatomic) IBOutlet NSView *folderView;
@property (retain, nonatomic) IBOutlet NSView *rulesView;

- (IBAction)saveAction:sender;
- (IBAction)changeToRuleView:(id)sender;
- (IBAction)changeToFolderView:(id)sender;

@end

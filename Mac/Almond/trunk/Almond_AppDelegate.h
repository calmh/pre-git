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
@property (retain, nonatomic) IBOutlet NSView *expressionsView;

@property (retain, nonatomic) IBOutlet NSView *folderDetailView;
@property (retain, nonatomic) IBOutlet NSView *ruleDetailView;

@property (retain, nonatomic) IBOutlet NSArrayController *folderArrayController;
@property (retain, nonatomic) IBOutlet NSArrayController *rulesArrayController;
@property (retain, nonatomic) IBOutlet NSDrawer *rightDrawer;

- (IBAction)saveAction:sender;
- (IBAction)browserForFolder:(id)sender;
- (IBAction)changeToRuleView:(id)sender;
- (IBAction)changeToFolderView:(id)sender;
- (IBAction)changeToExpressionsView:(id)sender;
- (IBAction)addNewRule:(id)sender;

@end
